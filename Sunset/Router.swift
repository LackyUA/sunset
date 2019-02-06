//
//  Router.swift
//  Sunset
//
//  Created by Dmytro Dobrovolskyy on 2/6/19.
//  Copyright © 2019 YellowLeaf. All rights reserved.
//

import Alamofire

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}

enum Router: URLRequestConvertible {
    
    case getSunset(latitude: String, longitude: String)
    
    static let baseURLString = "https://api.sunrise-sunset.org"
    
    var method: HTTPMethod {
        switch self {
            
        case .getSunset:
            return .get
        }
    }
    
    var path: String {
        switch self {
            
        case .getSunset:
            return "/json"
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
            
        case .getSunset(let latitude, let longitude):
            return [
                "lat" : latitude,
                "lng" : longitude
            ]
            
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url: URL = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
            
        case .getSunset:
            var params: [String : Any] = [:]
            parameters?.forEach { params[$0] = $1 }
            urlRequest = try URLEncoding.default.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
}
