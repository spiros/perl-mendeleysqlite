perl-mendeleysqlite
===================

Tools for working directly with the Mendeley client SQLite database.

Examples
________

Generate an HTML tagcloud of all your keywords.

```shell
perl -Ilib bin/maketagcloud.pl --dbfile=moo.sqlite --mode=keywords > cloud.html
```

* Mac users can find their Mendeley SQLite database file under: `~/Library/Application Support/Mendeley Desktop/*.sqlite`
