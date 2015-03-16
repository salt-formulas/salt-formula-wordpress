{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

install_wpcli:
  cmd.run:
    - name: /tmp/wpcli-install.sh
    
install_wpcli_tab:
  cmd.run:
    - name: /tmp/wpcli-tab.sh

{%- for app_name, app in server.app.iteritems() %}

 {%- if salt['cmd.run']('wp cli version --allow-root') != 1 %}

  {%- set web_path='/srv/wordpress/sites/'+app_name+'/root/' %}
    
  {%- if salt['cmd.run']('wp core is-installed --path="{{ web_path }}" --allow-root') %}

  wp_install:
    cmd.run:
      - name: wp core install --url='{{ app.core_install.url }}' --title='{{ app.core_install.title }}' --admin_user='{{ app.core_install.admin_user }}' --admin_password='{{ app.core_install.admin_password }}' --admin_email='{{ app.core_install.admin_email }}' --allow-root
      - cwd: {{ web_path }}
      - user: root
    
  {%- endif %}
  
  #{%- if app.update.core_update %}
  
  #wp_core_update:
    # cmd.run:
    #   - name: wp core update --allow-root
    #   - cwd: {{ web_path }}
    #   - user: root
       
  #{%- endif %}
  
  #{%- if app.update.theme_update %}
  
 # wp_theme_update:
  #   cmd.run:
    #   - name: wp theme update --all --allow-root
    #   - cwd: {{ web_path }}
    #   - user: root
       
  #{%- endif %}
  
  #wp_theme_update:
    # cmd.run:
     #  - name: echo {{ app.update.core_update }}
    
 {%- else %}
 
  not_installed:
    cmd.run:
      - name: echo 'WP-CLI not installed - '
 
 {%- endif %}

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
