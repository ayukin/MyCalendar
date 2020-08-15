//
//  Todo.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/17.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import Foundation
import RealmSwift

class Todo: Object {
    @objc dynamic var task: String!
    @objc dynamic var status: Bool = false
    @objc dynamic var date: Date? = Date()
    @objc dynamic var dateString: String!
    @objc dynamic var alertDate: Date? = Date()
    @objc dynamic var alertValueIndex = 0
    @objc dynamic var alertId: String!
    @objc dynamic var place: String!
    @objc dynamic var memo: String!
    @objc dynamic var hoge: String!
    
}

