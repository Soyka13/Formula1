//
//  APIClient.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 17.01.2021.
//

import Foundation
import Alamofire
import RxSwift

class ApiClient {
    
    public static func request<T: Decodable>(
        _ urlConvertible: URLRequestConvertible,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        AF.request(urlConvertible).responseData { (response) in
            
            let decoder = JSONDecoder()
            
            switch response.result {
            
            case .success(let data):
                if let json = try? decoder.decode(T.self, from: data) {
                    completion(.success(json))
                } else {
                    completion(.failure(.parseJSONError))
                }
            case .failure(let error):
                completion(.failure(.getDataError(message: error.localizedDescription)))
            }
        }
    }
}
