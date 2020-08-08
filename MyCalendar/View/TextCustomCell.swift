//
//  TextCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/10.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

//delegateはweak参照したいため、classを継承する
protocol  TextCustomCellDelegate: class {
    func keyboardShowAction()
    func keyboardHideAction()
}

class TextCustomCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: TextCustomCellDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 準備のための再利用処理
    override func prepareForReuse() {
        super.prepareForReuse()
//        textField.text = ""
        
    }
    
    // 入力開始時の処理
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.keyboardShowAction()
    }

    // リターンキーを押したときキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.keyboardHideAction()
        return true
    }
    
    // 入力終了時の処理（フォーカスがはずれる）
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.keyboardHideAction()
    }
    
}
