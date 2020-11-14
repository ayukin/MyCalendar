//
//  Date.swift
//  MyCalendar
//
//  Created by Ayuki Nishioka on 2020/11/15.
//  Copyright © 2020 Ayuki Nishioka. All rights reserved.
//

import Foundation

extension Date {
    // 出力フォーマット「yyyy/MM/dd」
    func formatterDateStyleMedium(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }
    // 出力フォーマット「0000/00/00 00:00」
    func formatterDateStyleLong(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter.string(from: date)
    }

    
    
    
    
    
    
    
    // 出力フォーマット「00:00」
    func formatterTimeStyleShort(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }

}
