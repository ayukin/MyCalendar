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
        
    // ToDoを格納した配列
    var todolist = [Todo]()
    
    var tapCalendarDate: String!
    var selectedIndex: IndexPath?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        realmMigration()
//        let realm = try! Realm()
                        
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
    
//    override func viewWillAppear(_ animated: Bool) {
//        // 画面立ち上げ時に今日のデータをRealmから取得し、TableViewに表示
//        // CreateViewControllerにて登録完了後、TableViewをリロード
//    }
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    @IBAction func changeButtonAction(_ sender: Any) {
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
            changeButton.title = "月表示"
        } else if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            changeButton.title = "週表示"
        }
        
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
        return nil
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        tapCalendarDate = formatter.string(from: date)
        
        dateLabel.text = tapCalendarDate
        
        // Realmオブジェクトの生成
        let realm = try! Realm()

        // 参照（タップした日付のデータを取得）
        let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'")
        
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
        
        // tableViewを更新
        tableView.reloadData()
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeight.constant = bounds.height
        self.view.layoutIfNeeded()
    }
        
        
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
//        return 1
//    }
        
        
    // 点マークや画像をつけたい日にはそれぞれtrueやimageをリターンし、それ以外の日にちにはnilをリターンする条件文を付属すれば良いです。
        
    // 点マークをつける関数
//    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
//        return shouldShowEventDot
//    }
        
    //画像をつける関数
//    private func calendar(_ calendar: FSCalendar!, imageFor date: NSDate!) -> UIImage! {
//        return anyImage
//    }
    
}


extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if todolist.count == 0 {
            return 0
        } else {
            return todolist.count
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCustomCell", for: indexPath) as? ListCustomCell else {
            return UITableViewCell()
        }
        
        if todolist.count == 0 {
            return cell
        } else {
            
            cell.mainTaskLabel.text = todolist[indexPath.row].task
            
            let formatter = DateFormatter()
            formatter.dateFormat = "H時m分"
            let dateTime = formatter.string(from: todolist[indexPath.row].date)
            cell.mainDateLabel.text = dateTime
            
            if todolist[indexPath.row].status {
                let statusImage = UIImage(named: "complete")
                cell.mainStatusButton.setImage(statusImage, for: .normal)
            } else {
                let statusImage = UIImage(named: "Incomplete")
                cell.mainStatusButton.setImage(statusImage, for: .normal)
            }
            
            cell.statusChange = { [weak self] in
                self?.selectedIndex = indexPath
            }
            
            let dateImage = UIImage(named: "date")
            cell.mainDateImage.image = dateImage
            
            if todolist[indexPath.row].alert {
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
            
            // todolistから削除
            todolist.remove(at: indexPath.row)
            
            // セルを削除
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.fade)
            
            do {
                // Realmオブジェクトの生成
                let realm = try Realm()

                // 削除
                let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'")
                try realm.write {
                    realm.delete(todos[indexPath.row])
                }

            } catch {
                print(error)
            }
        }
            
    }
        
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
                
    }
    
}

extension MainViewController: ListCustomCellDelegate {
    
    // Realmの「Status」の更新
    func statusChangeAction() {

        // Realmオブジェクトの生成
        let realm = try! Realm()
        
//        print("-----------------------")
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//        print("-----------------------")

        let editTodo = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'")
        try! realm.write {
            if !editTodo[selectedIndex!.row as Int].status {
                editTodo[selectedIndex!.row as Int].status = true
                todolist[selectedIndex!.row as Int].status = true
            } else {
                editTodo[selectedIndex!.row as Int].status = false
                todolist[selectedIndex!.row as Int].status = false
            }

        }
        
        // tableViewを更新
        tableView.reloadData()

    }
    
}

