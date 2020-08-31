//
//  MarvelApiRouter.swift
//  RxMarvel
//
//  Created by Marsel Tzatzo on 29/8/20.
//  Copyright © 2020 Marsel Tzatzo. All rights reserved.
//

import Alamofire

enum MarvelApiRouter: URLRequestConvertible {
    
    case characters(order: String, offset: Int, limit: Int)
    
    var version: String {
        return "v1"
    }
    
    var path: String {
        switch self {
        case .characters:
            return "public/characters"
        }
    }
    
    fileprivate var authQueryStringParams: [URLQueryItem] {
        let timestamp = Date().millisecondsSince1970
        return [URLQueryItem(name: "ts", value: String(timestamp)),
                URLQueryItem(name: "apikey", value: Environment.current.publicApiKey),
                URLQueryItem(name: "hash", value: "\(timestamp)\(Environment.current.privateApiKey)\(Environment.current.publicApiKey)".MD5())]
    }
    
    var queryStringParams: [URLQueryItem] {
        switch self {
        case .characters(let order, let offset, let limit):
            return [URLQueryItem(name: "orderBy", value: order),
                    URLQueryItem(name: "limit", value: String(limit)),
                    URLQueryItem(name: "offset", value: String(offset))]
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .characters:
            return .get
        }
    }
    
    var url: String {
        return "https://gateway.marvel.com/\(version)/\(path)"
    }
    
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: self.url) else {
            fatalError("Could not build URLComponents for url: \(self.url)")
        }
        
        urlComponents.queryItems = self.authQueryStringParams + self.queryStringParams
        
        guard let url = try? urlComponents.asURL() else {
            fatalError("Could not build URL from URLComponents: \(String(describing: urlComponents.string))")
        }
        
        var request = URLRequest(url: url)
        request.method = self.httpMethod
        return request
    }
    
    
    
    
}
