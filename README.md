# <さけこれ〜Sake Collection〜>

## サイト概要

①自分の在庫
- 買ってきたものを新規追加
- 何本残っているか、未開栓・開栓済みごとの本数を表示
- お酒を追加する際は写真と銘柄名のみの投稿
- 未開栓（デフォルト）から、飲んだ量に合わせて25%、50%、75%、飲み切りの5段階のステータスを編集
- 飲用後、淡麗/濃醇、甘口/辛口、フルーティー/スッキリなど、味の感想もラジオボタンで簡単に記録
- 既に投稿したお酒のうち、飲み切ったものは完飲ボックスに表示することで過去の在庫も見れるように

②他のアカウントの在庫
- お互いの在庫は公開（全ユーザーの投稿一覧は作らない）
- フォロー機能で、お気に入りのアカウントを見つける
- 各投稿にいいねができる
- 各投稿にコメントができる

### サイトテーマ
お酒の在庫（コレクション）を管理すると共に、コレクションを公開して自慢し合うことを目的としたSNSサイト。

### テーマを選んだ理由
日本酒好きの人はついついお酒を多く買って在庫を大量に抱えがち。今手持ちに何がどのくらいの量あるのかを把握し、余分に買いすぎることを防止してフードロス削減につなげたい。<br>
そして、本来自己満足で終わってしまう希少なコレクションを公開し、いいねやコメントによる評価を得ることで、ユーザーの承認欲求をくすぐりたい。

### ターゲットユーザ
日本酒が好きで、自身でもお酒を購入するユーザーがメインターゲット。既に別のSNSで発信している人も取り込みたい。<br>
日本酒に興味があるものの、まだ入り口にいるような方にとっても一歩踏み込むきっかけとなるようなサイトにしたい。

### 主な利用シーン
1. ユーザーがお酒を買ってきた際、在庫リストとして登録するのに使用してもらう。
2. ユーザーがお酒を購入する前に、似たようなお酒を持っていたり在庫過多になっていたりしていないかチェックするために使用してもらう。
3. ユーザーが気になるアカウントを探し、そのユーザーがどんなお酒を買っているかチェックするのに使用してもらう。
4. 気になるユーザーをフォローし合ったり、その投稿にいいね、コメントをし合うことで、共通の趣味を持つ仲間を探すのにも使用してもらう。

## 設計書
- テーブル定義書
https://docs.google.com/spreadsheets/d/1ZFW3AhkhQjd5JS8vT1oNdeQuUxR-4aVW/edit#gid=1460457709
- ER図
<img width="620" alt="スクリーンショット 2022-10-29 14 41 52" src="https://user-images.githubusercontent.com/109211405/198816057-cf03bf43-2b7c-4e84-95e8-dee704c03a14.png">


## 開発環境
- OS：Linux(CentOS)
- 言語：HTML,CSS,JavaScript,Ruby,SQL
- フレームワーク：Ruby on Rails
- JSライブラリ：jQuery
- IDE：Cloud9
- ruby 3.1.2
- Rails 6.1.7

## 使用素材
- ロゴ画像 => Canva
URL => https://www.canva.com/ja_jp/create/logos/