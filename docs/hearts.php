<?php
// 愛心計數。GET 取目前數字,POST 加一。
// 刻意不做防灌水:這是氣氛用的數字,不是數據。也不記錄 IP、不設 cookie。
//
// 計數檔優先放在網站根目錄的上一層,因為部署用的是 lftp mirror --delete,
// 放在 docs/ 裡會被當成「repo 沒有的多餘檔案」在下一次部署刪掉。
// 若主機的 open_basedir 不允許寫上一層,退回放在 docs/,
// 這時要靠 workflow 裡的 --exclude-glob hearts.json 保住它。
declare(strict_types=1);

header('Content-Type: application/json; charset=utf-8');
header('Cache-Control: no-store');

function store(): array {
    foreach ([[__DIR__ . '/../hearts.json', 'outside'], [__DIR__ . '/hearts.json', 'inside']] as [$path, $where]) {
        $dir = dirname($path);
        if ((is_file($path) && is_writable($path)) || (!is_file($path) && is_dir($dir) && is_writable($dir))) {
            return [$path, $where];
        }
    }
    return ['', 'none'];
}

function readCount(string $path): int {
    if ($path === '' || !is_file($path)) return 0;
    $d = json_decode((string)@file_get_contents($path), true);
    return is_array($d) && isset($d['hearts']) ? max(0, (int)$d['hearts']) : 0;
}

[$path, $where] = store();

if (($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST') {
    if ($path === '' || ($fh = @fopen($path, 'c+')) === false) {
        http_response_code(503);
        echo json_encode(['error' => 'not_writable', 'store' => $where]);
        exit;
    }
    flock($fh, LOCK_EX);
    $d = json_decode((string)stream_get_contents($fh), true);
    $n = (is_array($d) && isset($d['hearts']) ? max(0, (int)$d['hearts']) : 0) + 1;
    ftruncate($fh, 0);
    rewind($fh);
    fwrite($fh, json_encode(['hearts' => $n, 'updated' => gmdate('c')]));
    fflush($fh);
    flock($fh, LOCK_UN);
    fclose($fh);
    echo json_encode(['hearts' => $n, 'store' => $where]);
    exit;
}

echo json_encode(['hearts' => readCount($path), 'store' => $where]);
