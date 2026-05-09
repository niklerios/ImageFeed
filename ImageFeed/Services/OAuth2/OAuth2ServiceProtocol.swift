//
//  OAuth2ServiceProtocol.swift
//  ImageFeed
//
//  Created by Alfa on 09.05.2026.
//

protocol OAuth2ServiceProtocol: AnyObject {
    typealias Completion = NetworkClient.Completion
    
    func fetchOAuthToken(
        with code: String,
        completion: @escaping Completion<String>
    )
}
