{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}

# Check if WP-CLI is running.
{%- if salt['cmd.retcode']('wp cli version --allow-root') != 1 %}

{%- set web_path='/srv/wordpress/sites/'+app_name+'/root/' %}
  
# Install DB tables if they are not present.
{%- if salt['cmd.retcode']('wp core is-installed --path="'+web_path+'" --allow-root') == 1 %}
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
{%- if salt['cmd.retcode']('wp plugin is-installed '+plugin_name+' --path='+web_path+' --allow-root') != 0 %}

{%- if plugin.source.engine == 'http' %}

{{ plugin_name }}_install:
  cmd.run:
{%- if plugin.version == 'latest' %}
    - name: wp plugin install {{ plugin_name }} --allow-root
{%- else %}
    - name: wp plugin install {{ plugin_name }} --version='{{ plugin.version }}' --allow-root
{%- endif %}
    - cwd: {{ web_path }}
    - user: root
    
{%- elif plugin.source.engine == 'git' %}  

{{ plugin_name }}_git_install:
  git.latest:
    - name: {{ plugin.source.address }}
{%- if plugin.version != 'latest' %}
    - rev: {{ plugin.version }}
{%- endif %}
    - target: {{ web_path }}/wp-content/plugins/{{ plugin_name }}
    - require:
      - git: wordpress_{{ app_name }}_git

{%- endif %}
    
{%- else %}
  
# Update plugins via http
{%- if plugin.source.engine == 'http' %}

#{{ plugin_name }}_update:
#  cmd.run:
#{%- if plugin.version == 'latest' %}
#    - name: wp plugin update {{ plugin_name }} --allow-root
#{%- else %}
#    - name: wp plugin update {{ plugin_name }} --version='{{ plugin.version }}' --allow-root
#{%- endif %}
#    - cwd: {{ web_path }}
#    - user: root

# Update plugins via git
{%- elif plugin.source.engine == 'git' %}  

{{ plugin_name }}_git_update:
  git.latest:
    - name: {{ plugin.source.address }}
{%- if plugin.version != 'latest' %}
    - rev: {{ plugin.version }}
{%- else %}
    - rev: 'master'
{%- endif %}
    - target: {{ web_path }}/wp-content/plugins/{{ plugin_name }}
    - force: true
    - force_reset: true
    - force_checkout: true
    - require:
      - git: wordpress_{{ app_name }}_git

{%- endif %}

{%- endif %}

{%- endfor %}
    
{%- else %}
  
# Moving .sql file for creating database.
/tmp/init.mysql:
  file.managed:
    - source: salt://wordpress/files/init.sql
    - template: jinja
    - mode: 644
    - require:
      - git: wordpress_{{ app_name }}_git
    - defaults:
      - app_name: "{{ app_name }}"
 
# Create DB if WP-CLI is not installed.
#create_db:
#  cmd.run:
#    - name: mysql -u {{ app.database.user }} -p{{ app.database.password }} < /tmp/init.mysql
#    - require:
#      - service: mysql
#      - file: /tmp/init.mysql 

# Updating/Installing plugins by version. 
{%- for plugin_name, plugin in app.plugin.iteritems() %}

# If address is set
{%- if plugin.source.address %}

{{ plugin_name }}_git_without_cli:
  git.latest:
    - name: {{ plugin.source.address }}
{%- if plugin.version != 'latest' %}
#    - rev: {{ plugin.version }}
{%- else %}
    - rev: 'master'
{%- endif %}
    - target: {{ web_path }}/wp-content/plugins/{{ plugin_name }}
    - force: true
    - force_reset: true
    - force_checkout: true
    - require:
      - git: wordpress_{{ app_name }}_git
 
{%- endif %} 

{%- endfor %}
 
{%- endif %}

{%- endfor %}

{%- endif %}

# TODO: Install z git zdroje (Test update).
# TODO: kontrola jestli DB je naplnena - když není WP-CLI
# TODO: zmena uzivatele, práva aby videl slozku s wp a eliminace -> --allow-root