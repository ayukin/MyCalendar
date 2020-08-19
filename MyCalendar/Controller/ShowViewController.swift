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
    @IBOutlet weak var showStatusImage: UIImageView!
    @IBOutlet weak var showStatusLabel: UILabel!
    @IBOutlet weak var showDateLabel: UILabel!
    @IBOutlet weak var showAlertLabel: UILabel!
    @IBOutlet weak var showPlaceLabel: UILabel!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var showMemoTextView: UITextView!
    
    // MainViewControllerから渡された値を格納する変数
    var tapCalendarDate: String!
    var selectedIndex: IndexPath?
    var showTodoList = Todo()
    
    var selectColorNumber: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaultsのインスタンス
        let userDefaults = UserDefaults.standard
        // UserDefaultsから値を読み込む
        let myColor = userDefaults.colorForKey(key: "myColor")
        selectColorNumber = userDefaults.integer(forKey: "myColorNumber")
        
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
        
        mapButton.layer.masksToBounds = true
        mapButton.layer.cornerRadius = 5
        
        showMemoTextView.textContainerInset = UIEdgeInsets.zero
        showMemoTextView.textContainer.lineFragmentPadding = 0
        showMemoTextView.isEditable = false
        showMemoTextView.isSelectable = false
        
        showStatusImage.image = UIImage(named: "complete\(String(describing: selectColorNumber!))")
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
        showTaskLabel.text = showTodoList.task
        showTaskLabel.sizeToFit()
        
        if showTodoList.status {
            showStatusLabel.text = "完了済"
        } else {
            showStatusLabel.text = "未完了"
        }
        
        showDateLabel.text = formatter.string(from: showTodoList.date!)
        
        if showTodoList.alertDate == nil {
            showAlertLabel.text = "通知なし"
        } else {
            showAlertLabel.text = formatter.string(from: showTodoList.alertDate!)
        }
        
        if showTodoList.place == "" {
            showPlaceLabel.text = "記入なし"
            showPlaceLabel.alpha = 0.3
        } else {
            showPlaceLabel.text = showTodoList.place
        }
        
        if showTodoList.memo == "" {
            showMemoTextView.text = "記入なし"
            showMemoTextView.alpha = 0.3
        } else {
            showMemoTextView.text = showTodoList.memo
        }
        
        // 場所の登録がなければ「Map表示」ボタンを非表示
        if showPlaceLabel.text == "記入なし" {
            mapButton.isHidden = true
        } else {
            mapButton.isHidden = false
        }
        
    }
    
    // Map表示ボタンの処理
    @IBAction func mapButtonAction(_ sender: Any) {
        
        let urlString: String!
        // googleマップが開けるかを確認し、それによってurlスキームを切り替える
        if UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!) {
            urlString = "comgooglemaps://?q=\(String(describing: showPlaceLabel.text!))&center=37.759748,-122.427135".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            }
        else {
            urlString = "http://maps.apple.com/?q=\(String(describing: showPlaceLabel.text!))&center=37.759748,-122.427135".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
            }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
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
            createVC.showTodoList = self.showTodoList
        }
    }
    
}

