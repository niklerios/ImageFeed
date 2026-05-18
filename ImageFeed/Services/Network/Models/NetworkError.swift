//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

enum NetworkError: Error {
    case unknownError(Error)
    case urlRequestError(URLError)
    case decodingError(DecodingError)
    case statusCodeError(Int, Data)
    case missingResponseData
    case invalidResponse
    case requestAlreadyInProgress
}

extension NetworkError: CustomStringConvertible {
    var description: String {
        switch self {
            case let .unknownError(error):
                "[Unknown Error]: \(error.localizedDescription)"
            case let .urlRequestError(error):
                "[URLRequest Error]: \(error.localizedDescription)"
            case let .decodingError(error):
                "[Decoding Error]: \(error.localizedDescription)"
            case let .statusCodeError(code, data):
                "[StatusCode Error]: \(code) \(data)"
            case .missingResponseData:
                "[MissingResponseData Error]"
            case .invalidResponse:
                "[InvalidResponse Error]"
            case .requestAlreadyInProgress:
                "[RequestAlreadyInProgress Error]"
        }
    }
}
