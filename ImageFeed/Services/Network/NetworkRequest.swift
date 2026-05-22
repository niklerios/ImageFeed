//
//  NetworkRequest.swift
//  ImageFeed
//
//  Created by Alfa on 15.05.2026.
//

import Foundation

struct NetworkRequest<Response, RequestId: NetworkTaskStorage.RequestId> {
    typealias Completion = (Result<Response, NetworkError>) -> Void
    typealias ResponseType = Response.Type
    
    var originalRequest: URLRequest
    let requestId: RequestId?

    private let responseType: ResponseType
    private let completion: Completion?
    private let completionQueue: DispatchQueue
    
    init(
        url: URL,
        requestId: RequestId? = nil,
        responseType: ResponseType,
        authorization: Bool = false,
        authStorage: NetworkAuthStorageProtocol = NetworkAuthStorage.shared,
        completionQueue: DispatchQueue = .main,
        completion: Completion? = nil
    ) {
        self.originalRequest = URLRequest(url: url)
        self.requestId = requestId
        self.responseType = responseType
        self.completionQueue = completionQueue
        self.completion = completion
        
        if (authorization) {
            setAuthorization(fromStorage: authStorage)
        }
        
        setHTTPMethod(.get)
    }
    
    private func executeCompletion(_ result: Result<Response, NetworkError>) {
        guard let completion else { return }

        completionQueue.async {
            completion(result)
        }
    }
    
    func onSuccess(_ result: Response) {
        executeCompletion(.success(result))
    }
    
    func onFailure(_ error: NetworkError) {
        executeCompletion(.failure(error))
    }
    
    mutating func setHTTPMethod(_ method: NetworkMethod) {
        originalRequest.httpMethod = method.value
    }
    
    private mutating func setAuthorization(
        fromStorage storage: NetworkAuthStorageProtocol
    ) {
        guard let token = storage.authToken else {
            return
        }
        
        let tokenType = storage.tokenType ?? "Bearer"
        let header = "Authorization"
        
        originalRequest.setValue("\(tokenType) \(token)", forHTTPHeaderField: header)
    }
}
