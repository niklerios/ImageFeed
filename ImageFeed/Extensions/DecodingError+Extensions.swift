//
//  DecodingError+Extensions.swift
//  ImageFeed
//
//  Created by Alfa on 19.05.2026.
//

extension DecodingError {
    var context: DecodingError.Context? {
        switch self {
        case let .typeMismatch(_, context),
             let .valueNotFound(_, context),
             let .keyNotFound(_, context),
             let .dataCorrupted(context):
            context

        @unknown default:
            nil
        }
    }
}
