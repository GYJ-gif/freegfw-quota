# 文档维护

说明网站位于 `docs/`，GitHub Pages 从 main 分支的 /docs 发布，无需构建。自定义域名由 docs/CNAME 保留。

- `index.html` / `home.js`：浅色紫调首页，旧章节链接转到指南。
- `guide.html` / `app.js`：分章部署与使用说明，支持搜索、端口命令生成、章节导航和手机菜单。
- `style.css`：共享样式；默认浅色，指南支持切换深色。

本地预览：`python -m http.server 8773 --bind 127.0.0.1 --directory docs`。

修改部署行为时同步 README.md、guide.html 和 app.js。发布前检查桌面和手机布局、章节切换、旧链接、搜索、复制命令和端口验证。

视觉参考：[FreeGFW](https://freegfw.com/zh) 的首页层次，以及 [Fumadocs](https://github.com/fuma-nama/fumadocs) 的文档导航与紫色主题。页面自行实现，未复制参考项目源码。
