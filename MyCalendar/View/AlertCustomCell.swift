//
//  AlertCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/30.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class AlertCustomCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertPicker: UIPickerView!
    
    let alertValues: NSArray = ["なし","予定時間","5分前","10分前","15分前","20分前","30分前","1時間前","2時間前","3時間前","1日前","2日前","3日前"]
    
    var isPickerDisplay: Bool = false {
        didSet {
            alertPicker.isHidden = !isPickerDisplay
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        alertPicker.delegate = self
        alertPicker.dataSource = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
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
        alertLabel.text = alertValues[row] as? String
    }
    
}
