//
//  NetworkClientProtocol.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

protocol NetworkClientProtocol {
    typealias Completion<T: Decodable> = (Result<T, NetworkError>) -> Void
    typealias ResponseType<T> = T.Type

    func post<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    )
    func put<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    )
    func get<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    )
    func delete<T>(
        _ url: URL,
        responseType: ResponseType<T>,
        completion: @escaping Completion<T>
    )
}
