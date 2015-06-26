drush-dependencies:
  pkg.installed:
    - pkgs:
      - php5-mysql

# Requires composer
drush-install:
  cmd.run:
    - name: COMPOSER_HOME=/usr/share/drush composer global require drush/drush:7.*

/usr/bin/drush:
  file.symlink:
    - target: /root/.composer/vendor/bin/drush
