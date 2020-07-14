//
//  CreateViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/10.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Sectionで使用する配列を定義
    let sections: Array = ["タスク","ステータス","日時","場所","メモ"]
    
    // TimeCustomCellの表示に関する定義
    var timeCustomCell: Bool = false
    
    // ステータスの「未完了」「完了済」を表すフラグ
    var InCompleteStatusDone: Bool = true
    var CompleteStatusDone: Bool = false
    
    // タスクのセルのTextFieldのタップイベントを検出するフラグ
    var taskCellDone: Bool = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.register(UINib(nibName: "StatusCustomCell", bundle: nil), forCellReuseIdentifier: "StatusCustomCell")
        tableView.register(UINib(nibName: "DateCustomCell", bundle: nil), forCellReuseIdentifier: "DateCustomCell")
        tableView.register(UINib(nibName: "NoticeCustomCell", bundle: nil), forCellReuseIdentifier: "NoticeCustomCell")
        tableView.register(UINib(nibName: "TimeCustomCell", bundle: nil), forCellReuseIdentifier: "TimeCustomCell")
        tableView.register(UINib(nibName: "MemoCustomCell", bundle: nil), forCellReuseIdentifier: "MemoCustomCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // キーボードが表示される際の処理（高さ調整）
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                print("4 \(taskCellDone)")
                if taskCellDone {
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
                if InCompleteStatusDone {
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
                if CompleteStatusDone {
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
                return cell
            case 1:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCustomCell", for: indexPath) as? NoticeCustomCell else {
                    return UITableViewCell()
                }
                // Cellのdelegateにselfを渡す
                cell.delegate = self
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "TimeCustomCell", for: indexPath) as? TimeCustomCell else {
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
                guard InCompleteStatusDone == false, CompleteStatusDone == true else { return }
                InCompleteStatusDone = true
                CompleteStatusDone = false
            } else if indexPath.row == 1 {
                guard InCompleteStatusDone == true, CompleteStatusDone == false else { return }
                InCompleteStatusDone = false
                CompleteStatusDone = true
            }
            // セルの状態を変更
            tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .fade)
            tableView.reloadRows(at: [IndexPath(row: 1, section: 1)], with: .fade)
        }
        
        // datePickerの表示に関しての処理
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                guard let cell = tableView.cellForRow(at: indexPath) as? DateCustomCell else { return }
                cell.isPickerDisplay.toggle()
                tableView.performBatchUpdates(nil, completion: nil)
            } else if indexPath.row == 2 {
                guard let cell = tableView.cellForRow(at: indexPath) as? TimeCustomCell else { return }
                cell.isPickerDisplay.toggle()
                tableView.performBatchUpdates(nil, completion: nil)
            }
        }
    }
    
}

// Cellのdelegateメソッドで削除処理を実装
extension CreateViewController: NoticeCustomCellDelegate {
    
    func switchOnAction() {

        guard timeCustomCell == false else { return }
        timeCustomCell = true
        tableView.performBatchUpdates({
            tableView.insertRows(at: [IndexPath(item: 2, section: 2)], with: .fade)
        }, completion: nil)
        
    }
    
    func switchOffAction() {

        guard timeCustomCell == true else { return }
        timeCustomCell = false
        tableView.performBatchUpdates({
            tableView.deleteRows(at: [IndexPath(item: 2, section: 2)], with: .fade)
        }, completion: nil)

    }
    
}

extension CreateViewController: CustomCellDelegate{
    
    func keyboardShowAction() {
        taskCellDone = true
    }
    
    func keyboardHideAction() {
        guard taskCellDone == true else { return }
        taskCellDone = false

    }

}






