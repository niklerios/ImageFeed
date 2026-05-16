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
    
    static let shared = NetworkClient()
    
    private init() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    private func fetch<T>(with request: Request<T>, method: NetworkMethod) {
        var request = request

        request.setHTTPMethod(method)
        
        let failure: (NetworkError) -> Void = {
            request.onFailure($0)
            logger.failure(error: $0, request: request.urlRequest)
        }
        
        let success: (Data, T) -> Void = {
            request.onSuccess($1)
            logger.success(data: $0, request: request.urlRequest)
        }
                
        let task = urlSession.dataTask(with: request.urlRequest) { data, response, error in
            if let error {
                return failure(.urlRequestError(error))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return failure(.urlSessionError)
            }
            
            guard let data else {
                return failure(.invalidResponse)
            }
            
            guard 200..<300 ~= response.statusCode else {
                return failure(.statusCodeError(response.statusCode, data))
            }
            
            do {
                success(data, try decode(data))
            } catch {
                failure(.decodingError(error))
            }
        }
        
        task.resume()
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
