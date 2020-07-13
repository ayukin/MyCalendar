//
//  NoticeCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/11.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

// delegateはweak参照したいため、classを継承する
protocol  NoticeCustomCellDelegate: class {
    func switchOnAction()
    func switchOffAction()
}

class NoticeCustomCell: UITableViewCell {
    
    @IBOutlet weak var changeSwitch: UISwitch!
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: NoticeCustomCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        changeSwitch.isOn = false
                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        
        if sender.isOn {
            delegate?.switchOnAction()
        } else {
            delegate?.switchOffAction()
        }
        
    }
    
    
}
