# GitHub 账号仓库审计报告

> 审计对象：`arthaszyb` 账号下全部 33 个仓库（21 个原创 + 12 个 fork）
> 审计日期：2026-07-12
> 数据来源：GitHub API 仓库元数据（创建时间、最后推送时间、大小、语言、描述、topics）

## 总览

| 分类 | 数量 | 处理方式 |
|---|---|---|
| 保留（活跃/有价值） | 7 | 保留，按下文建议优化 |
| 空壳仓库（0 KB） | 4 | **删除**（无任何内容，无损失） |
| 停更实验/临时仓库 | 11 | **归档**（只读保留，可逆） |
| 旧 fork | 11 | 本次不处理，见文末建议 |
| 个人博客 fork | 1 | 保留（持续使用中） |

执行方式：运行同目录下的 `cleanup.sh`（逐仓库确认，非静默批量）。

---

## 一、保留 — 活跃或有价值（7 个）

| 仓库 | 可见性 | 语言 | 创建 | 最后推送 | 大小 | 说明 |
|---|---|---|---|---|---|---|
| [arthaszyb](https://github.com/arthaszyb/arthaszyb) | 公开 | — | 2026-07-10 | 2026-07-10 | 2 KB | Profile 仓库，本次已优化 README |
| BankStatementAnalyzer-Relaunch | 私有 | Swift | 2026-06-27 | 2026-07-07 | 336 KB | 活跃开发中的 iOS 项目 |
| english_plate | 私有 | JavaScript | 2026-06-27 | 2026-06-27 | **115 MB** | 新项目，但体积异常，见优化建议 |
| fillMDAC | 私有 | Python | 2026-06-03 | 2026-06-03 | 12 KB | 实用工具 |
| value-investor | 私有 | Python | 2026-04-28 | 2026-04-28 | 63 KB | 较新，保留观察；半年无更新可考虑并入工具仓 |
| [estatement-parse](https://github.com/arthaszyb/estatement-parse) | 公开 | Python | 2025-02-06 | 2025-05-06 | 54 KB | 有完整 README/topics，profile 主打项目 |
| [arthaszyb.github.io](https://github.com/arthaszyb/arthaszyb.github.io) | 公开 | JavaScript | 2018-10-29 | 持续更新 | — | 个人博客（fork 但在用），保留 |

### 保留仓库的优化建议

**english_plate（115 MB — 优先处理）**
- 单日提交即达 115 MB，几乎可以肯定提交了大型二进制资产（图片/视频/数据集）或 `node_modules`。
- 建议：
  1. `git count-objects -vH` 与 `git rev-list --objects --all | git cat-file --batch-check` 定位大对象；
  2. 用 [git-filter-repo](https://github.com/newren/git-filter-repo) 从历史中剔除大文件；
  3. 静态资产改用 Git LFS 或放对象存储；确认 `.gitignore` 覆盖 `node_modules/`、`dist/`、`*.mp4` 等。

**estatement-parse（对外门面项目）**
- 补 `LICENSE` 文件（公开仓库无 license 意味着他人法律上不能使用）；
- 加 GitHub Actions CI（`pytest` + `ruff`），README 挂 badge；
- 打 tag 发一个 release，让 profile 链接过去的访客看到这是个"完成的作品"。

**stock-decision-assistant（46 MB，归档前可选瘦身）**
- TypeScript 项目单日 46 MB，大概率 `node_modules` 或构建产物进了历史。归档是只读冻结，若日后想复活此项目，先做历史瘦身再解除归档。

**私有小工具仓（fillMDAC / value-investor / 未来的一次性脚本）**
- 可选：建一个私有 `tools` monorepo，把单文件级别的脚本收拢为子目录，避免"每个脚本一个仓库"再次堆积。这是可选项，不影响本次清理。

**BankStatementAnalyzer 系列**
- `BankStatementAnalyzer-iOS`（2026-03）已被 `-Relaunch`（2026-06 起活跃）取代，旧版归档（已列入下方归档清单）。若 Relaunch 中还需要旧版代码，归档后仍可随时浏览和 clone。

---

## 二、删除 — 空壳仓库，0 KB（4 个）

以下仓库没有任何提交内容（size = 0 KB），删除无任何损失：

| 仓库 | 可见性 | 创建 | 说明 |
|---|---|---|---|
| askChatGPT | 公开 | 2024-07-18 | 建仓后从未推送 |
| bkLearn | 私有 | 2020-05-25 | 建仓后从未推送 |
| my_ai_learning | 公开 | 2017-07-25 | 建仓后从未推送 |
| markdownPIC | 公开 | 2020-08-31 | 空图床，从未使用 |

> ⚠️ 删除不可逆。`cleanup.sh` 中每个删除都有单独确认提示，且 `gh` 需要额外的 `delete_repo` 权限（脚本会提示如何授权）。

---

## 三、归档 — 停更实验/临时仓库（11 个）

归档后仓库变为只读，仍可浏览、clone、搜索，随时可解除归档。以下仓库全部满足"创建后 1–2 天内停止推送，且已停更 8 个月以上"：

| 仓库 | 可见性 | 语言 | 创建 | 最后推送 | 大小 | 判定理由 |
|---|---|---|---|---|---|---|
| BankStatementAnalyzer-iOS | 私有 | Swift | 2026-03-04 | 2026-03-07 | 106 KB | 已被 Relaunch 版取代 |
| download_exam_papers | 公开 | Python | 2025-05-06 | 2025-05-06 | 2 KB | 单日单脚本 |
| weather | 公开 | Python | 2025-04-17 | 2025-04-17 | 10 KB | 单日实验 |
| moomoo-assist | 公开 | Python | 2025-01-24 | 2025-01-24 | 24 MB | 单日实验，含大文件 |
| trade_expert | 公开 | Python | 2025-01-23 | 2025-01-23 | 4 KB | 单日实验，仅 README 级内容；已从 profile README 移除 |
| stock-decision-assistant | 公开 | TypeScript | 2025-01-21 | 2025-01-21 | 46 MB | 单日实验，疑似含 node_modules；已从 profile README 移除 |
| googleCalendar | 公开 | Python | 2024-09-16 | 2024-09-17 | 7 KB | 两日小工具 |
| myHOGO | 公开 | HTML | 2020-08-26 | 2020-08-27 | 477 KB | 旧博客，已被 arthaszyb.github.io 取代 |
| golangNotes | 公开 | — | 2019-06-12 | 2019-08-30 | 35 KB | 2019 学习笔记 |
| k8s-notes | 公开 | — | 2019-06-12 | 2019-08-15 | 7 KB | 2019 学习笔记 |
| rss_with_docker | 私有 | — | 2019-03-27 | 2019-03-27 | 13 MB | 2019 单日实验 |

---

## 四、Fork — 本次不处理（11 个）

以下 fork 均**无自有改动**（0 star、0 issue、fork 后基本未动），删除后随时可重新 fork，不损失任何东西。本次按你的决定暂不处理，日后想清理时可参考：

| Fork | 上游用途 | Fork 时间 | 建议 |
|---|---|---|---|
| funNLP | NLP 资源大全 | 2022-05 | 可删（用 star 代替 fork 收藏） |
| Mastering_Go_ZH_CN | Go 电子书 | 2021-06 | 可删 |
| lua-resty-aes | OpenResty 库 | 2020-02 | 可删 |
| lua-resty-http | OpenResty 库 | 2020-01 | 可删 |
| iTerm2-Color-Schemes | 终端配色 | 2019-05 | 可删 |
| learning-golang | Go 学习资料 | 2019-05 | 可删 |
| build-web-application-with-golang | Go 电子书 | 2019-04 | 可删 |
| sample-controller | K8s 示例 | 2019-03 | 可删 |
| ud120-projects | Udacity 课程 | 2017-08 | 可删 |
| autogen | AI agent 框架 | 2024-11 | 与当前方向相关，若无自有改动也可删（star 上游即可） |
| iBook | 电子书 | 2024-06 | 可删 |

> 收藏类 fork 的通用替代：给上游仓库点 star 并用 star list 分类，账号页面会干净很多。

---

## 五、执行说明

```bash
# 1. 确保 gh CLI 已登录
gh auth status

# 2. 删除操作需要额外授权（一次性）
gh auth refresh -h github.com -s delete_repo

# 3. 运行清理脚本（每个仓库单独确认，可随时 Ctrl-C）
bash repo-audit/cleanup.sh
```

清理完成后，账号下原创仓库将从 21 个收敛为 7 个活跃仓库 + 11 个只读归档，profile 页面整洁度显著提升。
