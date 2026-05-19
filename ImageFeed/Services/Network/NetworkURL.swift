//
//  NetworkURL.swift
//  ImageFeed
//
//  Created by Alfa on 15.05.2026.
//

import Foundation

struct NetworkURL<K: RawRepresentable & Hashable> where K.RawValue == String {
    final class QueryParams {
        fileprivate var store = [(K, String)]()
        fileprivate init() {}
        
        @discardableResult
        func add(_ key: K, _ value: String) -> Self {
            guard !value.isEmpty else { return self }
            
            store.append((key, value))

            return self
        }
    }

    typealias QueryBuilder = (inout QueryParams) -> Void
    private var queryParams = QueryParams()
    
    var urlComponents: URLComponents
    
    var url: URL {
        urlComponents.url!
    }
    
    private init(baseURLString: String, path: String, queryBuilder: QueryBuilder?) {
        guard var urlComponents = URLComponents(string: baseURLString) else {
            preconditionFailure("Unable to create URL from baseURL: \(baseURLString)")
        }
        
        urlComponents.path = path
        
        if let queryBuilder {
            queryBuilder(&queryParams)
            
            urlComponents.queryItems = queryParams.store.map {
                URLQueryItem(name: $0.rawValue, value: $1)
            }
        }
        
        guard let _ = urlComponents.url else {
            preconditionFailure("Unable to create URL for path: \(path)")
        }
        
        self.urlComponents = urlComponents
    }
    
    static func base(path: String, queryBuilder: QueryBuilder? = nil) -> Self {
        self.init(
            baseURLString: Constants.baseURLString,
            path: path,
            queryBuilder: queryBuilder
        )
    }
    
    static func baseApi(path: String, queryBuilder: QueryBuilder? = nil) -> Self {
        self.init(
            baseURLString: Constants.baseApiURLString,
            path: path,
            queryBuilder: queryBuilder
        )
    }
}
