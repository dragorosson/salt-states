configure-owncloud-database:
  mysql_database.present:
    - name: owncloud

add-owncloud-user:
  mysql_user.present:
    - name: owncloud
    - host: localhost
    - password: {{ salt['pillar.get']('owncloud:db_password') }}

grant-owncloud-user-permissions:
  mysql_grants.present:
    - grant: all privileges
    - database: owncloud.*
    - user: owncloud
    - host: localhost

owncloud-repo:
  pkgrepo.managed:
    - name: deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /
    - key_url: http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key
    - require_in:
      - pkg: owncloud

install-owncloud:
  pkg.installed:
    - name: owncloud
    - refresh: True

write-autoconfig:
  file.managed:
    - name: /var/www/owncloud/config/autoconfig.php
    - source: salt://owncloud/autoconfig.php.jinja
    - user: www-data
    - group: www-data
    - mode: 644
    - template: jinja

enable-default-ssl-site:
  file.symlink:
    - name: /etc/apache2/sites-enabled/default-ssl.conf
    - target: ../sites-available/default-ssl.conf
  cmd.run:
    - name: service apache2 reload
