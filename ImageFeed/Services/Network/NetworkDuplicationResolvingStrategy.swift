//
//  NetworkDuplicationResolvingStrategy.swift
//  ImageFeed
//
//  Created by Alfa on 01.06.2026.
//

enum NetworkDuplicationResolvingStrategy {
    // Всегда пропускать запросы-дубли
    case skipDuplicateAlways
    // Всегда отменять активный запрос в пользу дубля
    case cancelActiveAlways
    // Пропускать дубль ,если данные запроса отличаются
    case skipDuplicateIfDifferentData
    // Отменять активный запрос в пользу дубля ,если данные запроса отличаются
    case cancelActiveIfDifferentData
}
