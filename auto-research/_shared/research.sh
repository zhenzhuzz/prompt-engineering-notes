#!/bin/bash
# ============================================================================
# Auto-Research 睡前自动研究系统
# ============================================================================
# 用法: ./_shared/research.sh
# 功能: 自动研究 research-topics.json 中的主题，生成快速概览和深度报告
# ============================================================================

# Windows Git Bash 配置 (必须使用双反斜杠，因为 Claude CLI 对带空格路径+正斜杠的验证有 Bug)
export CLAUDE_CODE_GIT_BASH_PATH="C:\\Program Files\\Git\\bin\\bash.exe"

# 强制 UTF-8 编码 (避免 Windows GBK 与 Claude CLI UTF-8 输出混合导致乱码)
export PYTHONIOENCODING=utf-8
export LANG=en_US.UTF-8

# 调试模式 (设置 DEBUG=1 启用详细输出)
DEBUG="${DEBUG:-0}"
# API 重试次数
MAX_RETRIES="${MAX_RETRIES:-3}"
# 重试间隔 (秒)
RETRY_DELAY="${RETRY_DELAY:-30}"

# 调试输出函数
debug_log() {
    if [ "$DEBUG" = "1" ]; then
        local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        echo -e "${YELLOW}[DEBUG] [$timestamp] $1${NC}"
    fi
}

# 获取日期 (可通过参数覆盖)
DATE="${1:-$(date +%Y-%m-%d)}"

# 路径配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATE_FOLDER="$PROJECT_ROOT/$DATE"

# Git Bash 路径转 Windows 路径 (处理所有情况，使用正斜杠避免 Python 转义问题)
to_win_path() {
    local path="$1"
    # 优先使用 cygpath -m (混合模式: C:/... 而非 C:\...)
    # -m 输出正斜杠，避免 Python 把 \U 当作 unicode 转义
    if command -v cygpath &>/dev/null; then
        cygpath -m "$path"
    else
        # 标准 /d/... -> d:/... 转换
        echo "$path" | sed 's|^/\([a-zA-Z]\)/|\1:/|'
    fi
}

# Python 使用的路径 (Windows 格式)
TOPICS_FILE_WIN="$(to_win_path "$DATE_FOLDER/research-topics.json")"
TOPICS_FILE="$DATE_FOLDER/research-topics.json"
QUICK_OUTPUT_DIR="$DATE_FOLDER/output/quick"
DEEP_OUTPUT_DIR="$DATE_FOLDER/output/deep"
LOG_DIR="$DATE_FOLDER/logs"
LOG_FILE="$LOG_DIR/research.log"
QUICK_PROMPT_TEMPLATE="$SCRIPT_DIR/prompts/quick-overview.md"
DEEP_PROMPT_TEMPLATE="$SCRIPT_DIR/prompts/deep-research.md"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 日志函数
log() {
    local type="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    local color=""

    case "$type" in
        "INFO") color="$CYAN" ;;
        "SUCCESS") color="$GREEN" ;;
        "ERROR") color="$RED" ;;
        "WARN") color="$YELLOW" ;;
        *) color="$NC" ;;
    esac

    echo -e "${color}[$timestamp] [$type] $message${NC}"
    echo "[$timestamp] [$type] $message" >> "$LOG_FILE"
}

# Python JSON 解析辅助函数
json_get() {
    local file="$1"
    local query="$2"
    python -c "
import json
with open('$file', 'r', encoding='utf-8') as f:
    data = json.load(f)
$query
"
}

# 显示 Banner
show_banner() {
    echo ""
    echo -e "${CYAN}  ╔═══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}  ║           Auto-Research 睡前自动研究系统                      ║${NC}"
    echo -e "${CYAN}  ║                                                               ║${NC}"
    echo -e "${CYAN}  ║   睡前启动 → 自动研究 → 醒来看结果                            ║${NC}"
    echo -e "${CYAN}  ╚═══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    if [ "$DEBUG" = "1" ]; then
        echo -e "${YELLOW}  [DEBUG MODE 已启用]${NC}"
        echo -e "${YELLOW}  MAX_RETRIES=$MAX_RETRIES | RETRY_DELAY=${RETRY_DELAY}s${NC}"
        echo ""
    fi
}

# 初始化目录
init_directories() {
    log "INFO" "初始化目录结构..."

    mkdir -p "$DATE_FOLDER"
    mkdir -p "$QUICK_OUTPUT_DIR"
    mkdir -p "$DEEP_OUTPUT_DIR"
    mkdir -p "$LOG_DIR"

    touch "$LOG_FILE"

    log "SUCCESS" "目录初始化完成"
}

# 检查 research-topics.json
check_topics_file() {
    if [ ! -f "$TOPICS_FILE" ]; then
        log "WARN" "未找到 research-topics.json，创建示例文件..."

        cat > "$TOPICS_FILE" << 'EOF'
{
  "topics": [
    {
      "name": "示例主题",
      "query": "示例搜索关键词 2025",
      "description": "这是一个示例主题，请修改后重新运行"
    }
  ]
}
EOF

        log "WARN" "已创建示例文件: $TOPICS_FILE"
        log "WARN" "请编辑后重新运行"
        return 1
    fi
    return 0
}

# 执行研究任务 (带重试逻辑)
do_research() {
    local topic_name="$1"
    local query="$2"
    local description="$3"
    local prompt_template="$4"
    local output_file="$5"
    local research_type="$6"
    local meta_prefix="$7"

    log "INFO" "开始 $research_type: $topic_name"

    # 读取模板并替换变量
    local prompt=$(cat "$prompt_template")
    prompt="${prompt//\{\{TOPIC\}\}/$topic_name}"
    prompt="${prompt//\{\{QUERY\}\}/$query}"
    prompt="${prompt//\{\{DESCRIPTION\}\}/$description}"

    # 添加 meta 指令前缀 (如果有)
    if [[ -n "$meta_prefix" ]]; then
        prompt="$meta_prefix$prompt"
    fi

    debug_log "Prompt 模板: $prompt_template"
    debug_log "Prompt 长度: ${#prompt} 字符"

    local attempt=0
    local success=false

    while [ $attempt -lt $MAX_RETRIES ] && [ "$success" = "false" ]; do
        ((attempt++))

        if [ $attempt -gt 1 ]; then
            log "WARN" "重试第 $attempt 次 (共 $MAX_RETRIES 次): $topic_name"
            log "INFO" "等待 $RETRY_DELAY 秒后重试..."
            sleep $RETRY_DELAY
        fi

        local start_time=$(date +%s)

        # 使用临时文件避免变量嵌入破坏 Python 语法
        local temp_result=$(mktemp)
        debug_log "临时文件: $temp_result"

        log "INFO" "调用 Claude CLI... (尝试 $attempt/$MAX_RETRIES)"
        log "INFO" "⏳ 研究任务预计需要 2-5 分钟，请耐心等待..."

        # 后台显示进度点 (每 30 秒一个点)
        (
            while true; do
                sleep 30
                echo -n "." >&2
            done
        ) &
        local progress_pid=$!

        # 调用 Claude CLI (Headless Mode)，输出到临时文件
        claude -p "$prompt" \
            --allowedTools "WebSearch,WebFetch,Read,Write,Glob,Grep" \
            --output-format json > "$temp_result" 2>&1

        # 停止进度显示
        kill $progress_pid 2>/dev/null
        echo "" >&2

        local exit_code=$?
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        local duration_min=$(python -c "print(round($duration / 60, 1))")

        debug_log "Claude CLI 退出码: $exit_code"
        debug_log "耗时: ${duration_min} 分钟"
        debug_log "临时文件大小: $(wc -c < "$temp_result") 字节"

        # 检查临时文件内容
        local temp_result_win=$(to_win_path "$temp_result")
        local result_preview=$(head -c 200 "$temp_result" 2>/dev/null)
        debug_log "输出预览: ${result_preview:0:100}..."

        if [ $exit_code -eq 0 ]; then
            # 用 Python 读取临时文件并提取 result 字段
            # 错误检测也在 Python 中进行，避免 grep 匹配正文内容导致误判
            # 退出码: 0=成功, 1=解析失败, 2=API错误, 3=速率限制, 4=连接错误
            python -c "
import json
import sys
import re

with open('$temp_result_win', 'r', encoding='utf-8') as f:
    content = f.read()

try:
    data = json.loads(content)

    # 检查是否有 API 错误 (只检查 is_error 字段，不检查正文)
    if data.get('is_error', False):
        error_msg = str(data.get('result', 'Unknown error')).lower()

        # 检查连接错误
        if 'connection error' in error_msg:
            print('CONNECTION_ERROR', file=sys.stderr)
            sys.exit(4)

        # 检查速率限制 (只在 is_error=true 时检查)
        if any(x in error_msg for x in ['rate limit', 'rate_limit', 'too many requests', '429']):
            print('RATE_LIMIT', file=sys.stderr)
            sys.exit(3)

        # 其他 API 错误
        print(f'API_ERROR: {error_msg}', file=sys.stderr)
        sys.exit(2)

    # 成功情况：提取 result 字段
    if 'result' in data and data['result']:
        print(data['result'])
    else:
        print(content)
        sys.exit(1)

except json.JSONDecodeError as e:
    # JSON 解析失败，可能是非 JSON 输出
    print(f'JSON_PARSE_ERROR: {e}', file=sys.stderr)
    print(content)
    sys.exit(1)
except Exception as e:
    print(f'UNKNOWN_ERROR: {e}', file=sys.stderr)
    print(content)
    sys.exit(1)
" > "$output_file" 2>"${output_file}.stderr"

            local python_exit=$?
            local stderr_msg=$(cat "${output_file}.stderr" 2>/dev/null)
            debug_log "Python 退出码: $python_exit, stderr: $stderr_msg"

            case $python_exit in
                0)
                    # 成功
                    if [ -s "$output_file" ]; then
                        log "SUCCESS" "$research_type 完成: $topic_name (耗时 ${duration_min} 分钟)"
                        rm -f "$temp_result" "${output_file}.stderr"
                        success=true
                        return 0
                    else
                        debug_log "输出文件为空"
                    fi
                    ;;
                3)
                    # 速率限制
                    log "WARN" "API 速率限制 (尝试 $attempt/$MAX_RETRIES)，等待 60 秒..."
                    rm -f "$temp_result" "${output_file}.stderr" "$output_file"
                    sleep 60
                    continue
                    ;;
                4)
                    # 连接错误
                    log "WARN" "API 连接错误 (尝试 $attempt/$MAX_RETRIES)"
                    rm -f "$temp_result" "${output_file}.stderr" "$output_file"
                    continue
                    ;;
                2)
                    # 其他 API 错误
                    log "WARN" "API 返回错误: $stderr_msg"
                    rm -f "${output_file}.stderr"
                    ;;
                *)
                    # 解析失败或未知错误
                    debug_log "Python 处理失败: $stderr_msg"
                    ;;
            esac
        fi

        # 如果还有重试机会，不立即失败
        if [ $attempt -lt $MAX_RETRIES ]; then
            debug_log "准备重试..."
            rm -f "$temp_result"
        else
            # 最后一次尝试也失败了
            log "ERROR" "$research_type 失败: $topic_name (已重试 $MAX_RETRIES 次)"
            cp "$temp_result" "${output_file}.error.log"
            rm -f "$temp_result" "${output_file}.stderr"
            return 1
        fi
    done

    return 1
}

# 主函数
main() {
    show_banner

    log "INFO" "研究日期: $DATE"
    log "INFO" "项目根目录: $PROJECT_ROOT"

    # 初始化
    init_directories

    # 检查主题文件
    if ! check_topics_file; then
        return 1
    fi

    # 读取 meta 配置 (如果存在)
    local meta_instruction=""
    local meta_info=$(python -c "
import json
with open('$TOPICS_FILE_WIN', 'r', encoding='utf-8') as f:
    data = json.load(f)
meta = data.get('meta', {})
if meta:
    reader_bg = meta.get('reader_background', '')
    know_tpl = meta.get('know_template', '')
    instruction = meta.get('instruction', '')
    print(f'READER_BG={reader_bg}')
    print(f'KNOW_TPL={know_tpl}')
    print(f'INSTRUCTION={instruction}')
else:
    print('NO_META')
" 2>/dev/null)

    if [[ "$meta_info" != "NO_META" ]]; then
        local reader_bg=$(echo "$meta_info" | grep "^READER_BG=" | cut -d= -f2-)
        local know_tpl=$(echo "$meta_info" | grep "^KNOW_TPL=" | cut -d= -f2-)
        local instruction=$(echo "$meta_info" | grep "^INSTRUCTION=" | cut -d= -f2-)

        if [[ -n "$instruction" ]]; then
            # 构建 meta 指令前缀
            meta_instruction="## 全局指令

$instruction

"
            if [[ -n "$reader_bg" ]]; then
                meta_instruction+="**读者背景文件**: $DATE_FOLDER/$reader_bg (请先读取了解读者专业背景)
"
            fi
            if [[ -n "$know_tpl" ]]; then
                meta_instruction+="**KNOW 模板文件**: $DATE_FOLDER/$know_tpl (请按此格式撰写)
"
            fi
            meta_instruction+="
---

"
            log "INFO" "已加载 meta 配置 (读者背景 + KNOW 模板)"
        fi
    fi

    # 读取主题数量 (使用 Python)
    local topic_count=$(python -c "
import json
with open('$TOPICS_FILE_WIN', 'r', encoding='utf-8') as f:
    data = json.load(f)
print(len(data['topics']))
")

    log "INFO" "找到 $topic_count 个研究主题"
    echo ""

    # 检查模板文件
    if [ ! -f "$QUICK_PROMPT_TEMPLATE" ] || [ ! -f "$DEEP_PROMPT_TEMPLATE" ]; then
        log "ERROR" "Prompt 模板不存在，请检查 _shared/prompts/ 目录"
        return 1
    fi

    # 统计
    local completed=0
    local failed=0
    local total_start=$(date +%s)

    # 遍历主题 (使用 Python 生成循环)
    for i in $(seq 0 $((topic_count - 1))); do
        # 用 Python 读取主题信息 (包括测试标志)
        local topic_info=$(python -c "
import json
with open('$TOPICS_FILE_WIN', 'r', encoding='utf-8') as f:
    data = json.load(f)
topic = data['topics'][$i]
print(topic['name'])
print(topic['query'])
print(topic.get('description', topic['name']))
print('1' if topic.get('_skip_deep', False) else '0')
print('1' if topic.get('_test', False) else '0')
")

        # 解析输出
        local name=$(echo "$topic_info" | sed -n '1p')
        local query=$(echo "$topic_info" | sed -n '2p')
        local description=$(echo "$topic_info" | sed -n '3p')
        local skip_deep=$(echo "$topic_info" | sed -n '4p')
        local is_test=$(echo "$topic_info" | sed -n '5p')
        local safe_name=$(echo "$name" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]')

        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        if [ "$is_test" = "1" ]; then
            log "INFO" "🧪 测试主题 $((i+1))/$topic_count: $name"
        else
            log "INFO" "处理主题 $((i+1))/$topic_count: $name"
        fi
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"

        # ============ 快速概览 (已禁用 - Quick 对 Deep 无帮助) ============
        # local quick_file="$QUICK_OUTPUT_DIR/${safe_name}-quick.md"
        # if do_research "$name" "$query" "$description" "$QUICK_PROMPT_TEMPLATE" "$quick_file" "快速概览" "$meta_instruction"; then
        #     ((completed++))
        # else
        #     ((failed++))
        # fi

        # 深度报告 (除非设置了 _skip_deep)
        if [ "$skip_deep" = "1" ]; then
            log "INFO" "跳过深度报告 (测试模式)"
        else
            local deep_file="$DEEP_OUTPUT_DIR/${safe_name}-deep.md"
            if do_research "$name" "$query" "$description" "$DEEP_PROMPT_TEMPLATE" "$deep_file" "深度报告" "$meta_instruction"; then
                ((completed++))
            else
                ((failed++))
            fi
        fi

        # 主题间等待
        if [ $i -lt $((topic_count - 1)) ]; then
            log "INFO" "等待 60 秒后继续下一个主题..."
            sleep 60
        fi
    done

    # 总结
    local total_end=$(date +%s)
    local total_duration=$(python -c "print(round(($total_end - $total_start) / 60, 1))")

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}                        研究完成!                               ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
    log "INFO" "总计: $topic_count 个主题, $((topic_count * 2)) 个任务"
    log "INFO" "成功: $completed 个任务"
    log "INFO" "失败: $failed 个任务"
    log "INFO" "总耗时: ${total_duration} 分钟"
    echo ""
    log "INFO" "快速概览输出: $QUICK_OUTPUT_DIR"
    log "INFO" "深度报告输出: $DEEP_OUTPUT_DIR"
    log "INFO" "执行日志: $LOG_FILE"
    echo ""
}

# 运行
main "$@"
