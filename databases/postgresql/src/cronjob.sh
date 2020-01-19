#!/bin/bash
(crontab -l 2>/dev/null; echo "* * * * * php /var/www/main/index.php \n") | crontab -
