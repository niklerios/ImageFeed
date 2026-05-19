//
//  ApiRequests.swift
//  ImageFeed
//
//  Created by Alfa on 18.05.2026.
//

enum ApiRequests {
    typealias Request<T> = NetworkRequest<T, ApiRequestIds>
    typealias Completion<T> = Request<T>.Completion
    typealias URLBuilder = NetworkURL<ApiQueryParams>
}
