//
//  NetworkTaskStorage.swift
//  ImageFeed
//
//  Created by Alfa on 17.05.2026.
//

import Foundation

// TODO: Переписать на Actor (но мы пока не проходили вроде)
final class NetworkTaskStorage {
    static let shared = NetworkTaskStorage()
    
    private init() {}
    
    // TODO: если тип ключа у Dictionary комформит String ,а не Hashable
    // то требует nonisolated у класса и @unchecked Sendable (разобраться почему)
    private var storage: Dictionary<NetworkRequestId, URLSessionTask> = [:]
    private let queue = DispatchQueue(label: "NetworkTaskStorage")
    
    func findTask(by requestId: NetworkRequestId?) -> URLSessionTask? {
        guard let requestId else { return nil }
        
        return queue.sync {
            storage[requestId]
        }
    }
    
    func store(_ task: URLSessionTask, for requestId: NetworkRequestId?) {
        guard let requestId else { return }

        queue.sync {
            self.storage[requestId] = task
        }
    }
    
    func delete(by requestId: NetworkRequestId?) {
        guard let requestId else { return }

        queue.sync {
            _ = self.storage.removeValue(forKey: requestId)
        }
    }
}
