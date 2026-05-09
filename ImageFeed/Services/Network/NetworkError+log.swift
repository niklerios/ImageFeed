//
//  NetworkError+log.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

import Foundation

extension NetworkError {
    var description: String {
        switch self {
            case let .urlRequestError(error): "URL Request Error: \(error)"
            case let .decodingError(error): "Decoding Error: \(error)"
            case let .statusCodeError(statusCode): "Invalid statusCode \(statusCode)"
            case .urlSessionError: "URLSession Error"
            case .invalidResponse: "Invalid Response"
        }
    }
    
    func log(
        functionName: String = #function,
        fileName: String = #fileID,
        lineNumber: Int = #line,
    ) {
        print(
            """
            [NetworkError]
            File: \(fileName)
            Function: \(functionName)
            Line: \(lineNumber)

            \(description)
            """
        )
    }
}
