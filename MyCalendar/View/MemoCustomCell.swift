//
//  MemoCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/11.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class MemoCustomCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var textView: CustomTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
        
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
        
}
