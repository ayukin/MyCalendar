//
//  CustomTextView.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/14.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class CustomTextView: UITextView{

    init(frame:CGRect) {
        super.init(frame: frame, textContainer: nil)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(){
        let tools = UIToolbar()
        tools.frame = CGRect(x: 0, y: 0, width: frame.width, height: 45)
        tools.backgroundColor = .gray
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeButtonTapped))
        tools.items = [spacer, closeButton]
        self.inputAccessoryView = tools
    }

    @objc func closeButtonTapped(){
        self.endEditing(true)
        self.resignFirstResponder()
    }
}

