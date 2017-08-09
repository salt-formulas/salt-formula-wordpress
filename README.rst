
=================
Wordpress formula
=================

WordPress is web software you can use to create a beautiful website or blog.


Sample metadata
===============

Simple site

.. code-block:: yaml

    wordpress:
      server:
        app:
          app_name:
            enabled: true
            version: '4.0'
            url: example.com
            title: TCPisekWeb
            admin_user: admin
            admin_password: password
            admin_email: nikicresl@gmail.com
            core_update: false
            theme_update: false
            plugin:
              bbpress:
                engine: http
                version: latest
              git_plugin:
                engine: git
                address: git@git.domain.com:git-repo
                revision: master
            database:
              engine: mysql
              host: 127.0.0.1
              name: w_site
              password: password
              user: w_tcpisek
              prefix: tcpisek


Read more
=========

* http://codex.wordpress.org/Installing_WordPress
* http://www.severalnines.com/blog/scaling-wordpress-and-mysql-multiple-servers-performance


Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-wordpress/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-wordpress

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
