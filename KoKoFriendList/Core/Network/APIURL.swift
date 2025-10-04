//
//  APIDomain.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

enum APIURL {
    
    case dimanyen
    
    func getURL() -> String {
        switch self {
        case .dimanyen:
            return "https://dimanyen.github.io"
    
        }
    }
        
            
        
}

class AESKey {
    
    static var key = "E4NLZ1O7NE4SVI4T"
        
}
