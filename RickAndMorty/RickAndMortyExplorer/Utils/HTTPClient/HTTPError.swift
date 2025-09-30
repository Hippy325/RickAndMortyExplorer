//
//  HTTPError.swift
//  RickAndMortyExplorer
//
//  Created by Тигран Гарибян on 24.09.2025.
//

import Foundation

enum HTTPError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case invalidStatusCode(Int)
    case timedOut
    case notFound
    case serverError
    case clientError
    case faildDecode(Error)
}
