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
    
    public func getSearch(with query: String, completion: @escaping (Result<[TweetModel], Error>) -> Void) {
        createRequest(with:URL(string: "\(K.baseURL)tweets/search/recent?query=\(query)&max_results=30"), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    print("error before decoder")
                    completion(.failure(APIError.failedtoGetData))
                    return
                }
                do {
                    //passing the result data as a Success value into the completion handler. Makes it easier to verfiy that API call worked.
                    let result = try JSONDecoder().decode(SearchResponse.self, from: data)
                    completion(.success(result.data))
                }
                catch {
                    //passing the error to the completion handler
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getSearch(with query: String) async throws -> [TweetModel] {
        guard let request = try await createRequest(with: URL(string: "\(K.baseURL)tweets/search/recent?query=\(query)&max_results=30"), type: .GET)
        else {
            return []
        }
        
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
    private func createRequest(with url: URL?, type: HTTPMethod, completion: @escaping (URLRequest) -> Void) {
        
        guard let apiURL = url else {return}
        
        var request = URLRequest(url: apiURL)
        request.setValue("Bearer \(K.bearerToken)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = type.rawValue
        request.timeoutInterval = 60
        completion(request)
    }
    
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

