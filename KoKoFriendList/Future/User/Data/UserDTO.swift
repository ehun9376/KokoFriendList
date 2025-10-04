//
//  UserDTO.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

struct UserResponseDTO: Codable, Sendable {
    let response: [UserDTO]
    
    struct UserDTO: Codable, Sendable {
        let name: String
        let kokoid: String
    }
    
}


//{
//  "response": [
//    {
//      "name": "蔡國泰",
//      "kokoid": "Mike"
//    }
//  ]
//}
