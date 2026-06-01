//
//  ApiRequests+Photos.swift
//  ImageFeed
//
//  Created by Alfa on 01.06.2026.
//

extension ApiRequests {
    static func fetchPhotos(
        page: Int?,
        perPage: Int?,
        completion: @escaping Completion<[PhotoResponse]>
    ) -> Request<[PhotoResponse]> {
        let networkURL = URLBuilder.baseApi(path: "/photos") { queryParams in
            if let page {
                queryParams.add(.page, String(page))
            }
            if let perPage {
                queryParams.add(.per_page, String(perPage))
            }
        }
        
        return Request(
            url: networkURL.url,
            requestId: .fetchPhotos,
            duplicationResolvingStrategy: .skipDuplicateAlways,
            responseType: [PhotoResponse].self,
            authorization: true,
            completion: completion
        )
    }
}
