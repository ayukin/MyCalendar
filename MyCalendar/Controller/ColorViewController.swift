//
//  ColorViewController.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/08/02.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import UIKit

class ColorViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let selectColor: [UIColor] = [.systemTeal, .systemBlue, .systemIndigo, .systemYellow, .systemOrange, .systemRed, .systemPink, .systemGreen, .systemPurple, .systemGray, .black]
    let selectColorName: [String] = ["light blue", "blue", "indigo", "yellow", "orange", "red", "pink", "green", "purple", "gray", "black"]
    
    var selectColorNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaultsのインスタンス
        let userDefaults = UserDefaults.standard
        // UserDefaultsから値を読み込む
        let myColor = userDefaults.colorForKey(key: "myColor")
        selectColorNumber = UserDefaults.standard.integer(forKey: "myColorNumber")
        
        self.navigationItem.title = "カラー設定"
        
        // ナビゲーションバーのカスタマイズ
        self.navigationController?.navigationBar.barTintColor = myColor
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        
        // レイアウトを調整
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 10)
        collectionView.collectionViewLayout = layout
        
    }
    
}


extension ColorViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectColor.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        // Tag番号を使ってView（カラー表示）のインスタンス生成
        let colorView = cell.contentView.viewWithTag(2)!
        colorView.backgroundColor = selectColor[indexPath.row]
        colorView.layer.masksToBounds = true
        colorView.layer.cornerRadius = (self.view.frame.width/3 - 15 - 20) / 2
        // Tag番号を使ってView（選択表示枠）のインスタンス生成
        let selectView = cell.contentView.viewWithTag(1)!
        selectView.layer.borderColor = UIColor.black.cgColor
        selectView.layer.borderWidth = 1
        selectView.layer.masksToBounds = true
        selectView.layer.cornerRadius = 10
        
        if indexPath.row != selectColorNumber {
            selectView.isHidden = true
        } else {
            selectView.isHidden = false
        }
        
        // Tag番号を使ってLabel（カラー名称）のインスタンス生成
        let nameLabel = cell.contentView.viewWithTag(3) as! UILabel
        nameLabel.textColor = selectColor[indexPath.row]
        nameLabel.text = selectColorName[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalSpace: CGFloat = 15
        let cellSize: CGFloat = self.view.frame.width/3 - horizontalSpace
        
        return CGSize(width: cellSize, height: cellSize + 23)
    }


}


extension ColorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectColorNumber = indexPath.row
        
        // UserDefaultsのインスタンス
        let userDefaults = UserDefaults.standard
        // Keyの値を削除
        userDefaults.removeObject(forKey: "myColor")
        userDefaults.removeObject(forKey: "myColorNumber")
        // Keyを指定して保存
        userDefaults.setColor(color: selectColor[selectColorNumber], forKey: "myColor")
        UserDefaults.standard.set(selectColorNumber, forKey: "myColorNumber")
        
        collectionView.reloadData()
        print(userDefaults.colorForKey(key: "myColor") as Any)
    }
    
}

