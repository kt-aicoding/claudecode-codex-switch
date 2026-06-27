# 生图与 README 配图工具调研

调研日期：2026-06-27

本页记录 kt-aicoding 项目生成 README 图示、logo、banner、CLI 动图和宣传图时可以使用的工具。结论先行：CLI / skill / MCP 项目的 README 配图，优先使用可提交到仓库的 SVG、图示源码和本地渲染脚本；AI 生图更适合做 logo / banner 的方向稿，不建议把免费 AI 输出直接作为商业品牌定稿。

## 快速结论

| 场景 | 首选 | 免费情况 | 说明 |
| --- | --- | --- | --- |
| README 静态图示 | SVG assets | 免费、本地、可提交 | 当前仓库已使用 `assets/readme/*.svg` |
| README 图示预览 | `scripts/export-readme-images.sh` | 免费、本地 | 支持 `rsvg-convert`、`resvg`、ImageMagick、macOS `sips` |
| 代码化 banner / OG 图 | Satori + resvg-js + Sharp | 开源，MPL-2.0 / Apache-2.0 | 适合后续做统一图片生成器 |
| 复杂 HTML/CSS 截图 | Playwright screenshots | 开源，Apache-2.0 | 最接近真实浏览器渲染 |
| CLI 动图 | VHS | 开源，MIT | 适合录制 `ccuse` / `codexuse` 使用演示 |
| 手绘风图示 | Excalidraw | 开源，MIT | 适合概念图，导出 SVG 后引用 |
| 工程流程图 | draw.io / D2 / Graphviz / PlantUML | 多数免费开源 | 建议预渲染成 SVG 再放 README |
| 本地 AI 生图 | ComfyUI / Diffusers | 工具免费，模型许可另算 | 适合宣传图和 logo 方向稿 |
| 云端 AI 生图 | OpenAI / Gemini / FLUX / Ideogram | 多为付费 API 或免费试稿 | 适合高质量初稿和自动化，但要算成本 |

## 免费的层级

| 类型 | 含义 | 例子 | 注意 |
| --- | --- | --- | --- |
| 真免费本地 | 工具可离线跑，不依赖云额度 | SVG、Playwright、本地 `sips`、ComfyUI、Diffusers | AI 模型权重许可仍需单独检查 |
| 免费开源库 | 可作为项目依赖或脚本组件 | Satori、resvg-js、Sharp、html-to-image | 注意 GPL / AGPL / MPL 等许可证边界 |
| 免费计划 / 免费额度 | 云服务给个人试用额度 | Napkin、Figma Starter、Canva、Ideogram、Krea | 免费图可能公开、带水印或不可商用 |
| 付费 API | 按张、token、credit 计费 | OpenAI Images、Gemini image、BFL FLUX、Ideogram API | 适合自动化，但需要预算控制 |
| 条件免费 | 个人或小团队免费，超出条件收费 | Remotion | 不是无条件免费开源工具 |

## 本地与开源工具

| 工具 | 免费 / 许可证 | 适合场景 | 备注 |
| --- | --- | --- | --- |
| SVG 模板 | Web 标准 | README 架构图、状态卡、命令速查 | 最可维护，适合直接提交 |
| macOS `sips` | 系统工具 | SVG 转 PNG 预览 | 当前本机已验证可用 |
| Satori | MPL-2.0 | JSX / HTML-like 生成 SVG | 适合统一生成 README banner |
| resvg-js | MPL-2.0 | SVG 转 PNG | 可替代系统渲染器 |
| Sharp | Apache-2.0 | 图片压缩、resize、格式转换 | 适合批处理产物 |
| Playwright | Apache-2.0 | 网页截图、复杂 CSS 渲染 | 需要固定浏览器和字体环境 |
| html-to-image | MIT | 浏览器内 DOM 导出图片 | 更适合前端运行时 |
| node-html-to-image | Apache-2.0 | Node 中 HTML 转图 | 基于 Puppeteer，体积较大 |
| hyperHTML | ISC | HTML / DOM 模板 | 不是生图工具，可配合截图管线 |
| VHS | MIT | 终端录制 GIF / MP4 | CLI 项目 README 很适合 |
| Carbon / carbon-now-cli | MIT | 代码截图 | 代码正文仍应保留可复制文本 |
| Excalidraw | MIT | 手绘风流程图 | 保存源文件再导出 SVG |
| draw.io / diagrams.net | Apache-2.0 | 可视化流程图、架构图 | 图标 / stencil 可能有额外条款 |
| D2 | MPL-2.0 | 文本生成现代架构图 | GitHub README 不原生渲染，需预导出 |
| Graphviz | EPL-2.0 | 自动布局、依赖图、状态机 | 审美需要调样式 |
| PlantUML | 多许可证 | UML、时序图、C4 | 需要 Java，注意发行许可证 |
| Kroki | MIT | 多图示 DSL 统一渲染 | 私有 / CI 建议自托管 |
| Remotion | 条件免费 | 视频、动态封面、发布素材 | 个人、小团队和非营利更适合；公司规模需看许可证 |

## 本地 AI 生图

| 工具 | 是否免费本地 | 适合场景 | 风险 |
| --- | --- | --- | --- |
| ComfyUI | 是，GPL-3.0；模型另算 | 节点式工作流、宣传图、批量生成 | 学习成本高，插件 / 模型许可需分别检查 |
| Diffusers | 是，Apache-2.0；模型另算 | Python 自动化、CI、后端 pipeline | 需要写代码和处理显存 |
| InvokeAI | 是，Apache-2.0；模型另算 | 画布、局部修图、交互迭代 | 极复杂工作流不如 ComfyUI 灵活 |
| Fooocus | 是，GPL-3.0；模型另算 | 低门槛 SDXL 出图 | 项目进入 LTS，不适合作为新模型长期主线 |
| AUTOMATIC1111 | 是，AGPL-3.0；模型另算 | SD 老生态、插件、LoRA | AGPL 对网络服务和修改分发更敏感 |
| Ollama image generation | 部分相关，实验性 | CLI 快速试验 | 不是当前最成熟的生图工作流 |
| stable-diffusion.cpp | 是，MIT | C/C++ 本地扩散模型推理 | CPU 可跑但慢，适合轻量验证 |

模型许可要单独记录。相对更适合免费 / 商用友好的方向包括 `FLUX.1 schnell`、`FLUX.2 klein 4B` 等 Apache-2.0 权重；`FLUX dev`、`FLUX.2 dev`、部分社区 LoRA 可能是非商业或有限用途。Stable Diffusion 3.5 还有收入门槛相关的 Community License 条款。

## 云端 AI 生图与免费额度

| 工具 | 免费情况 | API | 适合场景 | 商用注意 |
| --- | --- | --- | --- | --- |
| OpenAI Images | 通常按量计费，未见固定免费图像额度 | 有 | 自动化 banner、产品图、带文字视觉 | 输出权利不等于商标可注册 |
| Gemini / Nano Banana | 消费端可能免费试用，API 图像模型多为付费 | 有 | 信息图、多语言文字、宣传图 | 免费 / 付费层数据和额度不同 |
| FLUX / Black Forest Labs | Playground 可试，API 付费；部分权重可本地 | 有 | 高质量产品图、海报 | 不同 FLUX 权重许可证差异大 |
| Midjourney | 主要是订阅，无官方公开 API | 无官方公开 API | 高审美概念视觉 | 不适合官方 API 自动化 |
| Adobe Firefly | 有免费计划 / credits | 有企业向 API | 商业安全优先的素材 | partner models 需另查 |
| Canva AI | Free plan 有 AI 使用额度 | 无独立生图 API | 快速 banner、社媒图 | 模板 / 素材 / AI 输出授权组合复杂 |
| Figma AI | Starter 有 AI credits | 非独立生图 API | README 结构图、排版、mock | 更偏设计和原型 |
| Napkin AI | Free plan 有 credits，免费导出带品牌 | 未见公开按量 API | README 解释图、流程图 | 正式图建议付费去品牌 / 导 SVG |
| Ideogram | 免费每周 slow credits，免费图公开 | 有 | 字标、带文字海报 | 免费层不适合保密品牌 |
| Leonardo AI | 有免费层，API 新账号有试用 credit | 有 | 插画、概念图 | 免费层图像可能公开 / 可被平台使用 |
| Krea | Free 有每日 compute units | 未见清晰公开 API | 快速风格探索 | 商业 license 从付费层更明确 |
| Recraft | 免费层授权表述需复核 | 有 | 矢量风 logo、图标 | 免费层不建议商用定稿 |

## 推荐给 kt-aicoding 的标准方案

每个 CLI / skill / MCP 项目都可以采用同一套结构：

```text
assets/
  readme/
    overview.svg
    config-flow.svg
docs/
  image-tools.md
scripts/
  export-readme-images.sh
tmp/
  readme-images/
```

推荐规则：

- README 中优先引用 `assets/readme/*.svg`。
- 如果需要社媒或平台兼容，再导出 PNG，不默认提交 PNG。
- 可编辑源文件放在 `assets/readme/source/` 或 `docs/diagrams/`，例如 `.drawio`、`.excalidraw`、`.d2`。
- 生成图像时记录工具、模型、许可证、prompt、seed、生成日期。
- 免费 AI 工具用于试稿，品牌 logo / 商业宣传图必须人工复核、矢量整理和商标检索。

## 当前仓库已验证

本机可用：

```text
node / npm / pnpm / bun
ffmpeg
playwright
macOS qlmanage / sips
```

已验证 `sips` 可将当前 README SVG 导出为 PNG：

```bash
scripts/export-readme-images.sh
```

默认输出到：

```text
tmp/readme-images/
```

## 资料来源

- Remotion license: https://www.remotion.dev/docs/license
- Satori: https://github.com/vercel/satori
- resvg-js: https://github.com/thx/resvg-js
- Sharp: https://sharp.pixelplumbing.com/
- Playwright screenshots: https://playwright.dev/docs/screenshots
- html-to-image: https://github.com/bubkoo/html-to-image
- node-html-to-image: https://github.com/frinyvonnick/node-html-to-image
- hyperHTML: https://github.com/WebReflection/hyperhtml
- VHS: https://github.com/charmbracelet/vhs
- Excalidraw: https://github.com/excalidraw/excalidraw
- draw.io: https://github.com/jgraph/drawio
- D2: https://github.com/terrastruct/d2
- Graphviz: https://graphviz.org/
- PlantUML: https://plantuml.com/
- Kroki: https://kroki.io/
- ComfyUI: https://github.com/comfyanonymous/ComfyUI
- Diffusers: https://github.com/huggingface/diffusers
- InvokeAI: https://github.com/invoke-ai/InvokeAI
- Fooocus: https://github.com/lllyasviel/Fooocus
- AUTOMATIC1111: https://github.com/AUTOMATIC1111/stable-diffusion-webui
- stable-diffusion.cpp: https://github.com/leejet/stable-diffusion.cpp
- OpenAI image generation: https://developers.openai.com/api/docs/guides/image-generation
- Gemini image generation: https://ai.google.dev/gemini-api/docs/image-generation
- Black Forest Labs pricing: https://docs.bfl.ai/quick_start/pricing
- Midjourney plans: https://docs.midjourney.com/hc/en-us/articles/27870484040333-Comparing-Midjourney-Plans
- Adobe Firefly plans: https://www.adobe.com/products/firefly/plans.html
- Canva AI access: https://www.canva.com/help/ai-access/
- Figma pricing: https://www.figma.com/pricing/
- Napkin pricing: https://www.napkin.ai/pricing/
- Ideogram API pricing: https://ideogram.ai/api-pricing/
- Leonardo API: https://leonardo.ai/api
- Krea pricing: https://www.krea.ai/pricing
- Recraft pricing: https://www.recraft.ai/pricing
