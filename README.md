# docker-ttrss

[![GitHub Issues](https://img.shields.io/github/issues/acch/docker-ttrss.svg)](https://github.com/acch/docker-ttrss/issues) [![GitHub Stars](https://img.shields.io/github/stars/acch/docker-ttrss.svg?label=github%20%E2%98%85)](https://github.com/acch/docker-ttrss/) [![Docker Pulls](https://img.shields.io/docker/pulls/acch/ttrss.svg)](https://hub.docker.com/r/acch/ttrss/) [![License](https://img.shields.io/github/license/acch/docker-ttrss.svg)](LICENSE)

[Tiny Tiny RSS](https://tt-rss.org/) Docker image. Includes [SMTP mailer plugin](https://git.tt-rss.org/fox/ttrss-mailer-smtp) for Email notifications.

## Usage

Tiny Tiny RSS requires a database to run. The recommended way of starting both containers is with [Docker-Compose](https://docs.docker.com/compose/compose-file):

    version: '3'

    services:
      db:
        image: mariadb
        container_name: ttrss_db
        volumes:
          - db:/var/lib/mysql
        environment:
          - MYSQL_RANDOM_ROOT_PASSWORD=yes
        env_file:
          - db.env
        restart: always

      app:
        image: acch/ttrss
        container_name: ttrss_app
        environment:
          - MYSQL_HOST=db
          - VIRTUAL_HOST=ttrss.mydomain.com
          - SMTP_SERVER=mail.mydomain.com:25
          - SMTP_FROM_ADDRESS=rss@mydomain.com
        env_file:
          - db.env
        depends_on:
          - db
        restart: always

    volumes:
      db:
        driver: local

The file `db.env` contains (secret) database credentials:

    MYSQL_DATABASE=ttrss
    MYSQL_USER=ttrss
    MYSQL_PASSWORD=<mysecretpassword>

## Getting Started

When running Tiny Tiny RSS for the first time one needs to initialize the database. Do so by completing the installation wizard by pointing a web browser towards: `http://ttrss.mydomain.com/install/`.

See `https://git.tt-rss.org/fox/tt-rss/wiki/InstallationNotes` for details. Note that the configuration file `config.php` is automatically generated when starting a container from this image, based on environment variables.

## Environment Variables

The following environment variables are used to generate the `config.php` configuration file:

| Docker Environment Variable | TT-RSS Configuration Option |
| --------------------------- | --------------------------- |
| MYSQL_HOST                  | `DB_HOST`                   |
| MYSQL_USER                  | `DB_USER`                   |
| MYSQL_DATABASE              | `DB_NAME`                   |
| MYSQL_PASS                  | `DB_PASS`                   |
| VIRTUAL_HOST                | `SELF_URL_PATH`             |
| SMTP_SERVER                 | `SMTP_SERVER`               |
| SMTP_FROM_NAME              | `SMTP_FROM_NAME`            |
| SMTP_FROM_ADDRESS           | `SMTP_FROM_ADDRESS`         |

Refer to [config.php](https://git.tt-rss.org/fox/tt-rss/src/master/config.php-dist) for a detailed explanation of these configuration options.

## Copyright

Copyright 2019 Achim Christ, released under the [MIT license](LICENSE)
