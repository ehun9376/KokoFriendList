//
//  String.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let formats = ["yyyy/MM/dd", "yyyyMMdd"]
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        for format in formats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                return date
            }
        }
        return nil
    }
}
