{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- wget
- curl
- php

{%- for app_name, app in server.app.iteritems() %}

install_wpcli:
  cmd.run:
    - name: curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    - require:
      - service: wget
      - service: curl
      
enable_wp_command:
  cmd.run:
    - name: chmod +x wp-cli.phar
    - require:
      - service: chmod
      
enable_wp_command_two:
  cmd.run:
    - name: sudo mv wp-cli.phar /usr/local/bin/wp
    - require:
      - service: mv
      
{%- endfor %}

{%- endif %}