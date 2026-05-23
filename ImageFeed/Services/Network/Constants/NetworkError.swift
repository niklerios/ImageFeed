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
    case statusCodeError(Int)
    case missingResponseData
    case invalidResponse
    case requestAlreadyInProgress
}

extension NetworkError: CustomStringConvertible {
    var description: String {
        switch self {
        case let .unknownError(error):
            getUnknownErrorDescription(error)
        case let .urlRequestError(error):
            getUrlRequestErrorDescription(error)
        case let .decodingError(error):
            getDecodingErrorDescription(error)
        case let .statusCodeError(code):
            getStatusCodeErrorDescription(code)
        case .missingResponseData:
            getMissingResponseDataDescription()
        case .invalidResponse:
            getInvalidResponseDescription()
        case .requestAlreadyInProgress:
            getRequestAlreadyInProgressDescription()
        }
    }
}

extension NetworkError {

    private func getUnknownErrorDescription(_ error: Error) -> String {
        """
        [Unknown Error]:
        \(error.localizedDescription)
        """
    }
    
    private func getUrlRequestErrorDescription(_ error: URLError) -> String {
        """
        [URLRequest Error]:
        \(error.localizedDescription)
        \(error.errorCode)
        """
    }
    
    private func getDecodingErrorDescription(_ error: DecodingError) -> String {
        var description = """
        [Decoding Error]:
        \(error.localizedDescription)
        """

        if let context = error.context {
            description += "\n\(context.codingPath): \(context.debugDescription)"
        }

        return description
    }
    
    private func getStatusCodeErrorDescription(_ code: Int) -> String {
        "[StatusCode Error]: \(code)"
    }
    
    private func getMissingResponseDataDescription() -> String {
        "[MissingResponseData Error]"
    }
    
    private func getInvalidResponseDescription() -> String {
        "[InvalidResponse Error]"
    }
    
    private func getRequestAlreadyInProgressDescription() -> String {
        "[RequestAlreadyInProgress Error]"
    }
}
