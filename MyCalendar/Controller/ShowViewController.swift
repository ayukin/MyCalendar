//
//  ShowViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/24.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit
import RealmSwift

class ShowViewController: UIViewController {
    
    @IBOutlet weak var showTaskLabel: UILabel!
    @IBOutlet weak var showStatusLabel: UILabel!
    @IBOutlet weak var showDateLabel: UILabel!
    @IBOutlet weak var showAlertLabel: UILabel!
    @IBOutlet weak var showPlaceTextField: UITextField!
    @IBOutlet weak var showMemoTextView: UITextView!
    
    var tapCalendarDate: String!
    var selectedIndex: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = .systemTeal
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        showMemoTextView.textContainerInset = UIEdgeInsets.zero
        showMemoTextView.textContainer.lineFragmentPadding = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        do {
            // Realmオブジェクトの生成
            let realm = try Realm()
            // 参照（タップした日付のデータを取得）
            let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'")
            
            showTaskLabel.text = todos[selectedIndex!.row as Int].task
            
            if todos[selectedIndex!.row as Int].status {
                showStatusLabel.text = "完了済"
            } else {
                showStatusLabel.text = "未完了"
            }
            
            showDateLabel.text = formatter.string(from: todos[selectedIndex!.row as Int].date)
            
            if todos[selectedIndex!.row as Int].alertDate == nil {
                showAlertLabel.text = "通知なし"
            } else {
                showAlertLabel.text = formatter.string(from: todos[selectedIndex!.row as Int].alertDate!)
            }
            
            showPlaceTextField.text = todos[selectedIndex!.row as Int].place
            showMemoTextView.text = todos[selectedIndex!.row as Int].memo
            
        } catch {
            print(error)
        }
        
    }
    
    // 編集ボタンの処理
    @IBAction func editButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
    // CreateViewControllerに値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit" {
            let createVC = segue.destination as! CreateViewController
            createVC.tapCalendarDate = self.tapCalendarDate
            createVC.selectedIndex = self.selectedIndex
        }
    }
    
}
