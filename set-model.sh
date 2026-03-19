#!/bin/bash

# Model selector script
# Usage: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/YOUR_USER/YOUR_REPO/main/set-model.sh)"

set -e

MODEL_FILE="$HOME/.zshenv"
VAR_NAME="ANTHROPIC_MODEL"

echo "========================================"
echo "  ANTHROPIC_MODEL 选择器"
echo "========================================"
echo ""
echo "请选择要设置的模型："
echo ""
echo "  1) qwen3.5-plus"
echo "  2) qwen3-max-2026-01-23"
echo "  3) qwen3-coder-next"
echo "  4) qwen3-coder-plus"
echo "  5) kimi-k2.5"
echo "  6) glm-5"
echo "  7) glm-4.7"
echo "  8) MiniMax-M2.5"
echo "  9) 删除 ANTHROPIC_MODEL 环境变量"
echo ""
echo -n "请输入选项 [1-9]: "

read -r choice

case $choice in
    1)
        selected_model="qwen3.5-plus"
        ;;
    2)
        selected_model="qwen3-max-2026-01-23"
        ;;
    3)
        selected_model="qwen3-coder-plus"
        ;;
    4)
        selected_model="qwen3-coder-next"
        ;;
    5)
        selected_model="kimi-k2.5"
        ;;
    6)
        selected_model="glm-5"
        ;;
    7)
        selected_model="glm-4.7"
        ;;
    8)
        selected_model="MiniMax-M2.5"
        ;;
    9)
        # 删除环境变量
        if [ -f "$MODEL_FILE" ]; then
            # 删除已存在的 ANTHROPIC_MODEL 行
            if grep -q "export $VAR_NAME=" "$MODEL_FILE" 2>/dev/null; then
                # macOS 兼容的 sed 命令
                sed -i '' "/export $VAR_NAME=/d" "$MODEL_FILE" 2>/dev/null || \
                sed -i "/export $VAR_NAME=/d" "$MODEL_FILE" 2>/dev/null
                echo ""
                echo "✅ 已从 $MODEL_FILE 删除 $VAR_NAME 环境变量"
            else
                echo ""
                echo "⚠️  $VAR_NAME 在 $MODEL_FILE 中不存在"
            fi
        else
            echo ""
            echo "⚠️  $MODEL_FILE 文件不存在"
        fi
        echo ""
        echo "请运行: source $MODEL_FILE 或重新打开终端使更改生效"
        exit 0
        ;;
    *)
        echo ""
        echo "❌ 无效选项，请重新运行脚本"
        exit 1
        ;;
esac

# 确保 .zshenv 文件存在
touch "$MODEL_FILE"

# 如果已存在该环境变量，先删除
if grep -q "export $VAR_NAME=" "$MODEL_FILE" 2>/dev/null; then
    sed -i '' "/export $VAR_NAME=/d" "$MODEL_FILE" 2>/dev/null || \
    sed -i "/export $VAR_NAME=/d" "$MODEL_FILE" 2>/dev/null
fi

# 添加新的环境变量
echo "export $VAR_NAME=\"$selected_model\"" >> "$MODEL_FILE"

echo ""
echo "✅ 已设置 $VAR_NAME=\"$selected_model\""
echo ""
echo "请运行: source $MODEL_FILE 或重新打开终端使更改生效"

# 删除自身（如果是从远程下载运行的）
# 获取脚本路径
SCRIPT_PATH="${BASH_SOURCE[0]}"

# 只有当脚本存在于本地文件系统时才删除
if [ -f "$SCRIPT_PATH" ] && [[ "$SCRIPT_PATH" != "/dev/"* ]]; then
    rm -f "$SCRIPT_PATH" 2>/dev/null || true
fi
