{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- git

wordpress_packages:
  pkg.installed:
  - names: {{ server.pkgs }}
  - require:
    - pkg: git_packages

wordpress_dirs:
  file.directory:
  - names:
    - {{ server.dir.base }}/sites
    - /root/wordpress/scripts
    - /root/wordpress/flags
  - user: root
  - group: root
  - mode: 755
  - makedirs: true

{{ server.dir.base }}/wpcli-tab.sh:
  file.managed:
  - source: salt://wordpress/files/wpcli-tab.sh
  - template: jinja
  - user: root
  - mode: 700

{{ server.dir.base }}/wp-cli.phar:
  file.managed:
  - source: {{ server.cli.source_address }}
  - source_hash: {{ server.cli.source_hash }}
  - template: jinja
  - user: root
  - mode: 777

/usr/local/bin/wp:
  file.symlink:
  - target: {{ server.dir.base }}/wp-cli.phar

{%- endif %}