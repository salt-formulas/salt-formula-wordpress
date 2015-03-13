{%- from "wordpress/map.jinja" import server with context %}
{%- if server.enabled %}

include:
- mysql
- mysql.query

{%- for app_name, app in server.app.iteritems() %}

create_table:
    mysql_query.run
        - database: {{ app_name }}
        - query: "CREATE TABLE IF NOT EXISTS `{{ test_table_commentmeta` (`meta_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,`comment_id` bigint(20) unsigned NOT NULL DEFAULT '0',`meta_key` varchar(255) DEFAULT NULL,`meta_value` longtext,PRIMARY KEY (`meta_id`),KEY `comment_id` (`comment_id`), KEY `meta_key` (`meta_key`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1;"

{%- endfor %}

{%- endif %}