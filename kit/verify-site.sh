#!/bin/bash
# 比對 docs/ 與正式站的實際內容:bash kit/verify-site.sh
#
# 部署由 GitHub Actions 負責(push 到 main 且動到 docs/ 就自動上傳),
# 但 workflow 跑完只代表 lftp 沒報錯,不代表線上真的是這一版。
# 這支腳本從外面抓線上檔案算 md5,跟本機 docs/ 對照,確認部署真的生效。
#
#   bash kit/verify-site.sh                  比對 docs/ 全部檔案
#   bash kit/verify-site.sh index.html ...   只比對指定檔案
#
# 不需要任何帳號密碼:它只讀公開網址。

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOCS="$ROOT/docs"
SITE="${SITE:-https://aletheia.to24tw.com}"

if [ $# -gt 0 ]; then
  FILES=("$@")
else
  FILES=()
  for p in "$DOCS"/*; do [ -f "$p" ] && FILES+=("$(basename "$p")"); done
fi

echo "本機 docs/  vs  $SITE"
same=0; diff=0; missing=0
for f in "${FILES[@]}"; do
  printf '  %-26s ' "$f"
  if [ ! -f "$DOCS/$f" ]; then echo "docs/ 裡沒有這個檔"; missing=$((missing+1)); continue; fi
  code=$(curl -sS -o /tmp/_vs.$$ -w '%{http_code}' --max-time 120 -H 'Cache-Control: no-cache' "$SITE/$f" 2>/dev/null)
  if [ "$code" != "200" ]; then
    echo "線上取不到(HTTP $code)"; diff=$((diff+1))
  elif [ "$(md5 -q "$DOCS/$f")" = "$(md5 -q /tmp/_vs.$$)" ]; then
    echo "一致"; same=$((same+1))
  else
    echo "不一致(本機 $(stat -f %z "$DOCS/$f") bytes / 線上 $(stat -f %z /tmp/_vs.$$) bytes)"; diff=$((diff+1))
  fi
  rm -f /tmp/_vs.$$
done

echo "一致 $same、不一致 $diff、缺檔 $missing"
if [ $diff -gt 0 ]; then
  echo "線上還不是最新版。剛 push 的話等 GitHub Actions 跑完再試;"
  echo "一直不一致就去 GitHub 的 Actions 分頁看 Deploy 有沒有失敗。"
fi
[ $((diff + missing)) -eq 0 ]
