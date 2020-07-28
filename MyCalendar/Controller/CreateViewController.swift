//
//  CreateViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/10.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit
import RealmSwift

class CreateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Sectionで使用する配列を定義
    let sections: Array = ["タスク","ステータス","日時","場所","メモ"]
    
    // 通知のdatePickerの表示に関する定義
    var IsAlertDone: Bool = false
    
    // ステータスの「未完了」「完了済」を表すフラグ
    var IsStatusDone: Bool = false
    
    // タスクのセルのTextFieldのタップイベントを検出するフラグ
    var IstaskCellDone: Bool = false
    
    var dateString: String!
    
    // ShowViewControllerから渡された値を格納
    var tapCalendarDate: String!
    var selectedIndex: IndexPath?
    
    var showTodolist = Todo()
    
    var IsShowTransition: Bool = true

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = .systemTeal
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tableView.register(UINib(nibName: "TextCustomCell", bundle: nil), forCellReuseIdentifier: "TextCustomCell")
        tableView.register(UINib(nibName: "StatusCustomCell", bundle: nil), forCellReuseIdentifier: "StatusCustomCell")
        tableView.register(UINib(nibName: "DateCustomCell", bundle: nil), forCellReuseIdentifier: "DateCustomCell")
        tableView.register(UINib(nibName: "NoticeCustomCell", bundle: nil), forCellReuseIdentifier: "NoticeCustomCell")
        tableView.register(UINib(nibName: "MemoCustomCell", bundle: nil), forCellReuseIdentifier: "MemoCustomCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // 画面遷移元の判別（ShowViewControllerからの場合、IsShowTransitionを「true」）
        let count = (self.navigationController?.viewControllers.count)! - 2
        if (self.navigationController?.viewControllers[count] as? MainViewController) != nil {
            IsShowTransition = false
        } else {
            IsShowTransition = true
        }
        
        // ShowViewControllerから渡された値をshowTodolistに格納
        if IsShowTransition {
            
            do {
                // Realmオブジェクトの生成
                let realm = try Realm()
                // 参照（タップした日付のデータを取得）
                let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'")
                
                showTodolist.task = todos[selectedIndex!.row as Int].task
                IsStatusDone = todos[selectedIndex!.row as Int].status
                showTodolist.date = todos[selectedIndex!.row as Int].date
                IsAlertDone = todos[selectedIndex!.row as Int].alert
                
                if todos[selectedIndex!.row as Int].alertDate == nil {
                    
                } else {
                    showTodolist.alertDate = todos[selectedIndex!.row as Int].alertDate!
                }
                
                showTodolist.place = todos[selectedIndex!.row as Int].place
                showTodolist.memo = todos[selectedIndex!.row as Int].memo
                
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
        // 日時の取得
        let dateIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        let dateCell = dateIndex?.contentView.viewWithTag(2) as? UIDatePicker
        let date = dateCell?.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dateString = formatter.string(from: date!)

        // 通知の取得（任意）
        let timeIndex = tableView.cellForRow(at: IndexPath(row: 2, section: 2))
        let timeCell = timeIndex?.contentView.viewWithTag(2) as? UIDatePicker
        let time = timeCell?.date
        // 場所の取得（任意）
        let placeIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 3))
        let placeCell = placeIndex?.contentView.viewWithTag(1) as? UITextField
        let place = placeCell?.text
        // メモの取得（任意）
        let memoIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 4))
        let memoCell = memoIndex?.contentView.viewWithTag(3) as? UITextView
        let memo = memoCell?.text
        
        do {
            // Realmオブジェクトの生成
            let realm = try Realm()
            
            // RealmスタジオのURL
            print("-----------------------")
            print(Realm.Configuration.defaultConfiguration.fileURL!)
            print("-----------------------")
            
            if task == "" {
                // 警告アラート
                failAlert(title: "登録失敗", message: "タスクを記入してください！")
            } else {
                if !IsShowTransition {
                    // 新規登録
                    let todos = Todo()
                    todos.task = task!
                    todos.status = IsStatusDone
                    todos.date = date!
                    todos.dateString = dateString
                    todos.alert = IsAlertDone
                                                    
                    if IsAlertDone {
                        todos.alertDate = time!
                    } else {
                        todos.alertDate = nil
                    }
                                    
                    todos.place = place!
                    todos.memo = memo!

                    try realm.write {
                        realm.add(todos)
                    }

                } else {
                    // 登録更新
                    let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'")
                    try realm.write {
                        todos[selectedIndex!.row as Int].task = task!
                        todos[selectedIndex!.row as Int].status = IsStatusDone
                        todos[selectedIndex!.row as Int].date = date!
                        todos[selectedIndex!.row as Int].dateString = dateString
                        todos[selectedIndex!.row as Int].alert = IsAlertDone
                        
                        if IsAlertDone {
                            todos[selectedIndex!.row as Int].alertDate = time!
                        } else {
                            todos[selectedIndex!.row as Int].alertDate = nil
                        }
                        
                        todos[selectedIndex!.row as Int].place = place!
                        todos[selectedIndex!.row as Int].memo = memo!
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
    
    // 「タスク」未記入時に警告アラートに関する処理
    func failAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // データ色々（最終は消去）
    @IBAction func hogeButton(_ sender: Any) {
        
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
        
        
//        // Realmオブジェクトの生成
//        let realm = try! Realm()
//
//        // 削除
//        let lastTodo = realm.objects(Todo.self).last!
//        try! realm.write {
//            realm.delete(lastTodo)
//        }
        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Second", bundle: nil)
//        let navigationController = storyboard.instantiateViewController(withIdentifier: "navigation") as! UINavigationController
//        self.present(navigationController, animated: true, completion: nil)

        
        
        
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
        case 1:
            return 2
        case 2:
            if !IsAlertDone {
                return 2
            } else {
                return 3
            }
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
            if IsShowTransition {
                cell.datePicker.date = showTodolist.date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy/MM/dd HH:mm"
                cell.label.text = formatter.string(from: showTodolist.date)
            }
            return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCustomCell", for: indexPath) as? NoticeCustomCell else {
                    return UITableViewCell()
                }
                if IsShowTransition && IsAlertDone {
                    cell.changeSwitch.isOn = true
                }
                // Cellのdelegateにselfを渡す
                cell.delegate = self
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateCustomCell", for: indexPath) as? DateCustomCell else {
                    return UITableViewCell()
                }
                if IsShowTransition && showTodolist.alertDate != nil {
                    cell.datePicker.date = showTodolist.alertDate!
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy/MM/dd HH:mm"
                    cell.label.text = formatter.string(from: showTodolist.alertDate!)
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
        
        // datePickerの表示に関しての処理
        if indexPath.section == 2 {
            if indexPath.row == 0 || indexPath.row == 2 {
                guard let cell = tableView.cellForRow(at: indexPath) as? DateCustomCell else { return }
                cell.isPickerDisplay.toggle()
                tableView.performBatchUpdates(nil, completion: nil)
            }
        }
        
    }
    
}

// Cellのdelegateメソッドで削除処理を実装
extension CreateViewController: NoticeCustomCellDelegate {
    
    func switchOnAction() {

        guard !IsAlertDone else { return }
        IsAlertDone = true
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(item: 2, section: 2)], with: .fade)
        }, completion: nil)
        
    }
    
    func switchOffAction() {

        guard IsAlertDone else { return }
        IsAlertDone = false
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [IndexPath(item: 2, section: 2)], with: .fade)
        }, completion: nil)

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






