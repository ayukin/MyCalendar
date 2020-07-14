//
//  TimeCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/11.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class TimeCustomCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    var isPickerDisplay: Bool = false {
        didSet {
            timePicker.isHidden = !isPickerDisplay
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        label.text = formatter.string(from: Date())
        
        timePicker.addTarget(self, action: #selector(pickerValueChanged(picker:)), for: .valueChanged)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func pickerValueChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        label.text = formatter.string(from: picker.date)
    }
    
}
