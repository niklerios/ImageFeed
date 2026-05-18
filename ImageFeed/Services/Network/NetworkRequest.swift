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
    
    var originalRequest: URLRequest
    let requestId: NetworkRequestId?

    private let responseType: ResponseType
    private let completion: Completion
    private let completionQueue: DispatchQueue
    
    init(
        url: URL,
        requestId: NetworkRequestId? = nil,
        responseType: ResponseType,
        completionQueue: DispatchQueue = .main,
        completion: @escaping Completion
    ) {
        self.originalRequest = URLRequest(url: url)
        self.requestId = requestId
        self.responseType = responseType
        self.completionQueue = completionQueue
        self.completion = completion
        
        setHTTPMethod(.get)
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
        originalRequest.httpMethod = method.value
    }
}
