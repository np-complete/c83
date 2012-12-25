# ワークフロー例

前章のルールに沿った開発風景の例です。

## 準備

まずmasterブランチは最初から存在しているはずです。
開発環境にデプロイするために、developブランチがない場合は作りましょう。

```
$ git branch -a
```

でリモートブランチを含んだブランチの一覧を表示します。
developがなかったら、

```
$ git checkout -b develop
$ git push origin develop
```

でdevelopブランチを作ってpushします。

すでにリモートにdevelopブランチがある場合は、

```
$ git checkout -b develop origin/develop
```

でdevelopブランチを手元に持ってきます。

### githubを使っている場合

githubを使っている場合は、チームのリモートリポジトリを直接触るのではなく、
プロジェクトを自分のアカウントにforkして、それをcloneします。

```
(githubのWebでfork)
$ git clone git://github.com/team_account/project.git
$ cd ./project
$ git remote add my_account git@github.com:my_account/project.git
```

hubコマンドが使えるなら、

```
$ hub clone team_account/project
$ cd ./project
$ hub fork
```

でも同じことができます。

今後、originのリモートリポジトリにしていい操作は、
基本的に、developをpushすることと、masterをpullしてくることだけです。
他の操作はmy_accountのリモートリポジトリに対して行い、originへの変更は全てプルリクエスト経由で行います。

## 開発開始

まず新しい機能を作り始めるときは、ブランチを切ります。

```
$ git checkout master
$ git checkout -b topic_A
```

それなりにコミット単位を意識して、トピックブランチにコミットしていきます。
あとから複数のコミットをくっつけるのは簡単ですが、1つのコミットを分割するのは大変です。
なるべく細かい単位で、複数意味の変更が一つのコミットに入らないようにしましょう。

## 開発環境にデプロイ

トピックブランチの開発が終わり、自動テストで十分テストできたら、
開発環境にデプロイし、実際の動作や特にテストでは書きづらい見た目周りの確認をします。
開発したトピックブランチをdevelopブランチにマージし、デプロイします。

```
$ git checkout develop
$ git merge topic_A
$ git push origin develop
$ cap dev deploy          # 例えばcapを使う場合
```

developブランチは、開発者全員からトピックブランチを頻繁にマージされる、総受けブランチです。
この段階でマージされるコミットは、どれだけ汚くても構いません。

developブランチにマージした際のコンフリクトは、
今の段階では、developブランチ上で解決し、
適当にfix conflictとでもコミットしておけば大丈夫です。
ただしmasterにマージする際に手間がかかるようになると覚えておきましょう。

試行錯誤のコミットやfixとしか書かれていないコミットメッセージでも全然問題ありません。
納得行くまでコミットとデプロイを繰り返し、トピックを改善していきます。
(もちろん改善コミットはトピックブランチで行います。)

### developブランチをぶっ壊す

開発を続けていくと、developブランチは非常に汚いブランチになります。
こうなった場合は、綺麗サッパリ作り直しましょう。
リモートのdevelopブランチを消し、もう一度masterから作り直します。
作りなおしたdevelopブランチに、トピックブランチを歴史改変で整理してからもう一度マージすれば、
今度は以前より綺麗なdevelopブランチになります。

```
$ git push origin :develop    # 空白のブランチでdevelopを上書き
$ git checkout master
$ git checkout -b develop
$ git push origin develop     # masterからdevelopを切り直してリモートブランチに
$ git merge topic_A ; git merge topic_B ...
$ git push origin develop
```

作業の前にはチームメンバーにひと声かけましょう。

## masterにマージする

開発が終わったらmasterにマージして、コードを最新にします。

### マージのタイミングはいつ?

masterにマージするタイミングは、リリースのスケジュールと深く関わってきます。
「masterブランチは今動いているコード」というルールを思い出してください。
つまりこれは、masterにマージしたらそのコードはすぐリリースされなければいけない、
すぐにリリースできないのであればmasterに入れてはいけない、という事を意味します。

リリースのタイミングは会社やプロジェクトによって様々だと思います。

頻繁に本番リリースが許されている会社の場合、
開発が終わったトピックブランチ一つをmasterにマージして、
すぐにデプロイするという方法が取れます。

1イテレーション(例えば1週間)に1回、定期リリースをするような運用方法の場合、
リリース直前に全てのトピックブランチをマージします。

### masterの最新を適応する

トピックブランチのマージ前に、最新のmasterの変更を適応します。

```
$ git checkout master
$ git pull --rebase origin master
```

トピックブランチのコミットが、最新のmasterから始まったことにするために、
rebaseをします。

```
$ git checkout topic_A
$ git rebase master
```

rebaseでコンフリクトが起こった場合、コンフリクトを解決し、

```
$ git add .
$ git rebase --continue
```

でリベースを続けます。

### 履歴を整理

```
$ git rebase -i master
```

でsquashして、ある程度履歴を綺麗にします。
意味のあるコミット単位にしましょう。

githubでオープンソースにPullRequestを送る場合、
全ての変更を一つのコミットにまとめるように要求しているプロジェクトが多くあります。
その場合は「squashしてください」と言われるので、全てのコミットをsquashして一つにまとめます。

もちろんこの場合も、一つのコミットでやりたいことを過不足なく表現する必要があります。
トピックブランチではトピック以外の作業を絶対にしてはいけない、
というルールに慣れると上手くできるようになると思います。

### マージする

マージする瞬間は特に注意しないといけません。

定期リリース型の場合、1回のリリースに複数の人がトピックブランチを持ち寄ることになります。
この場合、全員のトピックブランチのマージが上手く行かない事や、
単体ブランチのテストは上手く行っているが全部合わせた時のテストが失敗する場合があります。
もし直接masterにマージしていたら、masterに一瞬テストが落ちるという状態が発生してしまいます。

その状態を避けるために、いったんリリース予定のトピックブランチを全て集めた、
**releaseブランチ** を作るといいでしょう。
もちろんreleaseブランチはmasterから切ります。

```
$ git checkout master
$ git checkout -b release
$ git push origin release

全員が以下を繰り返す
$ git pull origin release
$ git merge --no-ff topic_A
$ git push origin release
```

すべてのトピックブランチをreleaseブランチにマージし、
コンフリクトが起こったら解決し、自動テストが全部通るのを確認します。
テストが通ったら、新たにmasterから切り直したdevelopブランチにreleaseブランチをマージし、
開発環境にデプロイして動作確認します。
動作確認が正常に終了したら、releaseブランチをmasterブランチにマージし(この時コンフリクトは絶対起きません)、
本番環境にデプロイします。
デプロイが終わったらタグをつけておきます。

```
$ git checkout master
$ git merge release
$ git push origin master
$ git tag release_hogehoge
$ git push --tags origin master
```

### githubでPullRequestベースの開発の場合

originではなく、自分のアカウントにトピックブランチをpushし、そのPullRequestを作ります。
PullRequestは全員でチェックして、送ったのとは別の人がマージのボタンを押します。

```
$ git checkout topic_A
$ git push my_account topic_A
(PullRequest)
```

他の人のPullRequestをマージした後、自分のPullRequestがコンフリクトする場合、
コンフリクトを解決したPullRequestで更新しなければいけません。
masterを最新に更新し、トピックブランチをmasterからrebaseし(ここでコンフリクトを解決)、
**いったんdevelopを作りなおして** マージし、検証から再開します。

```
$ git checkout master
$ git pull --rebase origin master
$ git checkout topic_A
$ git rebase master
(コンフリクト解決)
$ git push --force my_account topic_A
(PullRequest更新)
```

## 後始末

リリースが無事に終了したらトピックブランチを削除しま・・・せん!
何かが起こった時のために、最低2回分くらいのトピックは手元に残しておきましょう。

もしリリースに問題があった場合は、まず真っ先に正常に動いていた頃のコードに戻します。
デプロイツールがサポートしている場合は、その機能を使います。

```
$ cap production deploy:rollback
```

それができない場合は、前回のタグをチェックアウトして元に戻します。
本来、masterの歴史改変はやってはいけない作業ですが、
こういう状態の時は仕方ないでしょう。
masterはちゃんと動いているコードであるべきです。

```
$ git checkout master
$ git reset --hard old_tag_hoge
$ git push --force origin master
```

リセットしたらとりえずデプロイします。
前回と同じコードになったはずなので、問題なく動作するはずです。
サービス停止時間を最小限に抑えました。

元に戻したことを全員がリポジトリに反映させます。

```
$ git checkout master
$ git fetch --all
$ git reset --hard origin/master
```

全てのリリースを先延ばしにするなり、
問題のないコードだけを一旦リリースするなり決定し、
今回のリリースは終了です。

