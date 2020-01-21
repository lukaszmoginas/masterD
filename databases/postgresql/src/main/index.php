<?php

declare(strict_types=1);

require __DIR__ . '/vendor/autoload.php';

// Create the Transport
$transport = (new Swift_SmtpTransport(getenv('MAIL_HOST'), 587, 'tls'))
    ->setUsername(getenv('MAIL_USERNAME'))
    ->setPassword(getenv('MAIL_PASSWORD'))
;

// Create the Mailer using your created Transport
$mailer = new Swift_Mailer($transport);

//Should represent container name;
$container = 'Postgres';

//Should mail body
$body = 'Warning! HoneyToken was triggered in ' . $container . ' DBMDS';

// Create a message
$message = (new Swift_Message('Warning!'))
    ->setFrom(['example@example.com'])
    ->setTo(['example@example.com'])
    ->setBody($body)
;

// Send the message
$result = $mailer->send($message);
