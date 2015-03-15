
=========
Wordpress
=========

WordPress is web software you can use to create a beautiful website or blog.

Sample pillars
==============

.. code-block:: yaml

    wordpress:
      server:
        enabled: true
        app:
          site01:
            enabled: true
            version: '4.0'
            database:
              engine: 'mysql'
              host: '127.0.0.1'
              name: 'w_devel'
              password: '${_param:mysql_wordpress_site01_password}'
              user: 'w_devel'
              prefix: 'devel'
            plugin:
              pluginname01:
                version: 23.03
                source:
                  engine: git
                  address: git@git.domain.com
              pluginname01:
                version: 2.03
                source:
                  engine: http

Read more
=========

* https://github.com/WordPress/WordPress.git
* http://codex.wordpress.org/Installing_WordPress
* http://www.severalnines.com/blog/scaling-wordpress-and-mysql-multiple-servers-performance