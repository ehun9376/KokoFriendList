//
//  Endpoint.swift
//  CombineTest
//
//  Created by 陳逸煌 on 2025/9/23.
//

import Foundation

enum HTTPMethod: String {
    case get
    case post
    case put
    case patch
    case delete
}
enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
    case multipart = "multipart/form-data"
}


class Endpoint {
    var url: APIURL
    var path: String
    var method: HTTPMethod
    var query: [URLQueryItem]?
    var headers: [String: String]?
    var body: [String: String]?
    var contentType: ContentType?
    
    init(
        url: APIURL,
        path: String,
        method: HTTPMethod, 
        query: [URLQueryItem]? = nil, 
        headers: [String : String]? = nil, 
        body: [String : String]? = nil, 
        contentType: ContentType? = nil,
    ) {
        self.url = url
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
        self.contentType = contentType
        
    }
}
