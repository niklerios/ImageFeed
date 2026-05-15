//
//  NetworkLogger.swift
//  ImageFeed
//
//  Created by Alfa on 15.05.2026.
//

import OSLog

struct NetworkLogger {
    static let disabled = Self(isEnabled: false)
    static let enabled = Self(isEnabled: true)
    
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: "NetworkClient"
    )
    
    private let isEnabled: Bool
    
    func success(data: Data, request: URLRequest) {
        guard isEnabled else { return }
        
        let successPresentation = present(
            title: "SUCCESS",
            description: "",
            request: request,
            data: data
        )
        
        logger.info("✅ \(successPresentation)")
    }
    
    func failure(error: NetworkError, request: URLRequest) {
        guard isEnabled else { return }
        
        let logData: (String, String, Data) -> Void = { title, desc, data in
            let errorPresentation = present(
                title: "ERROR: \(title)",
                description: desc,
                request: request,
                data: data
            )
            
            logger.error("⚠️ \(errorPresentation)")
        }
        
        let log: (String, String) -> Void = {
            logData($0, $1, Data())
        }
        
        switch error {
            case let .urlRequestError(error):
                log("URLRequest", error.localizedDescription)
            case let .decodingError(error):
                log("Decoding", error.localizedDescription)
            case let .statusCodeError(statusCode, data):
                logData("StatusCode", "\(statusCode)", data)
            case .urlSessionError:
                log("URLSession", "")
            case .invalidResponse:
                log("InvalidResponse", "")
        }
    }
    
    private func present(
        title: String,
        description: String,
        request: URLRequest,
        data: Data
    ) -> String {
        let httpMethod = request.httpMethod ?? "GET"
        let urlString = request.url?.absoluteString ?? "Unknown URL"
        let dataString = String(data: data, encoding: .utf8) ?? ""
        
        return """
        NetworkClient [\(title)]: \(description)

        Request: \(httpMethod) \(urlString)
        Response: \(dataString)
        """
    }
}
