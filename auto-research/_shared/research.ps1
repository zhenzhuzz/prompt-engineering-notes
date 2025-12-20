# ============================================================================
# Auto-Research 睡前自动研究系统
# ============================================================================
# 用法: .\_shared\research.ps1
# 功能: 自动研究 research-topics.json 中的主题，生成快速概览和深度报告
# ============================================================================

param(
    [string]$Date = (Get-Date -Format "yyyy-MM-dd")
)

# ============================================================================
# Windows Git Bash 配置 (Claude CLI 需要)
# ============================================================================
$env:CLAUDE_CODE_GIT_BASH_PATH = "D:\Git\bin\bash.exe"

# 配置
$ScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptRoot
$DateFolder = Join-Path $ProjectRoot $Date
$TopicsFile = Join-Path $DateFolder "research-topics.json"
$QuickOutputDir = Join-Path $DateFolder "output\quick"
$DeepOutputDir = Join-Path $DateFolder "output\deep"
$LogDir = Join-Path $DateFolder "logs"
$LogFile = Join-Path $LogDir "research.log"
$QuickPromptTemplate = Join-Path $ScriptRoot "prompts\quick-overview.md"
$DeepPromptTemplate = Join-Path $ScriptRoot "prompts\deep-research.md"

# 颜色输出函数
function Write-Status {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Type) {
        "INFO" { "Cyan" }
        "SUCCESS" { "Green" }
        "ERROR" { "Red" }
        "WARN" { "Yellow" }
        default { "White" }
    }
    Write-Host "[$timestamp] [$Type] $Message" -ForegroundColor $color
    Add-Content -Path $LogFile -Value "[$timestamp] [$Type] $Message"
}

# 显示 Banner
function Show-Banner {
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║           Auto-Research 睡前自动研究系统                      ║" -ForegroundColor Cyan
    Write-Host "  ║                                                               ║" -ForegroundColor Cyan
    Write-Host "  ║   睡前启动 → 自动研究 → 醒来看结果                            ║" -ForegroundColor Cyan
    Write-Host "  ╚═══════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

# 初始化目录
function Initialize-Directories {
    Write-Status "初始化目录结构..."

    # 创建日期文件夹
    if (-not (Test-Path $DateFolder)) {
        New-Item -ItemType Directory -Path $DateFolder -Force | Out-Null
        Write-Status "创建日期文件夹: $Date"
    }

    # 创建子目录
    @($QuickOutputDir, $DeepOutputDir, $LogDir) | ForEach-Object {
        if (-not (Test-Path $_)) {
            New-Item -ItemType Directory -Path $_ -Force | Out-Null
        }
    }

    # 初始化日志文件
    if (-not (Test-Path $LogFile)) {
        New-Item -ItemType File -Path $LogFile -Force | Out-Null
    }

    Write-Status "目录初始化完成" "SUCCESS"
}

# 检查 research-topics.json
function Test-TopicsFile {
    if (-not (Test-Path $TopicsFile)) {
        Write-Status "未找到 research-topics.json，创建示例文件..." "WARN"

        $exampleTopics = @{
            topics = @(
                @{
                    name = "示例主题"
                    query = "示例搜索关键词 2025"
                    description = "这是一个示例主题，请修改后重新运行"
                }
            )
        }

        $exampleTopics | ConvertTo-Json -Depth 10 | Out-File -FilePath $TopicsFile -Encoding UTF8

        Write-Status "已创建示例 research-topics.json，请编辑后重新运行" "WARN"
        Write-Host ""
        Write-Host "文件位置: $TopicsFile" -ForegroundColor Yellow
        Write-Host ""

        # 打开文件让用户编辑
        Start-Process notepad $TopicsFile

        return $false
    }
    return $true
}

# 读取 Prompt 模板
function Get-PromptTemplate {
    param([string]$TemplatePath)

    if (Test-Path $TemplatePath) {
        return Get-Content -Path $TemplatePath -Raw -Encoding UTF8
    } else {
        Write-Status "Prompt 模板不存在: $TemplatePath" "ERROR"
        return $null
    }
}

# 执行单个研究任务
function Invoke-Research {
    param(
        [string]$TopicName,
        [string]$Query,
        [string]$Description,
        [string]$PromptTemplate,
        [string]$OutputFile,
        [string]$ResearchType
    )

    Write-Status "开始 $ResearchType : $TopicName"

    # 替换模板变量
    $prompt = $PromptTemplate -replace '\{\{TOPIC\}\}', $TopicName
    $prompt = $prompt -replace '\{\{QUERY\}\}', $Query
    $prompt = $prompt -replace '\{\{DESCRIPTION\}\}', $Description

    # 调用 Claude Code
    $startTime = Get-Date

    try {
        $result = claude -p $prompt `
            --allowedTools "WebSearch,WebFetch,Read,Write,Glob,Grep" `
            --output-format json 2>&1

        # 解析 JSON 结果
        $jsonResult = $result | ConvertFrom-Json -ErrorAction SilentlyContinue

        if ($jsonResult -and $jsonResult.result) {
            $jsonResult.result | Out-File -FilePath $OutputFile -Encoding UTF8
            $duration = ((Get-Date) - $startTime).TotalMinutes
            Write-Status "$ResearchType 完成: $TopicName (耗时 $([math]::Round($duration, 1)) 分钟)" "SUCCESS"
            return $true
        } else {
            # 如果不是 JSON，直接保存原始输出
            $result | Out-File -FilePath $OutputFile -Encoding UTF8
            $duration = ((Get-Date) - $startTime).TotalMinutes
            Write-Status "$ResearchType 完成: $TopicName (耗时 $([math]::Round($duration, 1)) 分钟)" "SUCCESS"
            return $true
        }
    }
    catch {
        Write-Status "$ResearchType 失败: $TopicName - $_" "ERROR"
        return $false
    }
}

# 主函数
function Start-Research {
    Show-Banner

    Write-Status "研究日期: $Date"
    Write-Status "项目根目录: $ProjectRoot"

    # 初始化
    Initialize-Directories

    # 检查主题文件
    if (-not (Test-TopicsFile)) {
        return
    }

    # 读取主题
    $topics = Get-Content -Path $TopicsFile -Raw -Encoding UTF8 | ConvertFrom-Json
    $topicCount = $topics.topics.Count

    Write-Status "找到 $topicCount 个研究主题"
    Write-Host ""

    # 读取 Prompt 模板
    $quickTemplate = Get-PromptTemplate -TemplatePath $QuickPromptTemplate
    $deepTemplate = Get-PromptTemplate -TemplatePath $DeepPromptTemplate

    if (-not $quickTemplate -or -not $deepTemplate) {
        Write-Status "Prompt 模板加载失败，请检查 _shared/prompts/ 目录" "ERROR"
        return
    }

    # 统计
    $completed = 0
    $failed = 0
    $totalStart = Get-Date

    # 遍历主题
    foreach ($topic in $topics.topics) {
        $name = $topic.name
        $query = $topic.query
        $description = if ($topic.description) { $topic.description } else { $name }
        $safeName = $name -replace '[^\w\-]', '-'

        Write-Host ""
        Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Status "处理主题: $name"
        Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan

        # 快速概览
        $quickFile = Join-Path $QuickOutputDir "$safeName-quick.md"
        $quickResult = Invoke-Research `
            -TopicName $name `
            -Query $query `
            -Description $description `
            -PromptTemplate $quickTemplate `
            -OutputFile $quickFile `
            -ResearchType "快速概览"

        # 等待一下，避免 rate limit
        Write-Status "等待 30 秒..."
        Start-Sleep -Seconds 30

        # 深度报告
        $deepFile = Join-Path $DeepOutputDir "$safeName-deep.md"
        $deepResult = Invoke-Research `
            -TopicName $name `
            -Query $query `
            -Description $description `
            -PromptTemplate $deepTemplate `
            -OutputFile $deepFile `
            -ResearchType "深度报告"

        if ($quickResult -and $deepResult) {
            $completed++
        } else {
            $failed++
        }

        # 主题之间等待
        Write-Status "等待 60 秒后继续下一个主题..."
        Start-Sleep -Seconds 60
    }

    # 总结
    $totalDuration = ((Get-Date) - $totalStart).TotalMinutes

    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "                        研究完成!                               " -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Status "总计: $topicCount 个主题"
    Write-Status "成功: $completed 个"
    Write-Status "失败: $failed 个"
    Write-Status "总耗时: $([math]::Round($totalDuration, 1)) 分钟"
    Write-Host ""
    Write-Status "快速概览输出: $QuickOutputDir"
    Write-Status "深度报告输出: $DeepOutputDir"
    Write-Status "执行日志: $LogFile"
    Write-Host ""
}

# 运行
Start-Research
