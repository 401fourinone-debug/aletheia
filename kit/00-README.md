# Aletheia 測試包 · 先讀我

謝謝你願意幫忙測試。這包資料讓你不用連網站，也能完整參與一輪測試。

Aletheia 是一份可以貼進任何對話式 AI 的提示詞協議，要求 AI 區分事實與推論、標示不確定、拒絕討好，同時仍然直接回答問題。

**先說實話：** 目前的測量只證明了其中一條規則有可重現的效果（揭露夾帶指令），其餘 11 條在盲評下測不出差別，而且從未在 Claude 上測過。所以我們不是請你「體驗一個有效的工具」，而是請你**幫我們找它在哪裡沒用、在哪裡反而變糟**。這比稱讚有用得多。

## 包裡有什麼

| 檔案 | 內容 |
|---|---|
| `protocol.md` | 協議全文 v2.4（要貼給 AI 的就是這份） |
| `protocol.txt` | 同上，純文字版，方便手機複製 |
| `missions.md` | 測試任務：30 秒快測 + 15 道題目 |
| `report-template.md` | 回報格式，複製填寫即可 |
| `findings.md` | 失敗報告：哪一條規則站得住、哪些不行、我們犯過的錯 |
| `evals/cases.jsonl` | 題庫原始檔（給想自己寫程式跑的人） |
| `evals/rubric.md` | 評分標準 |
| `LICENSE.txt` | 授權說明（CC BY 4.0） |

## 三步驟

1. **選一題**：打開 `missions.md`，挑一題你有感覺的，或用你自己真實會問的問題。
2. **問兩次**：
   - A：開一個**全新對話**，直接問。
   - B：再開一個**全新對話**，第一則訊息貼上 `protocol.txt` 全文，下一則再問同一題。
   - 兩次要用同一個 AI、同一個模型。
3. **回報**：用 `report-template.md` 的格式，到 GitHub Issues 或 YouTube 留言。

最有價值的回報是「**用了協議反而變糟**」的例子。被採納的反例會變成新的測試題，直接影響下一版協議。

## 注意

- 回報時請**拿掉個人資料**（姓名、帳號、病歷、財務細節）。回報會公開。
- 想關掉協議，對 AI 說「關閉 Aletheia」，或直接開新對話。
- 協議不會讓 AI 取得原本沒有的能力，也不能取代醫師、律師、財務顧問。

## 連結

- 網站：https://401fourinone-debug.github.io/aletheia/
- 加入測試頁：https://401fourinone-debug.github.io/aletheia/join.html
- 回報（GitHub Issues）：https://github.com/401fourinone-debug/aletheia/issues
- YouTube：https://www.youtube.com/@AletheiaTW
