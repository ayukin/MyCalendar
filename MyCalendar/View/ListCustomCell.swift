//
//  ListCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/19.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

// delegateはweak参照したいため、classを継承する
protocol  ListCustomCellDelegate: class {
    func statusChangeAction()
    
}

class ListCustomCell: UITableViewCell {
    
    @IBOutlet weak var mainTaskLabel: UILabel!
    @IBOutlet weak var mainDateLabel: UILabel!
    
    @IBOutlet weak var mainDateImage: UIImageView!
    @IBOutlet weak var mainAlertImage: UIImageView!
    
    @IBOutlet weak var mainStatusButton: UIButton!
    
    var statusChange: (()->Void)?
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: ListCustomCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func mainStatusButtonAction(_ sender: Any) {
        statusChange?()
        delegate?.statusChangeAction()
    }
    
    
}
