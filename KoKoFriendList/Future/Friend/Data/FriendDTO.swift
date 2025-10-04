//
//  FriendDTO.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

struct FriendDTO: Codable {
    let response: [Friend]
    
    struct Friend: Codable {
        let name: String
        let status: Int
        let isTop: String
        let fid: String
        let updateDate: String
    }
}
//
//{
//  "response": [
//    {
//      "name": "黃靖僑",
//      "status": 0,
//      "isTop": "0",
//      "fid": "001",
//      "updateDate": "20190801"
//    },
//    {
//      "name": "翁勳儀",
//      "status": 0,
//      "isTop": "1",
//      "fid": "002",
//      "updateDate": "20190802"
//    },
//    {
//      "name": "洪佳妤",
//      "status": 1,
//      "isTop": "0",
//      "fid": "003",
//      "updateDate": "20190804"
//    },
//    {
//      "name": "彭安亭",
//      "status": 2,
//      "isTop": "0",
//      "fid": "007",
//      "updateDate": "20190802"
//    },
//    {
//      "name": "施君凌",
//      "status": 2,
//      "isTop": "0",
//      "fid": "008",
//      "updateDate": "20190803"
//    }
//    
//  ]
//}
