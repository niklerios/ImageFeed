//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

protocol NetworkClientProtocol {
    typealias Request<T: Decodable> = NetworkRequest<T>

    func post<T>(with request: Request<T>)
    func put<T>(with request: Request<T>)
    func get<T>(with request: Request<T>)
    func delete<T>(with request: Request<T>)
}

extension NetworkClient: NetworkClientProtocol {
    func post<T>(with request: Request<T>) {
        fetch(with: request, method: .post)
    }
    func put<T>(with request: Request<T>) {
        fetch(with: request, method: .put)
    }
    func get<T>(with request: Request<T>) {
        fetch(with: request, method: .get)
    }
    func delete<T>(with request: Request<T>) {
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
    
    private func fetch<T>(with request: Request<T>, method: NetworkMethod) {
        var request = request

        let urlRequest = request.originalRequest
        let requestId = request.requestId

        request.setHTTPMethod(method)
        
        let failure: (NetworkError) -> Void = {
            request.onFailure($0)
            logger.failure(error: $0, request: urlRequest)
        }
        
        let success: (Data, T) -> Void = {
            request.onSuccess($1)
            logger.success(data: $0, request: urlRequest)
        }
        
        if let sameTask = taskStorage.findTask(by: requestId) {
            let previousTaskUrl = sameTask.originalRequest?.url
            let currentTaskUrl = urlRequest.url
            
            guard previousTaskUrl != currentTaskUrl else {
                return failure(.requestAlreadyInProgress)
            }
            
            taskStorage.delete(by: requestId)
            sameTask.cancel()
        }
                
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            defer {
                taskStorage.delete(by: requestId)
            }
            
            if let error = error as? URLError {
                return failure(.urlRequestError(error))
            }
            
            if let error {
                return failure(.unknownError(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return failure(.invalidResponse)
            }
            
            guard let data else {
                return failure(.missingResponseData)
            }
            
            guard 200..<300 ~= response.statusCode else {
                return failure(.statusCodeError(response.statusCode, data))
            }
            
            do {
                success(data, try decode(data))
            } catch let error as DecodingError {
                failure(.decodingError(error))
            } catch {
                failure(.unknownError(error))
            }
        }
        
        taskStorage.store(task, for: requestId)
        task.resume()
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
