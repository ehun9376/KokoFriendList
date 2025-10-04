//
//  FriendModel.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.

import Foundation

enum StatusType: Int {
    ///0 邀請送出
    case invited = 0
    
    ///1 已完成
    case finish = 1
    
    ///2 邀請中
    case inviting = 2
}

struct FriendModel {
    let name: String
    let status: StatusType
    let isTop: Bool
    let fid: String
    let updateDate: Date
    
}


//{
//      "name": "黃靖僑",
//      "status": 0,
//      "isTop": "0",
//      "fid": "001",
//      "updateDate": "20190801"
//    },
