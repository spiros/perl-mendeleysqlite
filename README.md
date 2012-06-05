perl-mendeleysqlite
===================

Tools for working directly with the Mendeley client SQLite database.

Examples
________

Generate an HTML tagcloud of all your keywords.

```shell
perl -Ilib bin/maketagcloud.pl --dbfile=moo.sqlite --mode=keywords > cloud.html
```

For more information on how to locate the Mendeley Desktop database visit: http://support.mendeley.com/customer/portal/articles/227951-how-do-i-locate-mendeley-desktop-database-files-on-my-computer-

