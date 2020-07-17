//
//  Todo.swift
//  MyCalendar
//
//  Created by 西岡鮎季 on 2020/07/17.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import RealmSwift

class Todo: Object {
    @objc dynamic var task: String!
    @objc dynamic var status: Bool = false
    @objc dynamic var date = Date()
    @objc dynamic var alert = Date()
    @objc dynamic var place: String!
    @objc dynamic var memo: String!
    
}

