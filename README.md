# MyCalendar

#### App Store 
https://apps.apple.com/jp/app/%E3%82%AB%E3%83%AC%E3%83%B3%E3%83%80%E3%83%BC%E7%AE%A1%E7%90%86todo/id1529903174




## Operating environment / 動作環境
* 【Xcode】 Version 11.7
* 【Swift】 version 5.2.4
* 【CocoaPods】version 1.9.3
* 【RealmSwift】 version 5.3.2
* 【FSCalendar】version 2.8.1


## Purpose / 目的
To gain experience in developing a series of iOS apps before releasing them on the App Store.  
App Storeにリリースするまでの一連のiOSアプリ開発の経験を積むため。


## Theme reason / テーマ理由
As a beginner, I first focused on solving problems that I found inconvenient.  
I wanted an app that could manage a little to-do list, but I didn't have an app that suits me because the ones in the App Store are sophisticated and complicated operations, or too simple and unsatisfactory. I decided to develop it myself.  

初学者のため、まずは自分が不便だと思う課題を解決することにフォーカスをあてました。
ちょっとしたやることリストを管理できるアプリが欲しいなと思っていましたが、App Storeにあるものは高機能で複雑な操作であったり、シンプルすぎて物足りなかったりと自分に合ったアプリが無かったため、自分で開発しようと決めました。


## Main functions / 主な機能
1. Register, delete, change tasks  
  タスクの登録、削除、変更
2. Record notes related to tasks  
  タスクに関連するメモの記録
3. Task management using calendar  
  カレンダーを用いたタスク管理
4. Display task execution location using an external map app  
  タスクの実行場所を外部のマップアプリを用いて表示
5. Notification settings  
  通知の設定
6. Theme color settings  
  テーマカラーの設定


## Technology selection / 技術選定
Realm Swift adopted for database design.  
データベース設計にRealmSwiftを採用しました。  

* Large amount of data is not saved  
  大容量のデータは保存されない
* Can be saved offline  
  オフラインでも保存可能である  
* Fast access to the database  
  データベースへのアクセスが高速にできる  

I chose Realm Swift for the above reasons.  
上記を理由にRealmSwiftを選定しました。


## Conscious part / 意識した点
1. Although it was for learning, it will be posted on the App Store, so I referred to the evaluation reviews of various Todo apps to find out what kind of issues users have and what kind of functions they want. And I was conscious of incorporating as much as possible.  
   学習のためではありましたがApp Storeに掲載されるため、色々なTodoアプリの評価レビューを参考にユーザーがどのような課題を持ち、どのような機能を望んでいるのか調べました。そして可能な限り取り入れることを意識しました。  

> * I want a notification function because I forget that I filled it out  
>   記入をしたことを忘れてしまうので通知機能が欲しい  
> * I want to change the theme color to change my mood  
>   気分転換にテーマカラーを変更したい
> * With the task completion mark, you can feel the sense of accomplishment and continue.  
>   タスク完了マークがあると達成感を味わうことができ、継続することができる  
> * ~~It's a hassle to fill in the tasks to be performed every day~~  
>   ~~毎日実行するタスクを毎回記入するのが手間である~~
  

2. Multilingual support so that overseas users can use it.  
   海外のユーザーにも使ってもらえるように多言語対応しました。

