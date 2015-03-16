{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}

# Creating directory for web
/srv/wordpress/sites/{{ app_name }}:
  file.directory:
  - user: www-data
  - group: www-data
  - mode: 770
  - makedirs: true

# Downloading WP to directory
wordpress_{{ app_name }}_git:
  git.latest:
  - name: {{ server.git_source }}
  - rev: {{ app.version }}-branch
  - target: /srv/wordpress/sites/{{ app_name }}/root 
  - require:
    - pkg: git_packages

# Copiing config file to directory with WP
/srv/wordpress/sites/{{ app_name }}/root/wp-config.php:
  file.managed:
  - source: salt://wordpress/files/wp-config.php
  - template: jinja
  - mode: 644
  - require:
    - git: wordpress_{{ app_name }}_git
  - defaults:
    app_name: "{{ app_name }}"

# (Deprecated) Moving .sql file for creating database.
#/tmp/init.mysql:
#  file.managed:
#  - source: salt://wordpress/files/init.sql
#  - template: jinja
#  - mode: 644
#  - require:
#    - git: wordpress_{{ app_name }}_git
#  - defaults:
#    app_name: "{{ app_name }}"

# Moving Tab completion script to temp dir.
/tmp/wpcli-tab.sh:
  file.managed:
  - source: salt://wordpress/files/wpcli-tab.sh
  - template: jinja
  - mode: 644
  - require:
    - git: wordpress_{{ app_name }}_git
  - defaults:
    app_name: "{{ app_name }}"
    
# Install WP-CLI
install_wpcli:
  cmd.script:
    - name: wpcli-install
    - source: salt://wordpress/files/wpcli-install.sh
    - cwd: /
    - require:
      - git: wordpress_{{ app_name }}_git

{%- endfor %}

/root/wordpress/scripts:
  file.directory:
  - user: root
  - group: root
  - mode: 700
  - makedirs: true

/root/wordpress/flags:
  file.directory:
  - user: root
  - group: root
  - mode: 700
  - makedirs: true

{%- endif %}