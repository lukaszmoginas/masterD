<?php

declare(strict_types=1);

use Client\Mailer;
use Service\PDONotifications;

require __DIR__ . '/vendor/autoload.php';

/** @var PDO $db */
$db = new PDONotifications(
    getenv('DB_USERNAME'),
    getenv('DB_PASSWORD'),
    getenv('DB_NAME'),
    getenv('DB_PORT'),
    getenv('DB_HOST')
);

$db->exec('LISTEN "honey"');

while (true) {
    while ($notificationResult = $db->pgsqlGetNotify(PDO::FETCH_ASSOC, 0)) {
        $result = json_encode($notificationResult) . PHP_EOL;

        (new Mailer())->sendNotification($result);
    }
}
