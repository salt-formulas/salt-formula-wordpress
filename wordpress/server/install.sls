{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}
    
# Install wp - if not installed
   
# Testing Plugin install via WP-CLI
#testplugin_install:
#  cmd.run:
#    - name: wp plugin install {{ app.plugins.name }} --allow-root
#    - cwd: /srv/wordpress/sites/devel/root/
#    - user: root
    
#TODO - replace deprecated DB install with WP-CLI install
#TODO - test multiple plugin install (for) and enable them. 

testplugin_install:
  cmd.run:
    - name: wp plugin install members --allow-root
    - cwd: /srv/wordpress/sites/devel/root/
    - user: root
    - unless:
       - wp core is-intalled --allow-root

{%- endfor %}

{%- endif %}