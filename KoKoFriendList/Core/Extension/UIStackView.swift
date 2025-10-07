//
//  UIStackView.swift
//  KoKoFriendList
//
//  Created by 陳逸煌 on 2025/10/7.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        self.arrangedSubviews.forEach({ $0.removeFromSuperview() })
    }
    
}
