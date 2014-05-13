---
layout: post
title: "CSVデータをデータベース化するツール「CtoD」の紹介"
description: ""
category: 
tags: 
date: 2013-11-14
published: true
---
{% include JB/setup %}

前の記事では`CtoD`を使ってCSVデータからHeroku上にWebアプリを構築する手順を説明しました。

> [Excelデータを最速でWebアプリ(Heroku)にする<del>１０</del>９のステップ]({{ BASE_PATH }}/2013/11/11/your-data-from-excel-to-the-web/ "Excelデータを最速でWebアプリ(Heroku)にする<del>１０</del>９のステップ")

ここでは`CtoD`の詳細を説明します。対象バージョンは0.0.3です。

> [ctoD \| RubyGems.org \| your community gem host](https://rubygems.org/gems/ctoD "ctoD \| RubyGems.org \| your community gem host")
> 
> [melborne/ctoD](https://github.com/melborne/ctoD "melborne/ctoD")

## 使い方

`gem install ctoD`でインストールすると、`ctoD`ターミナルコマンドが使えるようになります。サブコマンドを渡さなければそのヘルプが表示されます。

{% highlight bash %}
% ctoD
Commands:
  ctoD create_table CSV DATABASE  # Create a database table for CSV
  ctoD export CSV DATABASE        # Export CSV data to DATABASE
  ctoD help [COMMAND]             # Describe available commands or one specific command
  ctoD version                    # Show CtoD version
{% endhighlight %}

`create_table`サブコマンドは、引数で渡したDATABASEにテーブルを生成します。テーブルの名称およびスキーマは第1引数で渡すCSVデータの内容に基づき構築されます。第1引数のCSVにはそのファイルパスを指定し、第2引数のDATABASEにはデータベースURLアドレスを指定します。


`export`サブコマンドは、DATABASEに該当テーブルがなければそれを構築した上で、CSVデータの内容をテーブルにストアします。

## データベースURL

第2引数で渡すデータベースURLは、スキーマ、ユーザおよびそのパスワード、ホスト、データベース名で構成されるデータベースのアドレスです。例を示します。

    postgres://localhost/movies

    mysql://root:mypasswd@localhost/movies

    sqlite3://localhost//Users/username/path/to/file

mysqlの例ではユーザ名とパスワードを渡しています。sqlite3の例ではデータベースとなるファイルの絶対パスを渡します（ホストとパスの間の`//`に注意）。

## CSVデータの規約

`CtoD`では基になるCSVデータの内容に応じてテーブルのスキーマを決定しています。フィールドのデータ型はActiveRecordにおけるデータ型の何れかです（CtoDではテーブルの生成にActiveRecord::Base.connection.create_tableを使っています）。version0.0.3におけるルールは次のようになっています（将来変更の可能性があります）。

> 1. テーブル名はCSVファイル名と同じとなる
> 1. CSVの先頭行はテーブルのヘッダーとして使われる
> 1. 先頭レコードにおける値が'true'または'false'のフィールドは、boolean型になる
> 1. 先頭レコードにおける値が`YYYY-MM-DD`または`YYYY/MM/DD`の形式のフィールドは、date型になる
> 1. 値が数値で構成されるフィールドは、そのフィールドの何れかの値がFloat型である場合はfloat型に、そうでない場合はinteger型になる
> 1. 既定の文字数（デフォルトで100文字）を超える値を持ったフィールドはtext型に、それ以外はstring型になる
> 1. 先頭レコードにおける値がないフィールドは、string型になる
> 1. id, created_at, updated_atの各フィールドが自動生成される

text型を判定する文字数は、create_tableまたはexportコマンドの`--string-size`オプションで変更できます。

この規約に従って期待するテーブルを作るために、以下の方針を取るのがいいです。

> 1. CSVのファイル名は英単語の複数形にすること（ActiveRecordを使っているため）
> 1. 余分な行・列が含まれていないこと
> 1. 各フィールドのヘッダー名が各異なる**英文字**であること
> 1. idフィールドは削除すること
> 1. 日付のフィールドは`YYYY-MM-DD`または`YYYY/MM/DD`の形式とすること
> 1. 論理値の値は'true'または'false'にすること
> 1. 先頭レコードの各フィールドをできるだけ空欄にしないこと

## sqlite3での例

以下のような`langs.csv`があるとして、SQLite3でテーブルを作る方法を示します。

    year,name,designer,predecessor
    1995,Ruby,Yukihiro Matsumoto,Smalltalk / Perl
    1959,LISP,John McCarthy,IPL
    1972,Smalltalk,Daniel Henry Holmes Ingalls Jr. / Xerox PARC,Simula 67
    1990,Haskell,Simon Peyton Jones,Miranda
    1995,JavaScript,Brendan Eich,LiveScript
    1995,Java,James Gosling,C / Simula 67 / C++ / Smalltalk
    1993,Lua,Roberto Ierusalimschy,Scheme / SNOBOL / Modula / CLU
    1987,Erlang,Joe Armstrong,Prolog

> from [Timeline of programming languages - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Timeline_of_programming_languages "Timeline of programming languages - Wikipedia, the free encyclopedia")

`export`サブコマンドを実行します。

{% highlight bash %}
/plangs% ctoD export langs.csv sqlite3://localhost/$PWD/langs.sqlite3
Table 'langs' created at sqlite3://localhost//Users/keyes/plangs/langs.sqlite3.
CSV data exported successfully.
/plangs% ls
langs.csv     langs.sqlite3
{% endhighlight %}


テーブルが生成されているか確かめてみます。

    /plangs% sqlite3 langs.sqlite3
    SQLite version 3.7.13 2012-07-17 17:46:21
    Enter ".help" for instructions
    Enter SQL statements terminated with a ";"
    sqlite> .tables
    langs
    sqlite> .schema
    CREATE TABLE "langs" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "year" integer, "name" varchar(255), "designer" varchar(255), "predecessor" varchar(255), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);

テーブルのスキーマを見ると、id, created_at, updated_atのフィールドが自動生成されているのが分かります。また`year`フィールドのデータ型は`integer`で他は`varchar(255)`であることが確認できます。

テーブルにデータが挿入されているかも確認します。

    sqlite> select name, designer, year from langs;
    Ruby|Yukihiro Matsumoto|1995
    LISP|John McCarthy|1959
    Smalltalk|Daniel Henry Holmes Ingalls Jr. / Xerox PARC|1972
    Haskell|Simon Peyton Jones|1990
    JavaScript|Brendan Eich|1995
    Java|James Gosling|1995
    Lua|Roberto Ierusalimschy|1993
    Erlang|Joe Armstrong|1987


## PostgreSQLでの例

事前にdatabaseを作っておく必要があります。ここでは`psql`コマンドを使います。


    /plangs% psql
    psql (9.3.0)
    Type "help" for help.
    
    keyes=# create database langs;
    CREATE DATABASE
    keyes=# \l
                             List of databases
       Name    | Owner | Encoding | Collate | Ctype | Access privileges
    -----------+-------+----------+---------+-------+-------------------
     keyes     | keyes | UTF8     | C       | C     |
     langs     | keyes | UTF8     | C       | C     |
     postgres  | keyes | UTF8     | C       | C     |

`ctoD export`サブコマンドを実行します。

{% highlight bash %}
/plangs% ctoD export langs.csv postgres://localhost/langs
Table 'langs' created at postgresql://localhost/langs.
CSV data exported successfully.
{% endhighlight %}


テーブルが生成されているか確かめてみます。

    /plangs% psql langs
    psql (9.3.0)
    Type "help" for help.
    
    langs=# \d langs;
                                          Table "public.langs"
       Column    |            Type             |                     Modifiers
    -------------+-----------------------------+-------------------------------
     id          | integer                     | not null default nextval('langs_id_seq'::regclass)
     year        | integer                     |
     name        | character varying(255)      |
     designer    | character varying(255)      |
     predecessor | character varying(255)      |
     created_at  | timestamp without time zone | not null
     updated_at  | timestamp without time zone | not null
    Indexes:
        "langs_pkey" PRIMARY KEY, btree (id)

テーブルにデータが挿入されているかも確認します。

    langs=# select name, designer, year from langs;
        name    |                   designer                   | year
    ------------+----------------------------------------------+------
     Ruby       | Yukihiro Matsumoto                           | 1995
     LISP       | John McCarthy                                | 1959
     Smalltalk  | Daniel Henry Holmes Ingalls Jr. / Xerox PARC | 1972
     Haskell    | Simon Peyton Jones                           | 1990
     JavaScript | Brendan Eich                                 | 1995
     Java       | James Gosling                                | 1995
     Lua        | Roberto Ierusalimschy                        | 1993
     Erlang     | Joe Armstrong                                | 1987
    (8 rows)


## MySQLでの例

事前にdatabaseを作っておく必要があります。ここでは`mysql`コマンドを使います。

    /plangs% mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 2
    Server version: 5.6.14 MySQL Community Server (GPL)
    
    mysql> create database langs character set utf8;
    Query OK, 1 row affected (0.00 sec)
    
    mysql> show databases;
    +--------------------+
    | Database           |
    +--------------------+
    | information_schema |
    | langs              |
    | mysql              |
    | performance_schema |
    +--------------------+


`ctoD export`サブコマンドを実行します。

{% highlight bash %}
/plangs% ctoD export langs.csv mysql://root:xxxx@localhost/langs
Table 'langs' created at mysql://root:xxxx@localhost/langs.
CSV data exported successfully.
{% endhighlight %}


テーブルが生成されているか確かめてみます。

    /plangs% mysql -u root -p
    Enter password:
    Welcome to the MySQL monitor.  Commands end with ; or \g.
    Your MySQL connection id is 6
    Server version: 5.6.14 MySQL Community Server (GPL)
    
    mysql> use langs;
    Reading table information for completion of table and column names
    You can turn off this feature to get a quicker startup with -A
    
    Database changed
    mysql> show create table langs;
    +-------+---------------------------------------------+
    | Table | Create Table                                |
    +-------+---------------------------------------------+
    | langs | CREATE TABLE `langs` (
      `id` int(11) NOT NULL AUTO_INCREMENT,
      `year` int(11) DEFAULT NULL,
      `name` varchar(255) DEFAULT NULL,
      `designer` varchar(255) DEFAULT NULL,
      `predecessor` varchar(255) DEFAULT NULL,
      `created_at` datetime NOT NULL,
      `updated_at` datetime NOT NULL,
      PRIMARY KEY (`id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 |
    +-------+----------------------------------------------+
    1 row in set (0.01 sec)


テーブルにデータが挿入されているかも確認します。

    mysql> select name, designer, year from langs;
    +------------+----------------------------------------------+------+
    | name       | designer                                     | year |
    +------------+----------------------------------------------+------+
    | Ruby       | Yukihiro Matsumoto                           | 1995 |
    | LISP       | John McCarthy                                | 1959 |
    | Smalltalk  | Daniel Henry Holmes Ingalls Jr. / Xerox PARC | 1972 |
    | Haskell    | Simon Peyton Jones                           | 1990 |
    | JavaScript | Brendan Eich                                 | 1995 |
    | Java       | James Gosling                                | 1995 |
    | Lua        | Roberto Ierusalimschy                        | 1993 |
    | Erlang     | Joe Armstrong                                | 1987 |
    +------------+----------------------------------------------+------+
    8 rows in set (0.01 sec)

## Rubyからデータベースに接続する

`CtoD`は`CtoD::DB.connect`というデータベースに接続するためのメソッドをもっており、かつActiveRecordをrequireしているので、Rubyからデータベースにアクセスするのは簡単です。irbを立ち上げてアクセスしてみます。

{% highlight irb %}
/plangs% irb -rctoD
IRB on Ruby2.0.0
>> conn = CtoD::DB.connect("postgres://localhost/langs") #=> #<URI::Generic:0x007f81f330c4e8 URL:postgresql://localhost/langs>
>> class Lang < ActiveRecord::Base; end #=> nil
>> Lang.all
┌-------------------------------------------------------------------------------
│ id ╎ year ╎ name       ╎ designer            ╎ predecessor                 │
┌-------------------------------------------------------------------------------
│ 1  ╎ 1995 ╎ Ruby       ╎ Yukihiro Matsumoto  ╎ Smalltalk / Perl            │
│ 2  ╎ 1959 ╎ LISP       ╎ John McCarthy       ╎ IPL                         |
│ 3  ╎ 1972 ╎ Smalltalk  ╎ Daniel Henry Holmes ╎ Simula 67                   |
│ 4  ╎ 1990 ╎ Haskell    ╎ Simon Peyton Jones  ╎ Miranda                     |
│ 5  ╎ 1995 ╎ JavaScript ╎ Brendan Eich        ╎ LiveScript                  |
│ 6  ╎ 1995 ╎ Java       ╎ James Gosling       ╎ C / Simula 67 / C++ / Smallt╎
│ 7  ╎ 1993 ╎ Lua        ╎ Roberto Ierusalimsch╎ Scheme / SNOBOL / Modula / C╎
│ 8  ╎ 1987 ╎ Erlang     ╎ Joe Armstrong       ╎ Prolog                      | 
└-------------------------------------------------------------------------------
8 rows in set
>> Lang.where(year:1995)
┌-------------------------------------------------------------------------------
│ id ╎ year ╎ name       ╎ designer            ╎ predecessor                 │
┌-------------------------------------------------------------------------------
│ 1  ╎ 1995 ╎ Ruby       ╎ Yukihiro Matsumoto  ╎ Smalltalk / Perl            │
│ 5  ╎ 1995 ╎ JavaScript ╎ Brendan Eich        ╎ LiveScript                  |
│ 6  ╎ 1995 ╎ Java       ╎ James Gosling       ╎ C / Simula 67 / C++ / Smallt╎
└-------------------------------------------------------------------------------
3 rows in set
{% endhighlight %}


以上です。

データベースのシードを適当に作る場合などに使ってもらえるといいかもしれません。

---

<p style='color:red'>=== Ruby関連電子書籍100円で好評発売中！ ===</p>

[M'ELBORNE BOOKS]({{ BASE_PATH }}/books/ "M'ELBORNE BOOKS")

<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/02/ruby_object_cover.png" alt="ruby_object" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/04/ruby_tutorial_cover.png" alt="ruby_tutorial" style="width:200px" />
</a>
<a href="{{ BASE_PATH }}/books/">
  <img src="/assets/images/2013/03/ruby_trivia_cover.png" alt="ruby_trivia" style="width:200px" />
</a>

