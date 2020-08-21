//
//  DateCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/10.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

//delegateはweak参照したいため、classを継承する
protocol  DateCustomCellDelegate: class {
    func datePickerChangeAction()
}

class DateCustomCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: DateCustomCellDelegate?
    
    var isPickerDisplay: Bool = false {
        didSet {
            datePicker.isHidden = !isPickerDisplay
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.text = "date".localized
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        formatter.timeStyle = .short
//        formatter.dateStyle = .short
//        formatter.locale = Locale(identifier: "ja_JP")
        datePickerLabel.text = formatter.string(from: Date())
        
        datePicker.locale = Locale(identifier: "ja_JP")
        datePicker.addTarget(self, action: #selector(pickerValueChanged(picker:)), for: .valueChanged)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func pickerValueChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        formatter.timeStyle = .short
//        formatter.dateStyle = .short
//        formatter.locale = Locale(identifier: "ja_JP")
        datePickerLabel.text = formatter.string(from: picker.date)
        delegate?.datePickerChangeAction()
    }
    
}
