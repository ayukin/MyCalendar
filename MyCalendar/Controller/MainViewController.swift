//
//  MainViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/06/24.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import RealmSwift


class MainViewController: UIViewController {
        
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel!
    
        
    // ToDoを格納した配列
    var todolist = [Todo]()
    
    var datesWithEvents: Set<String> = []
    var datesWithStatus: Set<Bool> = []
    var checkWithStatus: Set<Bool> = [true]
    
    var tapCalendarDate: String!
    var tapCalendarTime: Date? = Date()
    var selectedStatusIndex: IndexPath?
    var selectedIndex: IndexPath?
    
    var alertId: String!
    var alertDate: Date? = Date()
    var selectColorNumber: Int!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaultsのインスタンス
        let userDefaults = UserDefaults.standard
        // UserDefaultsから値を読み込む
        let myColor = userDefaults.colorForKey(key: "myColor")
        if myColor == nil {
            // Keyを指定して保存
            userDefaults.setColor(color: .systemTeal, forKey: "myColor")
            UserDefaults.standard.set(0, forKey: "myColorNumber")
        }
        
        
        // 曜日部分を日本語表記に変更
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        tableView.register(UINib(nibName: "ListCustomCell", bundle: nil), forCellReuseIdentifier: "ListCustomCell")
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // テーマカラー変更の処理
        changeColorAction()
        
        // 画面立ち上げ時に今日のデータをRealmから取得し、TableViewに表示
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        if tapCalendarDate == nil {
            tapCalendarDate = formatter.string(from: Date())
        }
        dateLabel.text = tapCalendarDate
        
        // タップしたカレンダーの日付に紐付いたデータをRealmから取得
        tapCalendarDateGetAction()
        // tableViewを更新
        tableView.reloadData()
        // calendarを更新
        calendar.reloadData()
        
    }
    
    // calendarの表示形式変更
    @IBAction func changeButtonAction(_ sender: Any) {
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
            changeButton.title = "月表示"
        } else if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            changeButton.title = "週表示"
        }
                
    }
    
    // CreateViewControllerへ画面遷移
    @IBAction func createButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "create", sender: nil)
    }
        
    // 画面遷移時に値を渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "create" {
            // CreateViewControllerに値を渡す
            let createVC = segue.destination as! CreateViewController
            createVC.tapCalendarTime = self.tapCalendarTime
            
        } else if segue.identifier == "show" {
            // ShowViewControllerに値を渡す
            let showVC = segue.destination as! ShowViewController
            showVC.tapCalendarDate = self.tapCalendarDate
            showVC.selectedIndex = self.selectedIndex
            
        } else if segue.identifier == "info" {
            // InfoViewControllerに値を渡す
            let infoVC = self.storyboard?.instantiateViewController(withIdentifier: "infoVC") as! InfoViewController
            let nav = UINavigationController(rootViewController: infoVC)
            self.present(nav, animated: true, completion: nil)

        }
        
    }
    
    // InfoViewControllerへ画面遷移
    @IBAction func infoButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "info", sender: self)
    }
    
    // タップしたカレンダーの日付に紐付いたデータをRealmから取得
    func tapCalendarDateGetAction() {
        // Realmオブジェクトの生成
        let realm = try! Realm()
        // 参照（タップした日付のデータを取得）
        let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
        if todos.count > 0 {
            for i in 0..<todos.count {
                if i == 0 {
                    todolist = [todos[i]]
                } else {
                    todolist.append(contentsOf: [todos[i]])
                }
            }
        } else {
            todolist = []
        }
    }
    
}

// UIImageのリサイズ
extension UIImage {
    func resize(size _size: CGSize) -> UIImage? {
        let widthRatio = _size.width / size.width
        let heightRatio = _size.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        
        let resizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0) // 変更
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}


extension MainViewController: ColorViewControllerDelegate {
    // テーマカラー変更の処理
    func changeColorAction() {
        
        // UserDefaultsのインスタンス
        let userDefaults = UserDefaults.standard
        // UserDefaultsから値を読み込む
        let myColor = userDefaults.colorForKey(key: "myColor")
        selectColorNumber = userDefaults.integer(forKey: "myColorNumber")

        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = myColor
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white

        dateLabel.backgroundColor = myColor
        dateLabel.textColor = .white
    }
    
}


// ３つに分けなかった理由（FSCalendarDataSource、FSCalendarDelegateAppearanceに記載するコードがなかったため）
extension MainViewController: FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    // 祝日判定を行い結果を返すメソッド（True:祝日）
    func judeHoliday(_ date: Date) -> Bool {
        
        // 祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        // CalcuLateCalendarLogic() 祝日判定のインスタンスを生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
//    // まとめ方確認（未）
//    // date型 -> 年月日をIntで取得
//    func getDay(_ date: Date) -> (Int, Int, Int) {
//        // 判定用のカレンダークラスのインスタンス
//        let tmpCalendar = Calendar(identifier: .gregorian)
//        // 判定を行う日にちの年、月、日を取得
//        let year = tmpCalendar.component(.year, from: date)
//        let month = tmpCalendar.component(.month, from: date)
//        let day = tmpCalendar.component(.day, from: date)
//
//        return (year, month, day)
//
//    }
    
    // 曜日判定（日曜:1 〜 土曜:7）
    func getWeekIdx(_ date: Date) -> Int {
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
//    func getToday(_ date: Date) -> Int {
//        let tmpCalendar = Calendar(identifier: .gregorian)
//        return tmpCalendar.component(.day, from: date)
//    }

    
    
        
    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        // 祝日判定をする（祝日は赤色で表示する）
        if self.judeHoliday(date) {
            return .red
        }
        // 土日の判定を行う（土曜は青色、日曜は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return .red
        } else if weekday == 7 {
            return .blue
        }
        
//        let today = self.getToday(date)
//        if today == 1 {
//            return .white
//        }
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        tapCalendarDate = formatter.string(from: date)
        
        dateLabel.text = tapCalendarDate
        tapCalendarTime = date
        
        // タップしたカレンダーの日付に紐付いたデータをRealmから取得
        tapCalendarDateGetAction()
        // tableViewを更新
        tableView.reloadData()

    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
        
        
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let calendarDay = formatter.string(from: date)

        do {
            // Realmオブジェクトの生成
            let realm = try Realm()
            // 参照（全データを取得）
            let todos = realm.objects(Todo.self)
            
            if todos.count > 0 {
                for i in 0..<todos.count {
                    if i == 0 {
                        datesWithEvents = [todos[i].dateString]
                    } else {
                        datesWithEvents.insert(todos[i].dateString)
                    }
                }
            } else {
                datesWithEvents = []
            }

        } catch {
            print(error)
        }

        for datesWithEvent in datesWithEvents {
            if datesWithEvent == calendarDay {
                return 1
            }
        }
        return 0
    }
    
    //画像をつける関数
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let calendarDay = formatter.string(from: date)
        
        let perfect = UIImage(named: "perfect")
        let Resize:CGSize = CGSize.init(width: 18, height: 30) // サイズ指定
        let perfectResize = perfect?.resize(size: Resize)
        
        do {
            // Realmオブジェクトの生成
            let realm = try Realm()
            // 参照（全データを取得）
            let todos = realm.objects(Todo.self).filter("dateString == '\(calendarDay)'")
            
            if todos.count > 0 {
                for i in 0..<todos.count {
                    if i == 0 {
                        datesWithStatus = [todos[i].status]
                    } else {
                        datesWithStatus.insert(todos[i].status)
                    }
                }
            } else {
                datesWithStatus = []
            }
            
        } catch {
            print(error)
        }
        
        if datesWithStatus == checkWithStatus {
            return perfectResize
        }
        
        return nil
    }
    
}


extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                
        if todolist.count == 0 {
            tableView.isHidden = true
            emptyView.isHidden = false
            emptyLabel.isHidden = false
            return 0
        } else {
            tableView.isHidden = false
            emptyView.isHidden = true
            emptyLabel.isHidden = true
            return todolist.count
        }
        
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCustomCell", for: indexPath) as? ListCustomCell else {
            return UITableViewCell()
        }
        
        if todolist.count == 0 {
            return cell
        } else {
            
            cell.mainTaskLabel.text = todolist[indexPath.row].task
                        
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let dateTime = formatter.string(from: todolist[indexPath.row].date)
            cell.mainDateLabel.text = dateTime
            
            if todolist[indexPath.row].status {
                let statusImage = UIImage(named: "complete\(String(describing: selectColorNumber!))")
                cell.mainStatusButton.setImage(statusImage, for: .normal)
                let atr = NSMutableAttributedString(string: cell.mainTaskLabel.text!)
                
                atr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atr.length))
                cell.mainTaskLabel.attributedText = atr
//                cell.mainTaskLabel.alpha = 0.3
//                cell.mainDateLabel.alpha = 0.3
            } else {
                let statusImage = UIImage(named: "Incomplete")
                cell.mainStatusButton.setImage(statusImage, for: .normal)
                let atr = NSMutableAttributedString(string: cell.mainTaskLabel.text!)
                
                atr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 0, range: NSMakeRange(0, atr.length))
                cell.mainTaskLabel.attributedText = atr
//                cell.mainTaskLabel.alpha = 1
//                cell.mainDateLabel.alpha = 1
            }
            
            cell.statusChange = { [weak self] in
                self?.selectedStatusIndex = indexPath
            }
            
            let dateImage = UIImage(named: "date")
            cell.mainDateImage.image = dateImage

            if todolist[indexPath.row].alertValueIndex != 0 {
                let alertImage = UIImage(named: "alert")
                cell.mainAlertImage.image = alertImage
            } else {
                let alertImage = UIImage(named: "Inalert")
                cell.mainAlertImage.image = alertImage
            }
            // Cellのdelegateにselfを渡す
            cell.delegate = self
            return cell
        }
        
    }
    
    // セルを削除したときの処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 削除処理かどうか
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let alertController = UIAlertController()
            let deleteAction = UIAlertAction(title: "削除する", style: .default) { (alert) in
                // todolistから削除
                self.todolist.remove(at: indexPath.row)
                // セルを削除
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
                        
                do {
                    // Realmオブジェクトの生成
                    let realm = try Realm()
                    // 削除
                    let todos = realm.objects(Todo.self).filter("dateString == '\(self.tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
                    let todo = todos[indexPath.row]
                    
                    self.alertId = todo.alertId
                    self.alertDate = todo.alertDate
                    
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
                // タップしたカレンダーの日付に紐付いたデータをRealmから取得
                self.tapCalendarDateGetAction()
                // TableViewを更新
                self.tableView.reloadData()
                // calendarを更新
                self.calendar.reloadData()
            }
            
            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)
             
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
                        
        }
        
    }
    
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // タップしたcellのindexPathを格納
        self.selectedIndex = indexPath
        
        self.performSegue(withIdentifier: "show", sender: todolist[indexPath.row])
    }
    
}


extension MainViewController: ListCustomCellDelegate {
    // Realmの「Status」の更新
    func statusChangeAction() {
        
        // Realmオブジェクトの生成
        let realm = try! Realm()

        let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'").sorted(byKeyPath: "date", ascending: true)
        let todo = todos[selectedStatusIndex!.row as Int]
        try! realm.write {
            if !todo.status {
                todo.status = true
                todolist[selectedStatusIndex!.row as Int].status = true
            } else {
                todo.status = false
                todolist[selectedStatusIndex!.row as Int].status = false
            }
        }
        // tableViewを更新
        tableView.reloadData()
        // calendarを更新
        calendar.reloadData()
    }
    
}

