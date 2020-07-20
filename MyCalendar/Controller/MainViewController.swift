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

class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    
    var taskList: [String]!
    var detaList: [String]!
    var statusList: [Bool]!
    var tapCalendarDateCount: Int!
    
    var tapCalendarDate: String!
    
    var selectedIndex: IndexPath?
    
    var dateStringArray: [Date]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
                
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
    
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
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
    
    // date型 -> 年月日をIntで取得
    func getDay(_ date: Date) -> (Int, Int, Int) {
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        return (year, month, day)

    }
    
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
        let tmpDate = Calendar(identifier: .gregorian)
        let year = tmpDate.component(.year, from: date) // Int型
        let month = tmpDate.component(.month, from: date) // Int型
        let day = tmpDate.component(.day, from: date) // Int型
        
        dateLabel.text = "\(year)年\(month)月\(day)日"
        
        // カレンダータップ時の日付取得（String型）
        if month >= 10 && day < 10 {
            tapCalendarDate = "\(year)年\(month)月0\(day)日"
        } else if month < 10 && day >= 10 {
            tapCalendarDate = "\(year)年0\(month)月\(day)日"
        } else if  month < 10 && day < 10 {
            tapCalendarDate = "\(year)年0\(month)月0\(day)日"
        } else {
            tapCalendarDate = "\(year)年\(month)月\(day)日"
        }
        
        // Realmオブジェクトの生成
        let realm = try! Realm()

        // 参照（タップした日付のデータを取得）
        let todos = realm.objects(Todo.self).filter("dateString == '\(tapCalendarDate!)'")
        
        tapCalendarDateCount = todos.count
        
        for i in 0..<tapCalendarDateCount {
            if i == 0 {
                taskList = [todos[i].task]
                detaList = [todos[i].dateString]
                statusList = [todos[i].status]
            } else {
                taskList.append(contentsOf: [todos[i].task])
                detaList.append(contentsOf: [todos[i].dateString])
                statusList.append(contentsOf: [todos[i].status])
            }
            
        }
        
        // tableViewを更新
        tableView.reloadData()
        
        
    }
    
    @IBAction func changeButtonAction(_ sender: Any) {
        if calendar.scope == .month {
            calendar.setScope(.week, animated: true)
            changeButton.title = "月表示"
        } else if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            changeButton.title = "週表示"
        }
        
       
        
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
            calendarHeight.constant = bounds.height
            self.view.layoutIfNeeded()
    }
    
    
//    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int{
//        if  {
//        return 1
//    }
    
    
    // 点マークや画像をつけたい日にはそれぞれtrueやimageをリターンし、それ以外の日にちにはnilをリターンする条件文を付属すれば良いです。
    
    //点マークをつける関数
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
        if tapCalendarDateCount == nil {
            return 0
        } else {
            return tapCalendarDateCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCustomCell", for: indexPath) as? ListCustomCell else {
            return UITableViewCell()
        }
        
        if tapCalendarDateCount == nil {
            return cell
        } else {
            cell.mainTaskLabel.text = taskList[indexPath.row]
            cell.mainDateLabel.text = detaList[indexPath.row]
            if statusList[indexPath.row] {
                let picture = UIImage(named: "complete")
                cell.mainStatusButton.setImage(picture, for: .normal)
            } else {
                let picture = UIImage(named: "Incomplete")
                cell.mainStatusButton.setImage(picture, for: .normal)
            }
            cell.statusChange = { [weak self] in
                self?.selectedIndex = indexPath
            }
            
            // Cellのdelegateにselfを渡す
            cell.delegate = self
            return cell

        }
        
    }
    
        
}

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
                
    }
    
}

// Cellのdelegateメソッドで削除処理を実装
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
                statusList[selectedIndex!.row as Int] = true
            } else {
                editTodo[selectedIndex!.row as Int].status = false
                statusList[selectedIndex!.row as Int] = false
            }
            
            // tableViewを更新
            tableView.reloadData()

        }


    }
    
}

