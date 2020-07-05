//
//  ViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/06/24.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeButton: UIBarButtonItem!
    
    
    // 配列を設定
    var sections = [String]()
    var todoLists = [[String]]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.delegate = self
        calendar.dataSource = self
        tableView.delegate = self
        tableView.dataSource = self
        
        // 曜日部分を日本語表記に変更
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        
        sections = ["毎日にすること","毎週○曜日にすること","本日すること"]
        
        for _ in 0...2 {
            todoLists.append([])
        }
        
        todoLists[0] = ["食後に歯を磨く","帰宅後手を洗う"]
        todoLists[1] = ["相席食堂を観る"]
        todoLists[2] = ["読書をする","スーパーに行く","早く寝る","洗い物をする"]
        
        
        
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
        let year = tmpDate.component(.year, from: date)
        let month = tmpDate.component(.month, from: date)
        let day = tmpDate.component(.day, from: date)
        print("\(year)年\(month)月\(day)日")
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
//        return 1 //ここに入る数字によって点の数が変わる
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
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoLists[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        cell.textLabel?.text = todoLists[indexPath.section][indexPath.row]
        
        return cell
        
    }
    
    
    

}

