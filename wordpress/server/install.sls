{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}

# Check if WP-CLI is running.
{%- if salt['cmd.run']('wp cli version --allow-root') != 1 %}

{%- set web_path='/srv/wordpress/sites/'+app_name+'/root/' %}
  
test_echo_kdovi:
  cmd.run:
    - name: echo $USER
  
# Install DB tables if they are not present.
{%- if salt['cmd.run']('wp core is-installed --path="{{ web_path }}" --allow-root') == 1 %}
wp_install:
  cmd.run:
    - name: wp core install --url='{{ app.core_install.url }}' --title='{{ app.core_install.title }}' --admin_user='{{ app.core_install.admin_user }}' --admin_password='{{ app.core_install.admin_password }}' --admin_email='{{ app.core_install.admin_email }}' --allow-root
    - cwd: {{ web_path }}
    - user: root
{%- endif %}
 
# Do core update is enabled and core needs update.
{%- if app.do_update.core_update %}
wp_core_update:
  cmd.run:
    - name: wp core update --allow-root
    - cwd: {{ web_path }}
    - user: root
    - unless: wp core check-update --allow-root
{%- endif %}
  
# Update all themes if enabled.
{%- if app.do_update.theme_update %}
wp_theme_update:
  cmd.run:
    - name: wp theme update --all --allow-root
    - cwd: {{ web_path }}
    - user: root
{%- endif %}
  
# Updating/Installing plugins by version. 
{%- for plugin_name, plugin in app.plugin.iteritems() %}

# Install plugin if is not already installed. If installed - update.
{%- if salt['cmd.run']('wp plugin is-installed {{ plugin_name }} --path="{{ web_path }}" --allow-root') != 0 %}

{{ plugin_name }}_install:
  cmd.run:
{%- if plugin.version == 'latest' %}
    - name: wp plugin install {{ plugin_name }} --allow-root
{%- else %}
    - name: wp plugin install {{ plugin_name }} --version='{{ plugin.version }}' --allow-root
{%- endif %}
    - cwd: {{ web_path }}
    - user: root
    
{%- else %}
  
# Update plugins via http
{%- if plugin.source.engine == 'http' %}

{{ plugin_name }}_update:
  cmd.run:
{%- if plugin.version == 'latest' %}
    - name: wp plugin update {{ plugin_name }} --allow-root
{%- else %}
    - name: wp plugin update {{ plugin_name }} --version='{{ plugin.version }}' --allow-root
{%- endif %}
    - cwd: {{ web_path }}
    - user: root

# Update plugins via git
{%- elif plugin.source.engine == 'git' %}  

{{ plugin_name }}_git_update:
  git.latest:
    - name: {{ plugin.source.address }}
{%- if plugin.version != 'latest' %}
    - rev: {{ plugin.version }}
{%- endif %}
    - target: {{ web_path }}/wp-content/plugins/{{ plugin_name }}
    - require:
      - git: wordpress_{{ app_name }}_git

{%- endif %}

{%- endif %}

{%- endfor %}
    
{%- else %}
 
not_installed:
  cmd.run:
  - name: echo 'TODO - vynuceni default DB.'
  
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
 
{%- endif %}

{%- endfor %}

{%- endif %}

# TODO: Checkovat jestli plugin je nebo není -> rozdělit tak install od update (první projetí projede jak instal tak update) 75 query
# TODO: Install/Update z git zdroje
# TODO: Vynucení databáze když není WP-CLI
# TODO: change user, add rights to see dir with wp and eliminate --allow-root
# TODO: parametrize url in yml