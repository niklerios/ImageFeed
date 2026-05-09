//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

enum NetworkError: Error {
    case urlRequestError(Error)
    case decodingError(Error)
    case statusCodeError(Int)
    case urlSessionError
    case invalidResponse
}
