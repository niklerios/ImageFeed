//
//  ApiRequests.swift
//  ImageFeed
//
//  Created by Alfa on 18.05.2026.
//

/// Контейнер фабрик API запросов `NetworkRequest`
///
/// Через экстеншены добавляются доменные зоны для запросов ,касающихся конкретных доменов (+OAuth2, +Profile и т.д.)
/// - Note: использовать встроенные типы  - `Request` ,`Completion` и `URLBuilder`
///
/// Пример:
/// ```swift
/// func someRequest(completion: @escaping Completion<SomeType>) -> Request<SomeType> {
///     let networkURL = URLBuilder.base(path: "/some") { queryParams
///         queryParams.add(.someParam, "value")
///     }
///     let networkRequest = Request(
///         url: networkURL.url,
///         requestId: .someRequest,
///         responseType: SomeType.self,
///         completion: completion
///     )
///
///     return networkRequest
/// }
/// ```
enum ApiRequests {

    /// Возвращаемый тип фабрики
    /// - Note: использовать вместо `NetworkRequest<T, ID>` напрямую
    typealias Request<T> = NetworkRequest<T, ApiRequestIds>
    
    /// Тип передаваемого коллбека
    /// - Note: использовать вместо `NetworkRequest<T, ID>.Completion` напрямую
    typealias Completion<T> = Request<T>.Completion
    
    /// Билдер URL
    /// - Note: использовать вместо `NetworkURL` напрямую
    typealias URLBuilder = NetworkURL<ApiQueryParams>
}
