{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

{%- for app_name, app in server.app.iteritems() %}

  {%- if salt['cmd.run']('wp cli version --allow-root') != 1 %}

    {%- set web_path='/srv/wordpress/sites/'+app_name+'/root/' %}
    
    {%- if salt['cmd.run']('wp core is-installed --path="{{ web_path }}" --allow-root') == 1 %}

      wp_install:
        cmd.run:
          - name: wp core install --url='{{ app.core_install.url }}' --title='{{ app.core_install.title }}' --admin_user='{{ app.core_install.admin_user }}' --admin_password='{{ app.core_install.admin_password }}' --admin_email='{{ app.core_install.admin_email }}' --allow-root
          - cwd: {{ web_path }}
          - user: root
    
    {%- endif %}
  
    {%- if app.do_update.core_update %}
  
      wp_core_update:
        cmd.run:
          - name: wp core update --allow-root
          - cwd: {{ web_path }}
          - user: root
          - unless: wp core check-update --allow-root
       
    {%- endif %}
  
    {%- if app.do_update.theme_update %}
  
      wp_theme_update:
        cmd.run:
          - name: wp theme update --all --allow-root
          - cwd: {{ web_path }}
          - user: root
       
    {%- endif %}
    
  {%- else %}
 
    not_installed:
      cmd.run:
        - name: echo 'TODO - vynuceni default DB.'
 
  {%- endif %}

{%- endfor %}

{%- endif %}
