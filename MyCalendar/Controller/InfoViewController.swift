//
//  InfoViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/08/02.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit
import RealmSwift

class InfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Sectionで使用する配列を定義
    let sections: Array = ["カラー設定","登録データ","サポート"]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "情報"
        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = .systemTeal
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        // 左上の閉じるボタン
        let closeBtn = UIBarButtonItem(
          title: "閉じる",
          style: .plain,
          target: self,
          action: #selector(self.cancelProject(sender:))
        )
        self.navigationItem.setLeftBarButton(closeBtn, animated: true)
        
    }
    
    // モーダルを閉じる処理
    @objc func cancelProject(sender: UIBarButtonItem){
      self.dismiss(animated: true, completion: nil)
    }
    
}

extension InfoViewController: UITableViewDataSource {
    
    // セクションの数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    // テーブルに表示する配列の総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = "テーマカラー変更"
            return cell
        case 1:
            cell.textLabel?.text = "登録データ全消去"
            return cell
        default:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "このアプリを紹介する"
                return cell
            case 1:
                cell.textLabel?.text = "評価する"
                return cell
            case 2:
                cell.textLabel?.text = "プライバシーポリシー"
                return cell
            default:
                cell.textLabel?.text = "フリーアイコンのリンク"
                return cell
            }
        }
    }
    
}

extension InfoViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        // テーマカラー変更の処理
        if indexPath.section == 0 {
            self.performSegue(withIdentifier: "color", sender: nil)
        }
        
        
        
        
        // 登録データ全消去の処理
        if indexPath.section == 1 {
            let alertController = UIAlertController(title: "登録データ全消去しますか？", message: "「はい」を押すと復元できません", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "はい", style: .default) { (alert) in
                do {
                    // Realmオブジェクトの生成
                    let realm = try Realm()
                    // 削除（タップした日付のデータを取得）
                    let todos = realm.objects(Todo.self)
                    try realm.write {
                        realm.delete(todos)
                    }
                } catch {
                    print(error)
                }
                // 通知の削除
                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            }

            let noAction = UIAlertAction(title: "いいえ", style: .cancel)

            alertController.addAction(okAction)
            alertController.addAction(noAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        
    }
}


