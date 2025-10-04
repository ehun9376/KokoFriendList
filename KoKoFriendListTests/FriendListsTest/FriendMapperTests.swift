//
//  FriendMapperTests.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/4.
//

import XCTest
@testable import KoKoFriendList

@MainActor
class FriendMapperTests {
    func friendDTO_convert_friendModel() async throws {
        
        let friendDTO = FriendDTO(response: [.init(name: "test", status: 1, isTop: "1", fid: "001", updateDate: "20250501")])
        let friends = friendDTO.toDomain()
        XCTAssertEqual(friends.first?.name, "test")
        XCTAssertEqual(friends.first?.isTop, true)
        XCTAssertEqual(friends.first?.fid, "001")
        XCTAssertEqual(friends.first?.updateDate, "20250501".toDate())
        XCTAssertEqual(friends.count, 1)
        XCTAssertEqual(friends.first?.status, .finish)
        
    }
}
