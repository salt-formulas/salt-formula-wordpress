{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- mysql

{%- for app_name, app in server.app.iteritems() %}

create_db:
  cmd.run:
    - name: mysql -u {{ app.database.user }} -ptestuser < salt://wordpress/files/init.sql
    - require:
      - service: mysql
        
{%- endfor %}

{%- endif %}