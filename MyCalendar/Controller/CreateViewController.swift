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
    
    // TimeCustomCellの表示に関する定義
    var timeCustomCell: Bool = false
    
    // ステータスの「未完了」「完了済」を表すフラグ
    var IsStatusDone: Bool = false
    
    // タスクのセルのTextFieldのタップイベントを検出するフラグ
    var IstaskCellDone: Bool = false
    
    // 「タスク」未記入時に表示アラートを定義
    var alertController: UIAlertController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.register(UINib(nibName: "StatusCustomCell", bundle: nil), forCellReuseIdentifier: "StatusCustomCell")
        tableView.register(UINib(nibName: "DateCustomCell", bundle: nil), forCellReuseIdentifier: "DateCustomCell")
        tableView.register(UINib(nibName: "NoticeCustomCell", bundle: nil), forCellReuseIdentifier: "NoticeCustomCell")
        tableView.register(UINib(nibName: "MemoCustomCell", bundle: nil), forCellReuseIdentifier: "MemoCustomCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
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
//        let dateIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
//        let dateCell = dateIndex?.contentView.viewWithTag(2) as? UIDatePicker
//        let date = dateCell?.date
        // 通知の取得（任意）
//        let alertIndex = tableView.cellForRow(at: IndexPath(row: 2, section: 2))
//        let alertCell = alertIndex?.contentView.viewWithTag(2) as? UIDatePicker
//        let alert = alertCell?.date
        // 場所の取得（任意）
//        let placeIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 3))
//        let placeCell = placeIndex?.contentView.viewWithTag(1) as? UITextField
//        let place = placeCell?.text
        // メモの取得（任意）
//        let memoIndex = tableView.cellForRow(at: IndexPath(row: 0, section: 4))
//        let memoCell = memoIndex?.contentView.viewWithTag(3) as? UITextView
//        let memo = memoCell?.text

        if task == "" {
            alertAcrion(title: "登録失敗", message: "タスクを記入してください！")
        } else {
            print(task!)
        }
        
        
        
        
//        alertAcrion(title: "登録失敗", message: "タスクを記入してください！")
        
        
        
        
        
        
        
        
//        print("-----------------------")
//        print(task!)
//        print("-----------------------")
//        print(IsStatusDone)
//        print("-----------------------")
//        print(date!)
//        print("-----------------------")
//        print(alert!)
//        print("-----------------------")
//        print(place!)
//        print("-----------------------")
//        print(memo!)
//        print("-----------------------")


        
        
//        do {
//             Realmオブジェクトの生成
//            let realm = try Realm()
//
//             登録内容
//            let todo = Todo()
//            
//            if task == "" {
//                alertAcrion(title: "登録失敗", message: "タスクを記入してください！")
//            } else {
//                todo.task = task! // 済
//            }
//
//            todo.status = IsStatusDone // 済
//            todo.date = date! // 済
//            todo.alert = alert! // 済
//            todo.place = place! // 済
//            todo.memo = memo! // 済
//
//            try! realm.write {
//                realm.add(todo)
//            }
//
//        } catch {
//            print(error)
//        }

        
    }
    
    // 「タスク」未記入時に表示アラートに関する処理
    func alertAcrion(title: String, message: String) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
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
            if !timeCustomCell {
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
                return UITableViewCell()
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
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCustomCell", for: indexPath) as? NoticeCustomCell else {
                    return UITableViewCell()
                }
                // Cellのdelegateにselfを渡す
                cell.delegate = self
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateCustomCell", for: indexPath) as? DateCustomCell else {
                    return UITableViewCell()
                }
                return cell
            }
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
                return UITableViewCell()
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCustomCell", for: indexPath) as? MemoCustomCell else {
                return UITableViewCell()
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

        guard !timeCustomCell else { return }
        timeCustomCell = true
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(item: 2, section: 2)], with: .fade)
        }, completion: nil)
        
    }
    
    func switchOffAction() {

        guard timeCustomCell else { return }
        timeCustomCell = false
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [IndexPath(item: 2, section: 2)], with: .fade)
        }, completion: nil)

    }
    
}

extension CreateViewController: CustomCellDelegate{
    
    func keyboardShowAction() {
        IstaskCellDone = true
    }
    
    func keyboardHideAction() {
        IstaskCellDone = false

    }

}






