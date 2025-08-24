//
//  MockAPIManager.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 24.08.2025.
//

class MockAPIManager: APIManagerProtocol {
    
    // MARK: - Type Properties

    static var shared = MockAPIManager()
    
    // MARK: - Internal Properties
    
    var getDataCalled = false
    var endpointPassed: ToDoListEndpoint?
    var resultToReturn: Result<ToDoListDTO?, Error> = .success(nil)
    
    // MARK: - Intenal Methods
    
    func getData<D>(from endpoint: any Endpoint, completion: @escaping (Result<D?, any Error>) -> Void) where D : Decodable {
        getDataCalled = true
        endpointPassed = endpoint as? ToDoListEndpoint
        switch resultToReturn {
        case .success(let todoDTO):
            if let converted = todoDTO as? D {
                completion(.success(converted))
            } else {
                completion(.success(nil))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
