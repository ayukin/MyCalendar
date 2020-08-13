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
    func textFieldChangeAction()
}

class TextCustomCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    
    var textEditCfangeString: String!
    
    var textCustomCellDone: (()->Void)?
    
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
        textField.text = ""
        
    }
    
}

extension TextCustomCell: UITextFieldDelegate {
    // 入力開始時の処理
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textCustomCellDone?()
    }
    // textFieldの内容をリアルタイムで反映させる
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textCustomCellDone?()
        delegate?.textFieldChangeAction()
    }
    // リターンキーを押したときキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // 入力終了時の処理（フォーカスがはずれる）
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
}
