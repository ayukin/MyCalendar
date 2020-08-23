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
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        datePickerLabel.text = formatter.string(from: Date())
        
        datePicker.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePicker.locale = Locale.current
        datePicker.addTarget(self, action: #selector(pickerValueChanged(picker:)), for: .valueChanged)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc private func pickerValueChanged(picker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        datePickerLabel.text = formatter.string(from: picker.date)
        
        delegate?.datePickerChangeAction()
    }
    
}
