//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

enum NetworkError: Error {
    case urlRequestError(Error)
    case decodingError(Error)
    case statusCodeError(Int, Data)
    case urlSessionError
    case invalidResponse
}
