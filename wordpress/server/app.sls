{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}

/srv/wordpress/sites/{{ app_name }}:
  file.directory:
  - user: www-data
  - group: www-data
  - mode: 770
  - makedirs: true

wordpress_{{ app_name }}_git:
  git.latest:
  - name: {{ server.git_source }}
  - rev: {{ app.version }}-branch
  - target: /srv/wordpress/sites/{{ app_name }}/root 
  - require:
    - pkg: git_packages

/srv/wordpress/sites/{{ app_name }}/root/wp-config.php:
  file.managed:
  - source: salt://wordpress/files/wp-config.php
  - template: jinja
  - mode: 644
  - require:
    - git: wordpress_{{ app_name }}_git
  - defaults:
    app_name: "{{ app_name }}"

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