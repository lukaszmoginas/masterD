<?php

declare(strict_types=1);

namespace Client;

use Swift_Mailer;
use Swift_Message;
use Swift_SmtpTransport;

class Mailer
{
    /**
     * @param string $result
     * @return int
     */
    public function sendNotification(string $result): int
    {
        $swiftMailer = $this->createTransport();
        $message = $this->createMessage($result);

        return $swiftMailer->send($message);
    }

    /**
     * @return Swift_Mailer
     */
    private function createTransport(): Swift_Mailer
    {
        // Create the Transport
        $transport = (new Swift_SmtpTransport(getenv('MAIL_HOST'), 587, 'tls'))
            ->setUsername(getenv('MAIL_USERNAME'))
            ->setPassword(getenv('MAIL_PASSWORD'));

        return new Swift_Mailer($transport);
    }

    /**
     * @param string $result
     * @return Swift_Message
     */
    private function createMessage(string $result): Swift_Message
    {
        $body = 'Warning! HoneyToken was triggered. \n More details: ' . $result;

        return (new Swift_Message('Warning!'))
            ->setFrom(['example@example.com'])
            ->setTo(['example@example.com'])
            ->setBody($body);
    }
}
