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
    
    // Sectionで使用する配列を定義する.
    let sections: Array = ["タスク","ステータス","日時","場所","メモ"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TaskCustomCell", bundle: nil), forCellReuseIdentifier: "TaskCustomCell")
        tableView.register(UINib(nibName: "DateCustomCell", bundle: nil), forCellReuseIdentifier: "DateCustomCell")
        
    }
    
}


extension CreateViewController: UITableViewDataSource {
    
//    static var taskCustomCell: TaskCustomCell?
//    static var dateCustomCell: DateCustomCell?
    
    // セクションの数を指定
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // セクションのタイトルを返す
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCustomCell", for: indexPath) as? TaskCustomCell else {
                return UITableViewCell()
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DateCustomCell", for: indexPath) as? DateCustomCell else {
                return UITableViewCell()
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCustomCell", for: indexPath) as? TaskCustomCell else {
                return UITableViewCell()
            }
            return cell
        }
        
//        switch indexPath.section {
//        case 0:
//            let cell: TaskCustomCell = (tableView.dequeueReusableCell(withIdentifier: "TaskCustomCell", for: indexPath) as? TaskCustomCell)!
//            CreateViewController.taskCustomCell = cell
//            return cell
//        case 1:
//            let cell: DateCustomCell = (tableView.dequeueReusableCell(withIdentifier: "DateCustomCell", for: indexPath) as? DateCustomCell)!
//            CreateViewController.dateCustomCell = cell
//            return cell
//        default:
//            let cell: TaskCustomCell = (tableView.dequeueReusableCell(withIdentifier: "TaskCustomCell", for: indexPath) as? TaskCustomCell)!
//            CreateViewController.taskCustomCell = cell
//            return cell
//        }

    }
    
}

extension CreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 2, let cell = tableView.cellForRow(at: indexPath) as? DateCustomCell else { return }

        cell.isPickerDisplay.toggle()
        tableView.performBatchUpdates(nil, completion: nil)

    }
    
    
}


