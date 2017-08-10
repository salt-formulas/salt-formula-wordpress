{%- set app_dir = '/srv/wordpress/sites/'+app_name+'/root' %}

/srv/wordpress/sites/{{ app_name }}:
  file.directory:
  - user: www-data
  - group: www-data
  - mode: 770

{%- if server.source.engine == 'git' %}

wordpress_{{ app_name }}_source:
  git.latest:
  - name: {{ server.source.address }}
  - rev: {{ app.version }}-branch
  - target: {{ app_dir }}
  - user: www-data
  - require:
    - file: /srv/wordpress/sites/{{ app_name }}

{%- endif %}

{{ app_dir }}/wp-config.php:
  file.managed:
  - source: salt://wordpress/files/wp-config.php
  - template: jinja
  - mode: 644
  - require:
    - git: wordpress_{{ app_name }}_source
  - defaults:
      app_name: {{ app_name }}

wordpress_{{ app_name }}_core_install:
  cmd.run:
  - name: wp core install --url='{{ app.host }}' --title='{{ app.title }}' --admin_user='{{ app.admin_user }}' --admin_password='{{ app.admin_password }}' --admin_email='{{ app.admin_email }}'
  - cwd: {{ app_dir }}
  - user: www-data
  - unless: wp core is-installed --path="{{ app_dir }}" --allow-root

{%- if app.core_update %}

wordpress_{{ app_name }}_core_update:
  cmd.run:
  - name: wp core update
  - cwd: {{ app_dir }}
  - user: www-data
  - unless: wp core check-update

{%- endif %}

{%- if app.theme_update %}

wordpress_{{ app_name }}_theme_update:
  cmd.run:
  - name: wp theme update --all
  - cwd: {{ app_dir }}
  - user: www-data

{%- endif %}

{%- for plugin_name, plugin in app.get('plugin', {}).iteritems() %}

{%- if salt['cmd.retcode']('wp plugin is-installed '+plugin_name+' --path='+app_dir+' --allow-root 2>/dev/null || false', python_shell=true) != 0 %}

{%- if plugin.engine == 'http' %}

wordpress_{{ app_name }}_{{ plugin_name }}:
  cmd.run:
    - name: wp plugin install {{ plugin_name }}{% if plugin.version != 'latest' %} --version='{{ plugin.version }}'{%- endif %}
    - cwd: {{ app_dir }}
    - user: www-data

{%- elif plugin.engine == 'git' %}

wordpress_{{ app_name }}_{{ plugin_name }}:
  git.latest:
    - name: {{ plugin.address }}
    - rev: {{ plugin.get('revision', 'master') }}
    - target: {{ app_dir }}/wp-content/plugins/{{ plugin_name }}
    - user: www-data

{%- endif %}

{%- else %}

{%- if plugin.engine == 'http' %}

#{{ plugin_name }}_update:
#  cmd.run:
#    - name: wp plugin update {{ plugin_name }}{% if plugin.version != 'latest' %} --version='{{ plugin.version }}'{%- endif %}
#    - cwd: {{ app_dir }}
#    - user: www-data

{%- elif plugin.engine == 'git' %}

wordpress_{{ app_name }}_{{ plugin_name }}:
  git.latest:
    - name: {{ plugin.address }}
    - rev: {{ plugin.get('revision', 'master') }}
    - target: {{ app_root }}/wp-content/plugins/{{ plugin_name }}
    - user: www-data

{%- endif %}

{%- endif %}

{%- endfor %}
