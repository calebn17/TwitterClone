//
//  APICaller.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import Foundation

public enum APIError: Error {
    case failedtoGetData
}

final class APICaller {
    
    static let shared = APICaller()
    private init() {}
    
    public func getSearch(with query: String) async throws -> [TweetResponse] {
        guard let request = try await createRequest(with: URL(string: "\(K.baseURL)tweets/search/recent?query=\(query)&max_results=30"), type: .GET)
        else { return [] }
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(SearchResponse.self, from: data)
        
        return result.data
    }
    
    
//MARK: - Generate Request
    
    enum HTTPMethod: String {
        case GET
        case POST
        case DELETE
        case PUT
    }
    
    ///Reusable function for making API requests. Returns a URL Request
    private func createRequest(with url: URL?, type: HTTPMethod) async throws -> URLRequest? {
        guard let apiURL = url else {
            return nil
        }
        
        var request = URLRequest(url: apiURL)
        request.setValue("Bearer \(K.bearerToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = type.rawValue
        request.timeoutInterval = 60
        return request
    }
}

