# ============================================
# Bosai Architect — Cloudflare Pages Deploy
# Setup Script (PowerShell, Windows 11)
# ============================================
#
# 使い方:
#   1. このスクリプトを bosai-architect-deploy フォルダで実行
#   2. GitHub の Personal Access Token を環境変数 GITHUB_TOKEN に設定
#      (またはコマンド実行時に push 時にプロンプトでパスワード入力)
#   3. このスクリプトは git push まで自動化
#   4. Cloudflare Pages 側の連携は Web UI で手動設定（最後の説明参照）
#
# 前提:
#   - git がインストール済み (winget install Git.Git)
#   - GitHub の tatarat-code アカウントでログイン済み
#   - 新規 public repo "bosai-architect" を https://github.com/new で先に作成
#     (Add README は OFF にすること)
# ============================================

$ErrorActionPreference = "Stop"

# --- 設定 ---
$RepoUrl     = "https://github.com/tatarat-code/bosai-architect.git"  # ★ GitHubアカウント名を確認
$BranchName  = "main"
$CommitMsg   = "Initial commit: Bosai Architect v0.7 Mobile Ready"

# --- 作業ディレクトリ確認 ---
Write-Host "[1/5] 作業ディレクトリ確認..." -ForegroundColor Cyan
if (-not (Test-Path "./index.html")) {
    Write-Host "  ✗ index.html が見つかりません。" -ForegroundColor Red
    Write-Host "    このスクリプトは index.html, README.md, .gitignore と同じフォルダで実行してください。" -ForegroundColor Yellow
    exit 1
}
Write-Host "  ✓ ファイル確認 OK" -ForegroundColor Green

# --- git 初期化 ---
Write-Host "[2/5] git リポジトリ初期化..." -ForegroundColor Cyan
if (Test-Path ".git") {
    Write-Host "  ✓ 既存の .git を検出、スキップ" -ForegroundColor Green
} else {
    git init -b $BranchName
    Write-Host "  ✓ git init 完了" -ForegroundColor Green
}

# --- ファイル追加・コミット ---
Write-Host "[3/5] ファイル追加・コミット..." -ForegroundColor Cyan
git add .
git commit -m $CommitMsg
Write-Host "  ✓ コミット完了" -ForegroundColor Green

# --- リモート設定 ---
Write-Host "[4/5] リモート設定..." -ForegroundColor Cyan
$existingRemote = git remote 2>$null
if ($existingRemote -contains "origin") {
    git remote set-url origin $RepoUrl
    Write-Host "  ✓ 既存リモートを更新" -ForegroundColor Green
} else {
    git remote add origin $RepoUrl
    Write-Host "  ✓ origin 追加" -ForegroundColor Green
}

# --- push ---
Write-Host "[5/5] GitHub へ push..." -ForegroundColor Cyan
git push -u origin $BranchName
Write-Host "  ✓ push 完了" -ForegroundColor Green

# --- 次の手順案内 ---
Write-Host ""
Write-Host "============================================" -ForegroundColor Yellow
Write-Host "  GitHub 側の作業はここまで完了。" -ForegroundColor Yellow
Write-Host "  次は Cloudflare Pages 側の設定を行います:" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "  [A] https://dash.cloudflare.com/ にログイン" -ForegroundColor White
Write-Host "  [B] 左メニュー: Workers & Pages → Create application → Pages → Connect to Git" -ForegroundColor White
Write-Host "  [C] GitHub リポジトリ 'bosai-architect' を選択" -ForegroundColor White
Write-Host "  [D] ビルド設定:" -ForegroundColor White
Write-Host "        - Production branch: main" -ForegroundColor Gray
Write-Host "        - Build command:     (空欄)" -ForegroundColor Gray
Write-Host "        - Build output dir:  /" -ForegroundColor Gray
Write-Host "  [E] Save and Deploy を押下" -ForegroundColor White
Write-Host "  [F] 数十秒待って完成:" -ForegroundColor White
Write-Host "        → https://bosai-architect.pages.dev/" -ForegroundColor Cyan
Write-Host ""
Write-Host "  以降、git push するだけで自動デプロイされます。" -ForegroundColor Yellow
Write-Host ""
