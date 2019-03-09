#!/bin/sh

MYSQL_PASS=$(echo $MYSQL_PASSWORD | sed -e 's/[\/&]/\\&/g')

cp config.php-dist config.php

sed -e "s/define('DB_TYPE', .*$/define('DB_TYPE', 'mysql');/" \
    -e "s/define('DB_HOST', .*$/define('DB_HOST', \'${MYSQL_HOST}\');/" \
    -e "s/define('DB_USER', .*$/define('DB_USER', \'${MYSQL_USER}\');/" \
    -e "s/define('DB_NAME', .*$/define('DB_NAME', \'${MYSQL_DATABASE}\');/" \
    -e "s/define('DB_PASS', .*$/define('DB_PASS', \'${MYSQL_PASS}\');/" \
    -e "s|define('SELF_URL_PATH', .*$|define('SELF_URL_PATH', \'https://${VIRTUAL_HOST}/\');|" \
    -e "s|define('PHP_EXECUTABLE', .*$|define('PHP_EXECUTABLE', '/usr/local/bin/php');|" \
    -e "s/define('PLUGINS', .*$/define('PLUGINS', 'auth_internal, mailer_smtp');/" \
    -i config.php

echo "
	// **************************
	// *** SMTP mailer plugin ***
	// **************************

	define('SMTP_SERVER', '');
	// Hostname:port combination to send outgoing mail (i.e. localhost:25).
	// Blank - use system MTA.

	define('SMTP_LOGIN', '');
	define('SMTP_PASSWORD', '');
	// These two options enable SMTP authentication when sending
	// outgoing mail. Only used with SMTP_SERVER.

	define('SMTP_SECURE', '');
	// Used to select a secure SMTP connection. Allowed values: ssl, tls,
	// or empty.

	define('SMTP_SKIP_CERT_CHECKS', false);
	// Accept all SSL certificates, use with caution.
" >> config.php

sed -e "s/define('SMTP_SERVER', .*$/define('SMTP_SERVER', \'${SMTP_SERVER}\');/" \
    -e "s/define('SMTP_FROM_NAME', .*$/define('SMTP_FROM_NAME', \'${SMTP_FROM_NAME}\');/" \
    -e "s/define('SMTP_FROM_ADDRESS', .*$/define('SMTP_FROM_ADDRESS', \'${SMTP_FROM_ADDRESS}\');/" \
    -i config.php

exec apache2-foreground
