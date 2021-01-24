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
    
    case getPilotsWinnersInSeason(year: String)
    
    case getPilotsWinnersInSeasonInRound(year: String, round: String)
    
    case getPilotsInSeasonInRound(year: String, round: String)
    
    case getPilotsInSeason(year: String)
    
    private var path: String {
        switch self {
        case .getPilotsWinnersInSeason(year: let year):
            return "api/f1/\(year)/results/1.json"
        case .getPilotsWinnersInSeasonInRound(year: let year, round: let round):
            return "api/f1/\(year)/\(round)/results/1.json"
        case .getPilotsInSeason(year: let year):
            return "api/f1/\(year)/results.json"
        case .getPilotsInSeasonInRound(year: let year, round: let round):
            return "api/f1/\(year)/\(round)/results.json"
        }
        
    }
    
    private var method: HTTPMethod {
        switch self {
        default:
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
