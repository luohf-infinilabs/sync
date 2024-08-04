# GitHub to Gitee Sync

这个项目用于将 GitHub 上的公开仓库自动同步到 Gitee。

## 功能

- 自动同步指定的 GitHub 仓库到 Gitee。
- 支持手动触发同步操作。
- 每天定时自动运行同步任务。

## 配置步骤

### 1. 创建 `sync-repos.yml`

在项目根目录下创建一个 `sync-repos.yml` 文件，配置要同步的仓库。

### 2. 配置 GitHub Secrets

在 GitHub 仓库的设置中添加以下 Secrets：

- **GITEE_PRIVATE_KEY**: Gitee 的 SSH 私钥。

### 3. GitHub Actions 工作流

项目中包含的 GitHub Actions 工作流位于 `.github/workflows/sync-to-gitee.yml`，该工作流会根据 `sync-repos.yml` 中的配置同步仓库。

### 4. 手动触发

您可以在 GitHub Actions 页面手动触发同步工作流。
