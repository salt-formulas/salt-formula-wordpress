{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- php.environment

wordpress_packages:
  pkg.installed:
  - names:
    - php5-mysql
    - php5-gd
    - php5-curl
    - php5-intl
    - php5-xmlrpc
    - php5-mcrypt
    - php5-dev
  - require:
    - pkg: php_packages

/srv/wordpress:
  file.directory:
  - user: root
  - group: www-data
  - mode: 755
  - makedirs: true

{%- endif %}