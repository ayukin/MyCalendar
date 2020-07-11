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
        
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        tableView.register(UINib(nibName: "Status1CustomCell", bundle: nil), forCellReuseIdentifier: "Status1CustomCell")
        tableView.register(UINib(nibName: "Status2CustomCell", bundle: nil), forCellReuseIdentifier: "Status2CustomCell")
        tableView.register(UINib(nibName: "DateCustomCell", bundle: nil), forCellReuseIdentifier: "DateCustomCell")
        tableView.register(UINib(nibName: "NoticeCustomCell", bundle: nil), forCellReuseIdentifier: "NoticeCustomCell")
        tableView.register(UINib(nibName: "TimeCustomCell", bundle: nil), forCellReuseIdentifier: "TimeCustomCell")
        
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
    
    // テーブルに表示する配列の総数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return 2
        } else if section == 2 {
            return 3
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
                return UITableViewCell()
            }
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Status1CustomCell", for: indexPath) as? Status1CustomCell else {
                    return UITableViewCell()
                }
                return cell
            default:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "Status2CustomCell", for: indexPath) as? Status2CustomCell else {
                    return UITableViewCell()
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else {
                return UITableViewCell()
            }
            return cell
        }
        
    }
    
}

extension CreateViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.section == 2, indexPath.row == 0, let cell = tableView.cellForRow(at: indexPath) as? DateCustomCell else { return }

        cell.isPickerDisplay.toggle()
        tableView.performBatchUpdates(nil, completion: nil)

    }
    
    
}


