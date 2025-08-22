//
//  ApiManager.swift
//  NeuralDoc
//
//  Created by Maria Slepneva on 11.02.2025.
//

import Foundation

final class APIManager: Sendable {

    typealias NetworkResponse = (data: Data, response: URLResponse)

    static let shared = APIManager(baseURL: "https://dummyjson.com")
    
    private let baseURL: String
    private let session = URLSession.shared
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let successResponse = 200...299
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func getData<D: Decodable>(from endpoint: any Endpoint, completion: @escaping (Result<D?, Error>) -> Void) {
        do {
            let request = try createRequest(from: endpoint)
            
            let task = session.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if let networkError = self.handleError(response: httpResponse) {
                        completion(.failure(networkError))
                        return
                    }
                }
                
                guard let data = data else {
                    completion(.success(nil))
                    return
                }
                
                do {
                    let decodedObject = try self.decoder.decode(D.self, from: data)
                    completion(.success(decodedObject))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }
}

private extension APIManager {
    
    func handleError(response: HTTPURLResponse) -> Error? {
        if !successResponse.contains(response.statusCode) {
            return APIError.requestError
        }
        return nil
    }

    func createRequest(from endpoint: any Endpoint, contentType: String = "application/json") throws -> URLRequest {
        guard Reachability.isConnectedToNetwork() else {
            throw APIError.noInternetConnection
        }

        guard let urlPath = URL(string: baseURL.appending(endpoint.path)) else {
           throw APIError.invalidPath
        }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        return request
     }
}

