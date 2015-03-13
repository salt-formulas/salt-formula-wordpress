{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- mysql

{%- for app_name, app in server.app.iteritems() %}

create_db:
  cmd.run:
    - name: mysql -u {{ app.database.user }} -ptestuser < /srv/wordpress/sites/{{ app_name }}/root/init.sql
    - require:
      - service: mysql
        
{%- endfor %}

{%- endif %}