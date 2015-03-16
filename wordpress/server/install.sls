{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

{%- set web_path='/srv/wordpress/sites/{{ app_name }}/root/' %}

{%- for app_name, app in server.app.iteritems() %}
    
{% if salt['cmd.run']('wp core is-installed --path="{{ web_path }}" --allow-root') %}

wp_install:
  cmd.run:
    - name: wp core install --url='{{ app.core_install.url }}' --title='{{ app.core_install.title }}' --admin_user='{{ app.core_install.admin_user }}' --admin_password='{{ app.core_install.admin_password }}' --admin_email='{{ app.core_install.admin_email }}' --allow-root
    - cwd: {{ web_path }}
    - user: root
    
{% else %}

error_output:
 cmd.run:
     - names:
       - echo "If not true."
    - cwd: {{ web_path }}
    
{% endif %}

{%- endfor %}

{%- endif %}


#TODO - test multiple plugin install (for) and enable them. 
#testplugin_install:
#  cmd.run:
#    - name: wp plugin install members --allow-root
#    - cwd: /srv/wordpress/sites/devel/root/
#    - user: root
#    - unless:
#       - wp core is-intalled --allow-root

# Check if WP is installed
#{% if not salt['cmd.run']('wp cli info --allow-root') %}
#{% endif %}
