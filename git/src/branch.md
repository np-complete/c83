## ブランチルールを考える

多人数でGitを使う時、一番ミスが起こりやすいのはブランチ操作です。
ブランチのルールを決めることでミスを減らしましょう。

### なにを避けたいか

本番環境にリリースされるのはmasterブランチです。
このmasterブランチに糞を絶対に混ぜてはいけません。
masterブランチは歴史改変を基本的にするべきではないので、
一度間違った状態になったmasterブランチはずっと黒歴史として残ってしまいます。

ブランチ運用で起こしがちなミスを分析し、ミスが起こらないブランチ運用を目指しましょう。
例えばこのようなミスが起こります。

#### 入ってはいけないコードが入る

まだ動かないコードは絶対にmaster入れてはいけません。
当然気をつけると思いますが、ブランチを切る際のミスで簡単に起こってしまいます。

例えば、AブランチからBブランチを作り、Bブランチでひとつの機能を完成させたとします。
Bブランチで作られた機能は十分にテストされているので、安心してmasterにマージするでしょう。
この時、Bブランチだけをマージするつもりが、派生元のAブランチの内容までマージされてしまいます。
もしAブランチが全然未完成だったらどうなるでしょう?

#### 消してはいけないブランチを消してしまう

そんなミスしねえよと思うでしょうが、実際は気をつけないとよく起こります。
例えばリニューアル案件のためにrenewalというブランチを共有していたとします。
一旦入れた開発中のコードを取りやめるときに、developmentブランチと同じ要領でぶっ壊して作りなおしたりしたくなるでしょう。
この時、もし他の人がrenewalはmasterと同じように開発が終わったコードのみを入れるブランチだと思っていたらどうなるでしょう?
もしかしたらrenewalにマージしたブランチはすでに消してしまっているかもしれません。
チーム内で認識の相違があると、いつの間にか他の人のブランチを消してしまうことになってしまいます。

#### 後戻りできない

何度でもやり直せることは重要です。
問題を含んだリリースをしてしまった時、すぐに過去に戻れば問題は一旦解決します。
余裕を持って修正して再リリースすれば良いのです。
もしやり直しできない状態になってしまったら、問題を含んだまま急いで修正しなければなりません。
これは非常にストレスがかかります。

\input{"./gitflow.tex"}
\input{"./branch_rule.tex"}
