{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- mysql

{%- for app_name, app in server.app.iteritems() %}

create_db:
  cmd.run:
    - name: mysql -u {{ app.database.user }} -p {{ app.database.password }} -ptestuser < /tmp/init.mysql
    - require:
      - service: mysql
      - file: /tmp/init.mysql
        
{%- endfor %}

{%- endif %}