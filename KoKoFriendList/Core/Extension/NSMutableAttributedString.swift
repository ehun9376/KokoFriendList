//
//  NSMutableAttributedString.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    func add(text: String, attrDict: [NSAttributedString.Key : Any]? = nil) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: text, attributes: attrDict)
        self.append(attributeString)
        return self
    }
    
}

