//
//  MemoCustomCell.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/11.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

//delegateはweak参照したいため、classを継承する
protocol  MemoCustomCellDelegate: class {
    func textViewShouldBeginAction()
    func textViewChangeAction()
}

class MemoCustomCell: UITableViewCell {
    
    @IBOutlet weak var textView: CustomTextView!
    
    var memoCustomCellDone: (()->Void)?
    
    // delegateはメモリリークを回避するためweak参照する
    weak var delegate: MemoCustomCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets.zero
        textView.textContainer.lineFragmentPadding = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension MemoCustomCell: UITextViewDelegate {
    // 編集を開始しようとするときに呼び出される処理
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.textViewShouldBeginAction()
        memoCustomCellDone?()
        return true
    }
    
    // textViewの内容をリアルタイムで反映させる
    func textViewDidChangeSelection(_ textView: UITextView) {
        delegate?.textViewChangeAction()
    }
}
