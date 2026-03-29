# Markdown PDF Skill for OpenClaw

把 Markdown 文件转换成高质量 PDF，支持学术论文样式。

## 特性

- **字体**：使用 [LXGW WenKai](https://github.com/lxgw/LxgwWenKai)（霞鹜文楷）作为正文字体
- **字号**：正文 17pt，标题按层级递减（一级 22pt / 二级 19pt / 三级 17pt）
- **页面**：A4 纸，页边距 2.3cm
- **代码块**：Pygments 语法高亮 + 浅灰圆角卡片背景
- **链接**：彩色链接（蓝色）
- **任务清单**：支持 `- [ ]` / `- [x]` 渲染为方框符号
- **表格**：支持 grid table 样式
- **可选目录**：支持 `--toc` 生成目录

## 依赖

- `pandoc`（>= 3.0）
- `xelatex`（TeX Live）
- `LXGW WenKai` 字体（系统已安装）

## 使用方法

```bash
# 基本转换
render-markdown-pdf.sh 输入.md -o 输出.pdf

# 生成目录
render-markdown-pdf.sh 输入.md --toc

# 指定字体和字号
render-markdown-pdf.sh 输入.md --font "LXGW WenKai" --font-size 17pt
```

## 作为 OpenClaw Skill 使用

将此 skill 克隆到 OpenClaw 的 skills 目录后，直接在对话中调用即可。

## 主题

| 主题 | 说明 |
|------|------|
| `print-formal` | 学术印刷风格（默认） |
| `web-clean` | 简洁网页风格 |

## 协议

MIT
