//
//  NetworkRequest.swift
//  ImageFeed
//
//  Created by Alfa on 15.05.2026.
//

import Foundation

struct NetworkRequest<T> {
    typealias Completion = (Result<T, NetworkError>) -> Void
    typealias ResponseType = T.Type
    
    var urlRequest: URLRequest

    private let responseType: ResponseType
    private let completion: Completion
    private let completionQueue: DispatchQueue
    
    init(
        url: URL,
        responseType: ResponseType,
        completionQueue: DispatchQueue,
        completion: @escaping Completion
    ) {
        self.urlRequest = URLRequest(url: url)
        self.responseType = responseType
        self.completionQueue = completionQueue
        self.completion = completion
        
        setHTTPMethod(.get)
    }
    
    init(
        url: URL,
        responseType: ResponseType,
        completion: @escaping Completion
    ) {
        self.init(
            url: url,
            responseType: responseType,
            completionQueue: .main,
            completion: completion
        )
    }
    
    private func executeCompletion(_ result: Result<T, NetworkError>) {
        completionQueue.async {
            completion(result)
        }
    }
    
    func onSuccess(_ result: T) {
        executeCompletion(.success(result))
    }
    
    func onFailure(_ error: NetworkError) {
        executeCompletion(.failure(error))
    }
    
    mutating func setHTTPMethod(_ method: NetworkMethod) {
        urlRequest.httpMethod = method.value
    }
}
