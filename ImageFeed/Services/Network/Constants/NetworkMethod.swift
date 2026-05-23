//
//  NetworkMethod.swift
//  ImageFeed
//
//  Created by Alfa on 15.05.2026.
//

enum NetworkMethod: String {
    case get, post, put, delete
    
    var value: String { rawValue.uppercased() }
}
