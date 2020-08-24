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
    let sections: Array = ["task".localized, "status".localized, "dateAndTime".localized, "place".localized, "memo".localized]
        
    // タスクのセルのTextFieldのタップイベントを検出するフラグ
    var IstaskCellDone: Bool = false
    
    // MainViewControllerから渡された値を格納する変数
    var tapCalendarTime: Date? = Date()
    
    // ShowViewControllerから渡された値を格納する変数
    var tapCalendarDate: String!
    var selectedIndex: IndexPath?
    var showTodoList = Todo()
    // ShowViewControllerからの画面遷移の有無を判別するフラグ
    var IsShowTransition: Bool = true
    
    // 編集内容を格納する変数
    var task: String = ""
    var status: Bool = false
    var date: Date? = Date()
    var dateString: String!
    var alertDate: Date? = Date()
    var alertValueIndex = 0
    var alertId: String!
    var place: String = ""
    var memo: String = ""
    var alertString: String!
    
    // TextCustomCellを「タスク」or「場所」を判別する変数
    var selectedTextCellIndex: IndexPath?
    
    // 通知登録の有無を変別する際に使用する変数
    var pendingNotification: Bool = false
    var deliveredNotification: Bool = false
    
    var myColor: UIColor!
    var selectColorNumber: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaultsのインスタンス
        let userDefaults = UserDefaults.standard
        // UserDefaultsから値を読み込む
        myColor = userDefaults.colorForKey(key: "myColor")
        selectColorNumber = UserDefaults.standard.integer(forKey: "myColorNumber")
        
        if selectColorNumber == 11 {
            self.overrideUserInterfaceStyle = .dark
        } else {
            self.overrideUserInterfaceStyle = .light
        }

        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = myColor
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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
        
        // ShowViewControllerから渡された値をtodoListに格納
        if IsShowTransition {
            task = showTodoList.task
            status = showTodoList.status
            date = showTodoList.date
            dateString = showTodoList.dateString
            alertDate = showTodoList.alertDate
            alertValueIndex = showTodoList.alertValueIndex
            alertId = showTodoList.alertId
            place = showTodoList.place
            memo = showTodoList.memo
            // 通知の登録の有無を検出する処理
            alertReferenceAction()
        } else {
            date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: tapCalendarTime!)
        }
        
    }
        
    // キーボードが表示される際の処理（高さ調整）
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                if  selectedTextCellIndex?.section == 0 {
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
    @objc func keyboardWillHide(notification: Notification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    // Realmに記入内容を登録する処理
    @IBAction func recordButton(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        dateString = formatter.string(from: date!)
        
        // 通知の取得（時間）
        alertGetAction()
        
        // 通知IDの取得（ユニークなIDを作る）
        if !IsShowTransition {
            alertId = NSUUID().uuidString
        }
        
        // 現在の時間を取得
        let now: Date? = Date()
                
        if task == "" {
            let alertController = UIAlertController(title: "registrationFailure".localized, message: "blankTask".localized, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "close".localized, style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else if alertDate != nil && !(now! <= alertDate!) {
            let alertController = UIAlertController(title: "registrationFailure".localized, message: "passedNotice".localized, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "close".localized, style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            if !IsShowTransition {
                do {
                    // Realmオブジェクトの生成
                    let realm = try Realm()
                    // 新規登録
                    let todo = Todo()
                    todo.task = task
                    todo.status = status
                    todo.date = date
                    todo.dateString = dateString
                    todo.alertDate = alertDate
                    todo.alertId = alertId
                    todo.alertValueIndex = alertValueIndex
                    todo.place = place
                    todo.memo = memo
                    try realm.write {
                        realm.add(todo)
                    }
                } catch {
                    print(error)
                }
            } else {
                do {
                    // Realmオブジェクトの生成
                    let realm = try Realm()
                    // 登録更新
                    let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
                    let todo = todos[selectedIndex!.row]
                    try realm.write {
                        todo.task = task
                        todo.status = status
                        todo.date = date
                        todo.dateString = dateString
                        todo.alertDate = alertDate
                        todo.alertValueIndex = alertValueIndex
                        todo.place = place
                        todo.memo = memo
                    }
                } catch {
                    print(error)
                }
            }
            // ローカル通知の設定が有れば登録処理
            if alertDate != nil {
                // ローカル通知の内容
                let content = UNMutableNotificationContent()
                content.sound = UNNotificationSound.default
                content.title = ""
                
                //本体の言語設定と地域コードのセットをハイフンで分割した配列にする。
                let preferredLanguages = Locale.preferredLanguages.first!.components(separatedBy: "-")
                //その配列の1つ目を言語コードとし判定する。
                if preferredLanguages[0] == "ja" {
                    content.body = "「\(task)」の\(alertString!)です！"
                } else {
                    if alertValueIndex == 1 {
                        content.body = "The scheduled time for the \"\(task)\"!"
                    } else {
                        let notificationAlertString = alertString.replacingOccurrences(of:"ago", with:"")
                        content.body = "\(notificationAlertString)before the \"\(task)\"!"
                    }
                }
                
                content.sound = UNNotificationSound.default
                // ローカル通知実行日時をセット
                let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate!)
                // ローカル通知リクエストを作成
                let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
                // IDを定義
                let request = UNNotificationRequest(identifier: self.alertId, content: content, trigger: trigger)
                // ローカル通知リクエストを登録
                UNUserNotificationCenter.current().add(request){ (error : Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
                
            } else if pendingNotification || deliveredNotification {
                // 編集の際に「通知有り」→「通知無し」に設定した場合、登録済みのローカル通知を削除する処理
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.alertId])
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
        
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "deleteTask".localized, message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "yes".localized, style: .default) { (alert) in
            do {
                // Realmオブジェクトの生成
                let realm = try! Realm()
                // 削除（タップした日付のデータを取得）
                let todos = realm.objects(Todo.self).filter("dateString == '\(self.tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
                let todo = todos[self.selectedIndex!.row]
                try realm.write {
                    realm.delete(todo)
                }
            } catch {
                print(error)
            }
            // 通知の削除
            if self.alertDate != nil {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.alertId])
            }
            // MainViewControllerへ画面遷移
            let layere_number = self.navigationController!.viewControllers.count
            self.navigationController?.popToViewController(self.navigationController!.viewControllers[layere_number-3], animated: true)
        }
        let noAction = UIAlertAction(title: "no".localized, style: .cancel)
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // 通知の取得（時間）
    func alertGetAction() {
        switch alertString {
        case "alertValues[0]".localized:
            alertValueIndex = 0
            alertDate = nil
        case "alertValues[1]".localized:
            alertValueIndex = 1
            alertDate = date!
        case "alertValues[2]".localized:
            alertValueIndex = 2
            alertDate = Date(timeInterval: -5*60, since: date!)
        case "alertValues[3]".localized:
            alertValueIndex = 3
            alertDate = Date(timeInterval: -10*60, since: date!)
        case "alertValues[4]".localized:
            alertValueIndex = 4
            alertDate = Date(timeInterval: -15*60, since: date!)
        case "alertValues[5]".localized:
            alertValueIndex = 5
            alertDate = Date(timeInterval: -20*60, since: date!)
        case "alertValues[6]".localized:
            alertValueIndex = 6
            alertDate = Date(timeInterval: -30*60, since: date!)
        case "alertValues[7]".localized:
            alertValueIndex = 7
            alertDate = Date(timeInterval: -1*60*60, since: date!)
        case "alertValues[8]".localized:
            alertValueIndex = 8
            alertDate = Date(timeInterval: -2*60*60, since: date!)
        case "alertValues[9]".localized:
            alertValueIndex = 9
            alertDate = Date(timeInterval: -3*60*60, since: date!)
        case "alertValues[10]".localized:
            alertValueIndex = 10
            alertDate = Date(timeInterval: -1*60*60*24, since: date!)
        case "alertValues[11]".localized:
            alertValueIndex = 11
            alertDate = Date(timeInterval: -2*60*60*24, since: date!)
        default:
            alertValueIndex = 12
            alertDate = Date(timeInterval: -3*60*60*24, since: date!)
        }
    }
    
    // 通知の登録の有無を検出する処理
    func alertReferenceAction() {
        let center = UNUserNotificationCenter.current()
        // 実行待ちの通知にalertIdの有無を判別
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                if request.identifier == self.alertId {
                    print(request.identifier)
                    self.pendingNotification.toggle()
                }
            }
        }
        // 実行済みの通知にalertIdの有無を判別
        center.getDeliveredNotifications { (notifications: [UNNotification]) in
            for notification in notifications {
                if notification.request.identifier == self.alertId {
                    print(notification.request.identifier)
                    self.deliveredNotification.toggle()
                }
            }
        }
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
            if task != "" {
                cell.textField.text = task
            }
            cell.textCustomCellDone = { [weak self] in
                self?.selectedTextCellIndex = indexPath
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
                cell.statusLabel.text = "inComplete".localized
                // 「未完了」セルのチェックマーク状態をセット
                if !status {
                    // チェックあり
                    cell.accessoryType = StatusCustomCell.AccessoryType.checkmark
                } else {
                    // チェックなし
                    cell.accessoryType = StatusCustomCell.AccessoryType.none
                }
                if selectColorNumber == 11 {
                    cell.tintColor = .white
                } else {
                    cell.tintColor = myColor
                }
                return cell
            default:
                cell.statusLabel.text = "complete".localized
                // 「完了済」セルのチェックマーク状態をセット
                if status {
                    // チェックあり
                    cell.accessoryType = StatusCustomCell.AccessoryType.checkmark
                } else {
                    // チェックなし
                    cell.accessoryType = StatusCustomCell.AccessoryType.none
                }
                if selectColorNumber == 11 {
                    cell.tintColor = .white
                } else {
                    cell.tintColor = myColor
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
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                formatter.calendar = Calendar(identifier: .gregorian)
                formatter.timeZone = TimeZone.current
                formatter.locale = Locale.current
                if date != nil {
                    cell.datePicker.date = date!
                    cell.datePickerLabel.text = formatter.string(from: date!)
                }
                // Cellのdelegateにselfを渡す
                cell.delegate = self
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlertCustomCell", for: indexPath) as? AlertCustomCell else {
                    return UITableViewCell()
                }
                cell.alertPicker.selectRow(alertValueIndex, inComponent: 0, animated: false)
                cell.alertPickerLabel.text = cell.alertValues[alertValueIndex] as? String
                alertString = cell.alertValues[alertValueIndex] as? String
                // Cellのdelegateにselfを渡す
                cell.delegate = self
                return cell
            }
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TextCustomCell", for: indexPath) as? TextCustomCell else {
                return UITableViewCell()
            }
            if place != "" {
                cell.textField.text = place
            }
            cell.textCustomCellDone = { [weak self] in
                self?.selectedTextCellIndex = indexPath
            }
            cell.textField.placeholder = .none
            // Cellのdelegateにselfを渡す
            cell.delegate = self
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCustomCell", for: indexPath) as? MemoCustomCell else {
                return UITableViewCell()
            }
            if memo != "" {
                cell.textView.text = memo
            }
            // Cellのdelegateにselfを渡す
            cell.delegate = self
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
                guard status else { return }
                status.toggle()
            } else if indexPath.row == 1 {
                guard !status else { return }
                status.toggle()
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

extension CreateViewController: TextCustomCellDelegate {
    func textFieldChangeAction() {
        if selectedTextCellIndex?.section == 0 {
            // タスクの取得（必須）
            guard let cell = tableView.cellForRow(at: selectedTextCellIndex!) as? TextCustomCell else { return }
            task = cell.textField.text!
        } else {
            // 場所の取得（任意）
            guard let cell = tableView.cellForRow(at: selectedTextCellIndex!) as? TextCustomCell else { return }
            place = cell.textField.text!
        }
    }
}

extension CreateViewController: DateCustomCellDelegate {
    func datePickerChangeAction() {
        // 時間の取得
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? DateCustomCell else { return }
        date = cell.datePicker.date
    }
}

extension CreateViewController: AlertCustomCellDelegate {
    func alertPickerChangeAction() {
        // 通知の取得
        guard let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 2)) as? AlertCustomCell else { return }
        alertString = cell.alertPickerLabel.text
        // 通知の取得（時間）
        alertGetAction()
    }
}

extension CreateViewController: MemoCustomCellDelegate {
    func textViewChangeAction() {
        // メモの取得
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? MemoCustomCell else { return }
        memo = cell.textView.text
    }
}

