//
//  DateCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/10.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class DateCustomCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var isPickerDisplay: Bool = false {
        didSet {
            datePicker.isHidden = !isPickerDisplay
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        label.text = formatter.string(from: Date())
        
        datePicker.addTarget(self, action: #selector(pickerValueChanged(picker:)), for: .valueChanged)
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
