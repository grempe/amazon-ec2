amazon-ec2カスタマイズ版
====

コードに変更を加えた場合は`ChangeLog`の最上部に以下のようなエントリを追加します（バージョン番号は`x.x.x`のままでよい）。

    === x.x.x 2011-05-08
    * add NextToken support to Cloudwatch ListMetrics API. (juno)

変更した`amazon-ec2`をRailsアプリケーションに含める場合は、以下のような手順で行います。

    $ rake build  # => pkg/amazon-ec2-0.9.15.gemが生成される

    $ cd /path/to/rails-app
    $ rm -rf vendor/gems/amazon-ec2-0.9.15  # => 古いamazon-ec2ライブラリを削除する
    $ gem unpack /path/to/amazon-ec2-0.9.15.gem --target vendor/gems  # => 新しいamazon-ec2ライブラリを展開する
    $ ls vendor/gems
    amazon-ec2-0.9.15

`Gemfile`に以下の記述を追加する。

    gem 'amazon-ec2', :path => 'vendor/gems/amazon-ec2-0.9.15'

依存gemを更新する。

    $ bundle update

この時点で、`vendor/gems`以下および`Gemfile*`をコミットします。
