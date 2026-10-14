# 文档维护

说明网站位于 `docs/`，使用 GitHub Pages 从 main 分支的 /docs 发布，无需构建。

本地预览：`python -m http.server 8765 --bind 127.0.0.1 --directory docs`。

修改部署行为时同步更新 README.md、docs/index.html 和 docs/app.js 中的安装说明。发布前检查手机布局、目录锚点、搜索、复制命令和端口验证。
