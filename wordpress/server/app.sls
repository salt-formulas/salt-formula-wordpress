{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if salt['pillar.get']('app_name', False) %}

{%- set app_name = salt['pillar.get']('app_name') %}
{%- set app = salt['pillar.get']('wordpress:server:app:'+app_name) %}
{% include "wordpress/server/_app.sls" %}

{%- elif salt['pillar.get']('app_names', False) is iterable %}

{%- for app_name in salt['pillar.get']('app_names') %}
{%- set app = salt['pillar.get']('wordpress:server:app:'+app_name) %}
{% include "wordpress/server/_app.sls" %}
{%- endfor %}

{% else %}

{%- for app_name, app in server.get('app', {}).iteritems() %}
{% include "wordpress/server/_app.sls" %}
{%- endfor %}

{%- endif %}

{%- endif %}
