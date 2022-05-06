//
//  APICaller.swift
//  TwitterClone
//
//  Created by Caleb Ngai on 5/6/22.
//

import Foundation

struct K {
    static let APIKey = "cCN0pLVq34O2Ij3Kz1pm9kqVu"
    static let APIKeySecret = "HE7rTaq81U7FkTGSbh9m9PNeEvcnWJRZelESvQlscwODpQbJ6m"
    static let bearerToken =  "AAAAAAAAAAAAAAAAAAAAAFgvcQEAAAAAamVnD%2F%2BquEtsJDgEvHXIUcuT7VA%3DefoIcmcEiubKHIHkppwq41fOY2lWMXtHyguAHMF142mM3EZvSh"
    static let baseURL = "https://api.twitter.com/2/"
}

enum APIError: Error {
    case failedtoGetData
}

final class APICaller {
    
    static let shared = APICaller()
    private init() {}
    
    public func getVolumeStreams(completion: @escaping (Result<[Tweet], Error>) -> Void) {
        createRequest(with:
                      URL(string: "https://api.twitter.com/2/tweets/sample/stream?tweet.fields=created_at&expansions=author_id&user.fields=created_at"), type: .GET) { request in
            
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedtoGetData))
                    return
                }
                do {
                    //passing the result data as a Success value into the completion handler. Makes it easier to verfiy that API call worked.
                    let result = try JSONDecoder().decode(VolumeStreamsResponse.self, from: data)
                    completion(.success(result.data))
                    print(result)
                    
                }
                catch {
                    //passing the error to the completion handler
                    completion(.failure(error))
                }
            }
            task.resume()
        }
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
        print(request)
        completion(request)
    }

}

