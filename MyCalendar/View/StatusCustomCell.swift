//
//  StatusCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/11.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class StatusCustomCell: UITableViewCell {
    
    @IBOutlet weak var statusLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

