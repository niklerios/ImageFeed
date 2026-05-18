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
        
        let presentation = present(
            description: "SUCCESS",
            request: request,
            data: data
        )
        
        logger.info("✅ \(presentation)")
    }
    
    func failure(error: NetworkError, request: URLRequest) {
        guard isEnabled else { return }
        
        let presentation = present(
            description: error.description,
            request: request
        )
        
        logger.error("⚠️ \(presentation)")
    }
    
    private func present(
        description: String,
        request: URLRequest,
        data: Data = Data()
    ) -> String {
        let httpMethod = request.httpMethod?.uppercased() ?? "GET"
        let urlString = request.url?.absoluteString ?? "Unknown URL"
        let response = String(data: data, encoding: .utf8) ?? ""
        
        return """
        NetworkClient [\(description)]:

        URL: \(httpMethod) \(urlString)
        Response: \(response)
        """
    }
}
