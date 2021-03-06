//
//  ApiRouter.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 18.01.2021.
//

import Foundation
import Alamofire

protocol Requestable: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

struct Formula1ApiConstants {
    static let baseURL = "https://ergast.com/"
    
    enum Parameters: String {
        case limit = "limit"
        case offset = "offset"
    }
    
    enum HttpHeaderField: String {
        case contentType = "Content-Type"
        case acceptType = "Accept"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
}

enum Request: Requestable {
    
    case getPilotsInSeasonInRound(year: String, round: String)
    
    case getPilotsInSeason(year: String)
    
    case getSeasonList
    
    case getPilotsInSeasonOnPosition(year: String, position: String)
    
    var path: String {
        switch self {
        case .getPilotsInSeason(year: let year):
            return "api/f1/\(year)/results.json"
        case .getPilotsInSeasonInRound(year: let year, round: let round):
            return "api/f1/\(year)/\(round)/results.json"
        case .getSeasonList:
            return "api/f1/seasons.json"
        case .getPilotsInSeasonOnPosition(year: let year, position: let position):
            return "api/f1/\(year)/results/\(position).json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        
        default:
            return [Formula1ApiConstants.Parameters.limit.rawValue : 1000, Formula1ApiConstants.Parameters.offset.rawValue: 0]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Formula1ApiConstants.baseURL.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.setValue(Formula1ApiConstants.ContentType.json.rawValue, forHTTPHeaderField: Formula1ApiConstants.HttpHeaderField.contentType.rawValue)
        request.setValue(Formula1ApiConstants.ContentType.json.rawValue, forHTTPHeaderField: Formula1ApiConstants.HttpHeaderField.acceptType.rawValue)
        
        let encoding: ParameterEncoding = {
            switch method {
            case .get:
                return URLEncoding.default
            default:
                return JSONEncoding.default
            }
        }()
        
        return try encoding.encode(request, with: parameters)
    }
}
