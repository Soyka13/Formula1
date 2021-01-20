//
//  APIClient.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 17.01.2021.
//

import Foundation
import RxSwift

//public enum RequestType: String {
//    case GET
//}
//
//protocol APIRequest {
//    var method: RequestType { get }
//    var path: String { get }
//    var parameters: [String : String] { get }
//}
//
//extension APIRequest {
//    func request(with baseURL: URL) -> URLRequest {
//        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
//            fatalError("Unable to create URL components")
//        }
//        
//        components.queryItems = parameters.map({ URLQueryItem(name: String($0), value: String($1))
//        })
//        
//        guard let url = components.url else {
//            fatalError("Could not get url")
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = method.rawValue
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        return request
//    }
//}
//
//class DriversInfoRequest: APIRequest {
//    var method: RequestType = .GET
//    var path: String = "api/f1/current/last/results.json"
//    var parameters = [String : String]()
//    
//    init() {
//        
//    }
//}
//
//class APIClient {
//    private let baseURL = URL(string: "http://ergast.com/")!
//    
//    func send<T: Decodable>(apiRequest: APIRequest) -> Observable<T> {
//        return Observable<T>.create { [unowned self] (observer) -> Disposable in
//            let request = apiRequest.request(with: self.baseURL)
//            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//                do {
//                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
//                    observer.onNext(model)
//                } catch let error {
//                    observer.onError(error)
//                }
//                
//                observer.onCompleted()
//            }
//            task.resume()
//            
//            return Disposables.create {
//                task.cancel()
//            }
//        }
//    }
//}
