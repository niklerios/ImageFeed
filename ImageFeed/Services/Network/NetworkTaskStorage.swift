//
//  NetworkTaskStorage.swift
//  ImageFeed
//
//  Created by Alfa on 17.05.2026.
//

import Foundation

// TODO: Переписать на Actor (но мы пока не проходили вроде)
final class NetworkTaskStorage {
    protocol RequestId: RawRepresentable, Hashable where RawValue == String {}

    static let shared = NetworkTaskStorage()
    
    private init() {}

    private var storage: Dictionary<String, URLSessionTask> = [:]
    private let queue = DispatchQueue(label: "NetworkTaskStorage")
    
    func findTask(by requestId: (any RequestId)?) -> URLSessionTask? {
        guard let requestId = requestId?.rawValue else { return nil }
        
        return queue.sync {
            storage[requestId]
        }
    }
    
    func store(_ task: URLSessionTask, for requestId: (any RequestId)?) {
        guard let requestId = requestId?.rawValue else { return }

        queue.sync {
            self.storage[requestId] = task
        }
    }
    
    func delete(by requestId: (any RequestId)?) {
        guard let requestId = requestId?.rawValue else { return }

        queue.sync {
            _ = self.storage.removeValue(forKey: requestId)
        }
    }
}
