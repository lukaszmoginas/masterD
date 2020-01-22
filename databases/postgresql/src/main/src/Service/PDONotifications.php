<?php

declare(strict_types=1);

namespace Service;

class PDONotifications
{
    /** @var string  */
    private $username = 'username';

    /** @var string  */
    private $password = 'password';

    /** @var string  */
    private $dbname = 'dbname';

    /** @var string  */
    private $port = 5432;

    /** @var string  */
    private $host = 'host';

    /**
     * PDONotifications constructor.
     * @param string $username
     * @param string $password
     * @param string $dbname
     * @param string $port
     * @param string $host
     */
    public function __construct(
        string $username,
        string $password,
        string $dbname,
        string $port,
        string $host
    ) {
        $this->username = $username;
        $this->password = $password;
        $this->dbname = $dbname;
        $this->port = $port;
        $this->host = $host;
    }

    /**
     * @return \PDO
     */
    public function connect(): \PDO
    {
        return new \PDO(
            'pgsql:dbname=' . $this->dbname . ' host=' . $this->host . ' port=' . $this->port . ';options=--application_name=APPLICATION_NAME',
            $this->username,
            $this->password,
            [
                \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION,
                \PDO::ATTR_DEFAULT_FETCH_MODE => \PDO::FETCH_ASSOC,
            ]
        );
    }
}
