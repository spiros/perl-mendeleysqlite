perl-mendeleysqlite
===================

Tools for working directly with the Mendeley client SQLite database.

Examples
________

Generate an HTML tagcloud of all your keywords.

perl bin/maketagcloud.pl --dbfile=moo.sqlite --mode=keywords > cloud.html