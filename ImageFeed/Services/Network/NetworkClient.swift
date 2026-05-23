//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

protocol NetworkClientProtocol {
    typealias Request<
        Response: Decodable,
        RequestId: NetworkTaskStorage.RequestId
    > = NetworkRequest<Response, RequestId>

    func post<Response, RequestId>(
        with request: Request<Response, RequestId>
    )
    func put<Response, RequestId>(
        with request: Request<Response, RequestId>
    )
    func get<Response, RequestId>(
        with request: Request<Response, RequestId>
    )
    func delete<Response, RequestId>(
        with request: Request<Response, RequestId>
    )
}

extension NetworkClient: NetworkClientProtocol {
    func post<Response, RequestId>(
        with request: Request<Response, RequestId>
    ) {
        fetch(with: request, method: .post)
    }
    func put<Response, RequestId>(
        with request: Request<Response, RequestId>
    ) {
        fetch(with: request, method: .put)
    }
    func get<Response, RequestId>(
        with request: Request<Response, RequestId>
    ) {
        fetch(with: request, method: .get)
    }
    func delete<Response, RequestId>(
        with request: Request<Response, RequestId>
    ) {
        fetch(with: request, method: .delete)
    }
}

struct NetworkClient {
    private let decoder = JSONDecoder()
    private let urlSession: URLSession = .shared
    private let logger: NetworkLogger = .enabled
    private let taskStorage: NetworkTaskStorage = .shared
    
    static let shared = NetworkClient()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func fetch<Response: Decodable, RequestId>(
        with request: Request<Response, RequestId>,
        method: NetworkMethod
    ) {
        var request = request

        let urlRequest = request.originalRequest
        let requestId = request.requestId

        request.setHTTPMethod(method)
        
        let failure: (NetworkError, Data?) -> Void = {
            request.onFailure($0)
            logger.failure(error: $0, data: $1, request: urlRequest)
        }
        
        let success: (Response, Data) -> Void = {
            request.onSuccess($0)
            logger.success(data: $1, request: urlRequest)
        }
        
        if let sameTask = taskStorage.findTask(by: requestId) {
            let previousTaskUrl = sameTask.originalRequest?.url
            let currentTaskUrl = urlRequest.url
            
            guard previousTaskUrl != currentTaskUrl else {
                return failure(.requestAlreadyInProgress, nil)
            }
            
            taskStorage.delete(by: requestId)
            sameTask.cancel()
        }
                
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            defer {
                taskStorage.delete(by: requestId)
            }
            
            if let error = error as? URLError {
                return failure(.urlRequestError(error), nil)
            }
            
            if let error {
                return failure(.unknownError(error), nil)
            }
            
            guard let response = response as? HTTPURLResponse else {
                return failure(.invalidResponse, nil)
            }
            
            guard let data else {
                return failure(.missingResponseData, nil)
            }
            
            guard 200..<300 ~= response.statusCode else {
                return failure(.statusCodeError(response.statusCode), data)
            }
            
            do {
                success(try decode(data), data)
            } catch let error as DecodingError {
                failure(.decodingError(error), data)
            } catch {
                failure(.unknownError(error), data)
            }
        }
        
        taskStorage.store(task, for: requestId)
        task.resume()
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
