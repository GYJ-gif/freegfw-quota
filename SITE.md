# 中文说明网站维护

- 公开地址：https://gyj-gif.github.io/freegfw-quota/
- 网站文件：`docs/`，原生 HTML / CSS / JavaScript，无需安装依赖或构建。
- 当前发布源：`docs/guide-site` 分支的 `/docs` 目录，GitHub Pages 自动构建。
- 安装指令固定到 `5c2ee144becfc6579fdb42f379aa91494b31ea92`；不要直接改成 main，除非 main 已具备全新安装能力并经核对。
- 更新指令版本时，同时修改 `docs/index.html` 与 `docs/app.js` 中的版本和链接，并核对页面的版本状态文案。

## 本地预览

```bash
python -m http.server 8765 --bind 127.0.0.1 --directory docs
```

打开 http://127.0.0.1:8765 。至少检查手机布局、目录、文档搜索、复制命令、端口验证及主题切换。

## 发布与后续域名

向发布分支推送 `docs/` 的更新会触发 Pages 构建。若将网站合并到 main，可在仓库 Settings → Pages 将 Source 切换为 main /docs；不要在同一时间维护两套不同的网站源码。

目前不需要购买域名或租用说明网站服务器。以后提供希望使用的完整域名（例如 docs.example.com），并确保能修改它的 DNS；再按 GitHub Pages 的域名验证和 HTTPS 流程绑定。说明网站的域名与代理服务器 / 管理面板的域名是不同用途。

网页不收集用户数据、不接入分析统计，只有主题偏好存入浏览器 localStorage。
