//
//  NetworkURL.swift
//  ImageFeed
//
//  Created by Alfa on 15.05.2026.
//

import Foundation

struct NetworkURL {
    class QueryParams {
        fileprivate var store = [(NetworkQueryParam, String)]()
        
        @discardableResult
        func add(_ key: NetworkQueryParam, _ value: String) -> Self {
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
    
    private init(baseURLString: String, path: String, queryBuilder: QueryBuilder) {
        var urlComponents = URLComponents(string: baseURLString)
        
        queryBuilder(&queryParams)
        
        urlComponents?.path = path
        urlComponents?.queryItems = queryParams.store.map {
            URLQueryItem(name: $0.rawValue, value: $1)
        }
        
        guard let _ = urlComponents?.url else {
            preconditionFailure("Unable to create URL for path: \(path)")
        }
        
        self.urlComponents = urlComponents!
    }
    
    static func base(path: String, queryBuilder: QueryBuilder) -> Self {
        self.init(
            baseURLString: Constants.baseURLString,
            path: path,
            queryBuilder: queryBuilder
        )
    }
    
    static func baseApi(path: String, queryBuilder: QueryBuilder) -> Self {
        self.init(
            baseURLString: Constants.baseApiURLString,
            path: path,
            queryBuilder: queryBuilder
        )
    }
}
