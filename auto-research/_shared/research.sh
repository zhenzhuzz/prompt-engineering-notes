#!/bin/bash
# ============================================================================
# Auto-Research 睡前自动研究系统
# ============================================================================
# 用法: ./_shared/research.sh
# 功能: 自动研究 research-topics.json 中的主题，生成快速概览和深度报告
# ============================================================================

# Windows Git Bash 配置
export CLAUDE_CODE_GIT_BASH_PATH='D:\Git\bin\bash.exe'

# 获取日期 (可通过参数覆盖)
DATE="${1:-$(date +%Y-%m-%d)}"

# 路径配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
DATE_FOLDER="$PROJECT_ROOT/$DATE"
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

# 执行研究任务
do_research() {
    local topic_name="$1"
    local query="$2"
    local description="$3"
    local prompt_template="$4"
    local output_file="$5"
    local research_type="$6"

    log "INFO" "开始 $research_type: $topic_name"

    # 读取模板并替换变量
    local prompt=$(cat "$prompt_template")
    prompt="${prompt//\{\{TOPIC\}\}/$topic_name}"
    prompt="${prompt//\{\{QUERY\}\}/$query}"
    prompt="${prompt//\{\{DESCRIPTION\}\}/$description}"

    local start_time=$(date +%s)

    # 调用 Claude CLI (Headless Mode)
    local result=$(claude -p "$prompt" \
        --allowedTools "WebSearch,WebFetch,Read,Write,Glob,Grep" \
        --output-format json 2>&1)

    local exit_code=$?
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    local duration_min=$(python -c "print(round($duration / 60, 1))")

    if [ $exit_code -eq 0 ]; then
        # 用 Python 提取 result 字段
        python -c "
import json
import sys
try:
    data = json.loads('''$result''')
    if 'result' in data and data['result']:
        print(data['result'])
    else:
        print('''$result''')
except:
    print('''$result''')
" > "$output_file"

        if [ -s "$output_file" ]; then
            log "SUCCESS" "$research_type 完成: $topic_name (耗时 ${duration_min} 分钟)"
            return 0
        fi
    fi

    log "ERROR" "$research_type 失败: $topic_name"
    echo "$result" > "${output_file}.error.log"
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

    # 读取主题数量 (使用 Python)
    local topic_count=$(python -c "
import json
with open('$TOPICS_FILE', 'r', encoding='utf-8') as f:
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
        # 用 Python 读取主题信息
        local topic_info=$(python -c "
import json
with open('$TOPICS_FILE', 'r', encoding='utf-8') as f:
    data = json.load(f)
topic = data['topics'][$i]
print(topic['name'])
print(topic['query'])
print(topic.get('description', topic['name']))
")

        # 解析输出
        local name=$(echo "$topic_info" | sed -n '1p')
        local query=$(echo "$topic_info" | sed -n '2p')
        local description=$(echo "$topic_info" | sed -n '3p')
        local safe_name=$(echo "$name" | sed 's/[^a-zA-Z0-9]/-/g' | tr '[:upper:]' '[:lower:]')

        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
        log "INFO" "处理主题 $((i+1))/$topic_count: $name"
        echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"

        # 快速概览
        local quick_file="$QUICK_OUTPUT_DIR/${safe_name}-quick.md"
        if do_research "$name" "$query" "$description" "$QUICK_PROMPT_TEMPLATE" "$quick_file" "快速概览"; then
            ((completed++))
        else
            ((failed++))
        fi

        # 等待避免 rate limit
        log "INFO" "等待 30 秒..."
        sleep 30

        # 深度报告
        local deep_file="$DEEP_OUTPUT_DIR/${safe_name}-deep.md"
        if do_research "$name" "$query" "$description" "$DEEP_PROMPT_TEMPLATE" "$deep_file" "深度报告"; then
            ((completed++))
        else
            ((failed++))
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
