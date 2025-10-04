//
//  UserMapperTests.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import XCTest
@testable import KoKoFriendList

class UserMapperests: XCTestCase {
    
    func test_userDTO_to_user_success() {
        let userDTO = UserResponseDTO(response: [.init(name: "test", kokoid: "test")])
        
        do {
            let usetModel = try userDTO.toDomain()
            XCTAssertEqual(usetModel.name, "test")
            XCTAssertEqual(usetModel.kokoid, "test")
            
        } catch {
            XCTFail("userDTO mapping error")
        }
        
    }
}

        
