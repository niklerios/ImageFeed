//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

struct NetworkClient: NetworkClientProtocol {
    private let decoder: JSONDecoder
    private let urlSession: URLSession
    
    static let shared = NetworkClient()
    
    init(
        decoder: JSONDecoder = JSONDecoder(),
        urlSession: URLSession = .shared
    ) {
        self.decoder = decoder
        self.urlSession = urlSession
    }

    func post<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    ) {
        fetch(
            url: url,
            method: .post,
            responseType: responseType,
            completion: completion
        )
    }
    
    func put<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    ) {
        fetch(
            url: url,
            method: .put,
            responseType: responseType,
            completion: completion
        )
    }
    
    func get<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    ) {
        fetch(
            url: url,
            method: .get,
            responseType: responseType,
            completion: completion
        )
    }
    
    func delete<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    ) {
        fetch(
            url: url,
            method: .delete,
            responseType: responseType,
            completion: completion
        )
    }
}

extension NetworkClient {
    private enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    private func fetch<T>(
        url: URL,
        method: HTTPMethod,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    ) {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        let completionOnTheMainThread: Completion<T> = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                completionOnTheMainThread(.failure(.urlRequestError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionOnTheMainThread(.failure(.urlSessionError))
                return
            }
            
            guard let data else {
                completionOnTheMainThread(.failure(.invalidResponse))
                return
            }
            
            guard 200..<300 ~= response.statusCode else {
                completionOnTheMainThread(.failure(.statusCodeError(response.statusCode)))
                return
            }
            
            do {
                let result = try decoder.decode(T.self, from: data)
                completionOnTheMainThread(.success(result))
            } catch {
                completionOnTheMainThread(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
