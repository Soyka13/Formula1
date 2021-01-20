//
//  ApiRouter.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 18.01.2021.
//

import Foundation
import Alamofire
import RxSwift

struct Formila1ApiConstants {
    static let baseURL = "https://ergast.com/"
    
    struct Parameters {
        
    }
    
    enum HttpHeaderField: String {
        case contentType = "Content-Type"
        case acceptType = "Accept"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}

enum ApiRouter: URLRequestConvertible {
    
    case getPilots
    
    private var path: String {
        switch self {
        
        case .getPilots:
            return "api/f1/current/last/results.json"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .getPilots:
            return .get
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Formila1ApiConstants.baseURL.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(Formila1ApiConstants.ContentType.json.rawValue, forHTTPHeaderField: Formila1ApiConstants.HttpHeaderField.contentType.rawValue)
        request.setValue(Formila1ApiConstants.ContentType.json.rawValue, forHTTPHeaderField: Formila1ApiConstants.HttpHeaderField.acceptType.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(request, with: nil)
    }
}

class ApiClient {
    
    static func getPilots() -> Observable<MRData> {
        return request(ApiRouter.getPilots)
    }
    
    private static func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
        return Observable.create { (observer) -> Disposable in
            let request = AF.request(urlConvertible).responseDecodable { (response: AFDataResponse<T>) in
                switch response.result {
                case .success(let value):
                    observer.onNext(value)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
