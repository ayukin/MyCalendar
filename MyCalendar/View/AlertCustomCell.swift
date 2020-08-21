//
//  AlertCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/30.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

//delegateはweak参照したいため、classを継承する
protocol  AlertCustomCellDelegate: class {
    func alertPickerChangeAction()
}

class AlertCustomCell: UITableViewCell {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertPickerLabel: UILabel!
    @IBOutlet weak var alertPicker: UIPickerView!
    
    let alertValues: NSArray = ["alertValues[0]".localized, "alertValues[1]".localized, "alertValues[2]".localized, "alertValues[3]".localized, "alertValues[4]".localized, "alertValues[5]".localized, "alertValues[6]".localized, "alertValues[7]".localized, "alertValues[8]".localized, "alertValues[9]".localized, "alertValues[10]".localized, "alertValues[11]".localized, "alertValues[12]".localized]
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: AlertCustomCellDelegate?

    var isPickerDisplay: Bool = false {
        didSet {
            alertPicker.isHidden = !isPickerDisplay
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        alertLabel.text = "notice".localized
        alertPicker.delegate = self
        alertPicker.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
        
}

extension AlertCustomCell: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return alertValues.count
    }
    
    // Pickerに表示する値を返すデリゲートメソッド
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return alertValues[row] as? String
    }
    
    // Pickerが選択された際に呼ばれるデリゲートメソッド
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        alertPickerLabel.text = alertValues[row] as? String
        delegate?.alertPickerChangeAction()
    }

}
