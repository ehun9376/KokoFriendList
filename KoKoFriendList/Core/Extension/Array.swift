//
//  Array.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

extension Array {
    subscript(safe index: Int) -> Element? {
        return (0 <= index && index < count) ? self[index] : nil
    }
}
