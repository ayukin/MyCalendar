//
//  CreateViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/10.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class CreateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: UIBarButtonItem!

    // Sectionで使用する配列を定義
    let sections: Array = ["タスク","ステータス","日時","場所","メモ"]
    
    // ステータスの「未完了」「完了済」を表すフラグ
    var IsStatusDone: Bool = false
    
    // タスクのセルのTextFieldのタップイベントを検出するフラグ
    var IstaskCellDone: Bool = false
    
    // ShowViewControllerから渡された値を格納
    var tapCalendarDate: String!
    var selectedIndex: IndexPath?
    
    // MainViewControllerから渡された値を格納
    var tapCalendarTime: Date? = Date()

    var showTodolist = Todo()
    var IsShowTransition: Bool = true
    
    var dateString: String!
    var alertString: String!
    var alertDate: Date? = Date()
    var alertValueIndex = 0
    var alertId: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaultsのインスタンス
        let userDefaults = UserDefaults.standard
        // UserDefaultsから値を読み込む
        let myColor = userDefaults.colorForKey(key: "myColor")

        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = myColor
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.register(UINib(nibName: "TextCustomCell", bundle: nil), forCellReuseIdentifier: "TextCustomCell")
        tableView.register(UINib(nibName: "StatusCustomCell", bundle: nil), forCellReuseIdentifier: "StatusCustomCell")
        tableView.register(UINib(nibName: "DateCustomCell", bundle: nil), forCellReuseIdentifier: "DateCustomCell")
        tableView.register(UINib(nibName: "AlertCustomCell", bundle: nil), forCellReuseIdentifier: "AlertCustomCell")
        tableView.register(UINib(nibName: "MemoCustomCell", bundle: nil), forCellReuseIdentifier: "MemoCustomCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 画面遷移元の判別（ShowViewControllerからの場合、IsShowTransitionを「true」）
        let count = (self.navigationController?.viewControllers.count)! - 2
        if (self.navigationController?.viewControllers[count] as? MainViewController) != nil {
            IsShowTransition = false
            self.deleteButton.isEnabled = false
            self.deleteButton.tintColor = .clear
        } else {
            IsShowTransition = true
            self.deleteButton.isEnabled = true
            self.deleteButton.tintColor = .white
        }
        
        // ShowViewControllerから渡された値をshowTodolistに格納
        if IsShowTransition {
            
            do {
                // Realmオブジェクトの生成
                let realm = try Realm()
                // 参照（タップした日付のデータを取得）
                let todo = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
                
                showTodolist.task = todo[selectedIndex!.row as Int].task
                IsStatusDone = todo[selectedIndex!.row as Int].status
                showTodolist.date = todo[selectedIndex!.row as Int].date
                showTodolist.dateString = todo[selectedIndex!.row as Int].dateString
                showTodolist.alertValueIndex = todo[selectedIndex!.row as Int].alertValueIndex
                showTodolist.alertId = todo[selectedIndex!.row as Int].alertId
                
                if todo[selectedIndex!.row as Int].alertDate != nil {
                    showTodolist.alertDate = todo[selectedIndex!.row as Int].alertDate
                }
                
                showTodolist.place = todo[selectedIndex!.row as Int].place
                showTodolist.memo = todo[selectedIndex!.row as Int].memo
                
            } catch {
                print(error)
            }
        }
        
    }
        
    // キーボードが表示される際の処理（高さ調整）
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if IstaskCellDone {
                    self.view.frame.origin.y -= 0
                } else {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                self.view.frame.origin.y -= suggestionHeight
            }
        }
    }
    
    // キーボードと閉じる際の処理
    @objc func keyboardWillHide() {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Realmに記入内容を登録する処理
    @IBAction func recordButton(_ sender: Any) {
        
        // タスクの取得（必須）
        let taskIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 0))
        let taskCell = taskIndex?.contentView.viewWithTag(1) as? UITextField
        let task = taskCell?.text
        // 時間の取得
        let dateIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        let dateCell = dateIndex?.contentView.viewWithTag(2) as? UIDatePicker
        let date = dateCell?.date
                
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dateString = formatter.string(from: date!)
        
        // 通知の取得
        let alertIndex = tableView.cellForRow(at: IndexPath(row: 1, section: 2))
        let alertCell = alertIndex?.contentView.viewWithTag(4) as? UILabel
        alertString = alertCell?.text
        
        // 通知の取得（時間）
        switch alertString {
        case "なし":
            alertValueIndex = 0
            alertDate = nil
        case "予定時間":
            alertValueIndex = 1
            alertDate = date!
        case "5分前":
            alertValueIndex = 2
            alertDate = Date(timeInterval: -5*60, since: date!)
        case "10分前":
            alertValueIndex = 3
            alertDate = Date(timeInterval: -10*60, since: date!)
        case "15分前":
            alertValueIndex = 4
            alertDate = Date(timeInterval: -15*60, since: date!)
        case "20分前":
            alertValueIndex = 5
            alertDate = Date(timeInterval: -20*60, since: date!)
        case "30分前":
            alertValueIndex = 6
            alertDate = Date(timeInterval: -30*60, since: date!)
        case "1時間前":
            alertValueIndex = 7
            alertDate = Date(timeInterval: -1*60*60, since: date!)
        case "2時間前":
            alertValueIndex = 8
            alertDate = Date(timeInterval: -2*60*60, since: date!)
        case "3時間前":
            alertValueIndex = 9
            alertDate = Date(timeInterval: -3*60*60, since: date!)
        case "1日前":
            alertValueIndex = 10
            alertDate = Date(timeInterval: -1*60*60*24, since: date!)
        case "2日前":
            alertValueIndex = 11
            alertDate = Date(timeInterval: -2*60*60*24, since: date!)
        default:
            alertValueIndex = 12
            alertDate = Date(timeInterval: -3*60*60*24, since: date!)
        }
        
        // 通知IDの取得（ユニークなIDを作る）
        if !IsShowTransition {
            alertId = NSUUID().uuidString
        }
        
        // 場所の取得（任意）
        let placeIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 3))
        print(placeIndex!)
        let placeCell = placeIndex?.contentView.viewWithTag(1) as? UITextField
        print(placeCell!)
        let place = placeCell?.text
        print(place!)
        // メモの取得（任意）
        let memoIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 4))
        let memoCell = memoIndex?.contentView.viewWithTag(3) as? UITextView
        let memo = memoCell?.text
        
        let now: Date? = Date()
        
        do {
            // Realmオブジェクトの生成
            let realm = try Realm()
            
//            // RealmスタジオのURL
//            print("-----------------------")
//            print(Realm.Configuration.defaultConfiguration.fileURL!)
//            print("-----------------------")
            
            if task == "" {
                let alertController = UIAlertController(title: "登録失敗", message: "タスクを記入してください！", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else if alertDate != nil && !(now! <= alertDate!) {
                let alertController = UIAlertController(title: "登録失敗", message: "通知設定時間が過ぎています！", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            } else {
                if !IsShowTransition {
                    // 新規登録
                    let todo = Todo()
                    todo.task = task!
                    todo.status = IsStatusDone
                    todo.date = date!
                    todo.dateString = dateString
                    todo.alertDate = alertDate
                    todo.alertValueIndex = alertValueIndex
                    todo.alertId = alertId
                    todo.place = place!
                    todo.memo = memo!

                    try realm.write {
                        realm.add(todo)
                    }

                } else {
                    // 登録更新
                    let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
                    let todo = todos[selectedIndex!.row as Int]
                    try realm.write {
                        todo.task = task!
                        todo.status = IsStatusDone
                        todo.date = date!
                        todo.dateString = dateString
                        todo.alertDate = alertDate
                        todo.alertValueIndex = alertValueIndex
                        todo.place = place!
                        todo.memo = memo!
                    }
                    
                }
                
                // 編集処理の際に登録済の通知を削除し、リセットする
                if IsShowTransition {
                    if alertDate != nil {
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.showTodolist.alertId])
                    }
                }
                            
                if alertDate != nil {
                    
                    // ローカル通知の内容
                    let content = UNMutableNotificationContent()
                    content.sound = UNNotificationSound.default
                    content.title = ""
                    content.body = "「\(task!)」の\(String(describing: alertString!))です！"
                    content.sound = UNNotificationSound.default

                    // ローカル通知実行日時をセット
                    let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate!)

                    // ローカル通知リクエストを作成
                    let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
                    
                    // IDを定義
                    if IsShowTransition {
                        // 編集の場合
                        let request = UNNotificationRequest(identifier: self.showTodolist.alertId, content: content, trigger: trigger)
                        // ローカル通知リクエストを登録
                        UNUserNotificationCenter.current().add(request){ (error : Error?) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        // 新規の場合
                        let request = UNNotificationRequest(identifier: self.alertId, content: content, trigger: trigger)
                        // ローカル通知リクエストを登録
                        UNUserNotificationCenter.current().add(request){ (error : Error?) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                }
                
                // 登録完了しMainViewControllerへ画面遷移
                if !IsShowTransition {
                    let layere_number = navigationController!.viewControllers.count
                    self.navigationController?.popToViewController(navigationController!.viewControllers[layere_number-2], animated: true)
                } else {
                    let layere_number = navigationController!.viewControllers.count
                    self.navigationController?.popToViewController(navigationController!.viewControllers[layere_number-3], animated: true)
                }

            }

        } catch {
            print(error)
        }
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "編集中のタスクを\r削除しますか？", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "はい", style: .default) { (alert) in
            do {
                // Realmオブジェクトの生成
                let realm = try Realm()
                // 削除（タップした日付のデータを取得）
                let todos = realm.objects(Todo.self).filter("dateString == '\(self.tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
                let todo = todos[self.selectedIndex!.row as Int]
                try realm.write {
                    realm.delete(todo)
                }
            } catch {
                print(error)
            }
            // 通知の削除
            if self.alertDate != nil {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.showTodolist.alertId])
            }
            // MainViewControllerへ画面遷移
            let layere_number = self.navigationController!.viewControllers.count
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[layere_number-3], animated: true)
        }
        let noAction = UIAlertAction(title: "いいえ", style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
                
//        // Realmファイルを完全にディスクから削除する
//        autoreleasepool {
//          // all Realm usage here
//        }
//        let realmURL = Realm.Configuration.defaultConfiguration.fileURL!
//          let realmURLs = [
//          realmURL,
//          realmURL.appendingPathExtension("lock"),
//          realmURL.appendingPathExtension("note"),
//          realmURL.appendingPathExtension("management")
//        ]
//        let manager = FileManager.default
//        for URL in realmURLs {
//          do {
//            try FileManager.default.removeItem(at: URL)
//          } catch {
//            // handle error
//          }
//        }
        
    }
        
}


extension CreateViewController: UITableViewDataSource {
    
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
        case 1, 2:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextCustomCell", for: indexPath) as? TextCustomCell else {
                return UITableViewCell()
            }
            if IsShowTransition {
                cell.textField.text = showTodolist.task
            }
            // Cellのdelegateにselfを渡す
            cell.delegate = self
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatusCustomCell", for: indexPath) as? StatusCustomCell else {
                return UITableViewCell()
            }
            switch indexPath.row {
            case 0:
                cell.statusLabel.text = "未完了"
                // 「未完了」セルのチェックマーク状態をセット
                if !IsStatusDone {
                    // チェックあり
                    cell.accessoryType = StatusCustomCell.AccessoryType.checkmark
                } else {
                    // チェックなし
                    cell.accessoryType = StatusCustomCell.AccessoryType.none
                }
                return cell
            default:
                cell.statusLabel.text = "完了済"
                // 「完了済」セルのチェックマーク状態をセット
                if IsStatusDone {
                    // チェックあり
                    cell.accessoryType = StatusCustomCell.AccessoryType.checkmark
                } else {
                    // チェックなし
                    cell.accessoryType = StatusCustomCell.AccessoryType.none
                }
                return cell
            }
        case 2:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateCustomCell", for: indexPath) as? DateCustomCell else {
                return UITableViewCell()
                }
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                if IsShowTransition {
                    cell.datePicker.date = showTodolist.date
                    cell.label.text = formatter.string(from: showTodolist.date)
                }else if !IsShowTransition && tapCalendarTime != nil {
                    cell.datePicker.date = tapCalendarTime!
                    cell.label.text = formatter.string(from: tapCalendarTime!)
                }
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCustomCell", for: indexPath) as? AlertCustomCell else {
                    return UITableViewCell()
                }
                if IsShowTransition {
                    cell.alertPicker.selectRow(showTodolist.alertValueIndex, inComponent: 0, animated: false)
                    cell.alertLabel.text = cell.alertValues[showTodolist.alertValueIndex] as? String
                } else {
                    cell.alertPicker.selectRow(0, inComponent: 0, animated: false)
                    cell.alertLabel.text = cell.alertValues[0] as? String
                }
                return cell
            }
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextCustomCell", for: indexPath) as? TextCustomCell else {
                return UITableViewCell()
            }
            if IsShowTransition {
                cell.textField.text = showTodolist.place
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCustomCell", for: indexPath) as? MemoCustomCell else {
                return UITableViewCell()
            }
            if IsShowTransition {
                cell.textView.text = showTodolist.memo
            }
            return cell
        }
        
    }
    
}

extension CreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        // Statusのセルのチェックマークに関しての処理
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                guard IsStatusDone else { return }
                IsStatusDone.toggle()
            } else if indexPath.row == 1 {
                guard !IsStatusDone else { return }
                IsStatusDone.toggle()
            }
            // セルの状態を変更
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
            tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
            
        }
                
        // Pickerの表示に関しての処理
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                // datePickerの表示
                guard let cell = tableView.cellForRow(at: indexPath) as? DateCustomCell else { return }
                cell.isPickerDisplay.toggle()
                tableView.performBatchUpdates(nil, completion: nil)
            } else {
                // alertPickerの表示
                guard let cell = tableView.cellForRow(at: indexPath) as? AlertCustomCell else { return }
                cell.isPickerDisplay.toggle()
                tableView.performBatchUpdates(nil, completion: nil)
            }
            
        }
        
    }
    
}

extension CreateViewController: TextCustomCellDelegate{
    
    func keyboardShowAction() {
        IstaskCellDone = true
    }
    
    func keyboardHideAction() {
        IstaskCellDone = false
    }

}






