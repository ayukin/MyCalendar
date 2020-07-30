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
    @objc dynamic var date = Date()
    @objc dynamic var dateString: String!
//    @objc dynamic var alert: Bool = false
    @objc dynamic var alertDate: Date? = Date()
    @objc dynamic var alertValueIndex = 0
    @objc dynamic var alertId: String!
    @objc dynamic var place: String!
    @objc dynamic var memo: String!
//    @objc dynamic var createAt = Date()
    
}

func realmMigration() {
    // Realmマイグレーションバージョン
    // レコードフォーマットを変更する場合、このバージョンも上げていく。
    let migSchemaVersion: UInt64 = 1
    
    // マイグレーション設定
    let config = Realm.Configuration(schemaVersion: migSchemaVersion,
        migrationBlock: {migration, oldSchemaVersion in
            if (oldSchemaVersion < migSchemaVersion) {
    }})
    Realm.Configuration.defaultConfiguration = config
}

