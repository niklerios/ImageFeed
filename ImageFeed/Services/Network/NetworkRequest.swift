//
//  NetworkRequest.swift
//  ImageFeed
//
//  Created by Alfa on 15.05.2026.
//

import Foundation

struct NetworkRequest<T, ID: NetworkTaskStorage.RequestId> {
    typealias Completion = (Result<T, NetworkError>) -> Void
    typealias ResponseType = T.Type
    
    var originalRequest: URLRequest
    let requestId: ID?

    private let responseType: ResponseType
    private let completion: Completion?
    private let completionQueue: DispatchQueue
    
    init(
        url: URL,
        requestId: ID? = nil,
        responseType: ResponseType,
        completionQueue: DispatchQueue = .main,
        completion: Completion? = nil
    ) {
        self.originalRequest = URLRequest(url: url)
        self.requestId = requestId
        self.responseType = responseType
        self.completionQueue = completionQueue
        self.completion = completion
        
        setHTTPMethod(.get)
    }
    
    private func executeCompletion(_ result: Result<T, NetworkError>) {
        guard let completion else { return }

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
