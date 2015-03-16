{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}
    
# Install wp - if not installed (need to check if WP-CLI is installed)
wp_install:
  cmd.run:
    - name: wp core install --url={{ app.core_install.url }} --title={{ app.core_install.title }} --admin_user={{ app.core_install.admin_user }} --admin_password={{ app.core_install.admin_password }} --admin_email={{ app.core_install.admin_email }} --allow-root
    - cwd: /srv/wordpress/sites/devel/root/
    - user: root
    - onlyif: wp core is-intalled --allow-root
     
test_core:
  cmd.run:
    - name: wp core is-installed --allow-root
    - cwd: /srv/wordpress/sites/devel/root/
    - user: root
     
test_onlyif:
  cmd.run:
    - name: wp core is-installed --allow-root
    - cwd: /srv/wordpress/sites/devel/root/
    - user: root
    - require:
      - cmd: test_core
    
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