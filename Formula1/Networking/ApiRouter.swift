//
//  ApiRouter.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 18.01.2021.
//

import Foundation
import Alamofire
import RxSwift

struct Formula1ApiConstants {
    static let baseURL = "https://ergast.com/"
    
    struct Parameters {
        static let limit = "limit"
        static let offset = "offset"
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
    
    case getPilotsWinnersInSeason(year: String, limit: Int = 1000, offset: Int = 0)
    
    case getPilotsWinnersInSeasonInRound(year: String, round: String, limit: Int = 1000, offset: Int = 0)
    
    case getPilotsInSeasonInRound(year: String, round: String, limit: Int = 1000, offset: Int = 0)
    
    case getPilotsInSeason(year: String, limit: Int = 1000, offset: Int = 0)
    
    case getSeasonList(limit: Int = 1000, offset: Int = 0)
    
    private var path: String {
        switch self {
        case .getPilotsWinnersInSeason(year: let year, limit: _, offset: _):
            return "api/f1/\(year)/results/1.json"
        case .getPilotsWinnersInSeasonInRound(year: let year, round: let round, limit: _, offset: _):
            return "api/f1/\(year)/\(round)/results/1.json"
        case .getPilotsInSeason(year: let year, limit: _, offset: _):
            return "api/f1/\(year)/results.json"
        case .getPilotsInSeasonInRound(year: let year, round: let round, limit: _, offset: _):
            return "api/f1/\(year)/\(round)/results.json"
        case .getSeasonList(limit: _, offset: _):
            return "api/f1/seasons.json"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    private var parameters: Parameters? {
        switch self {
        
        case .getPilotsWinnersInSeason(year: _, limit: let limit, offset: let offset):
            return [Formula1ApiConstants.Parameters.limit : limit, Formula1ApiConstants.Parameters.offset: offset]
        case .getPilotsWinnersInSeasonInRound(year: _, round: _, limit: let limit, offset: let offset):
            return [Formula1ApiConstants.Parameters.limit : limit, Formula1ApiConstants.Parameters.offset: offset]
        case .getPilotsInSeasonInRound(year: _, round: _, limit: let limit, offset: let offset):
            return [Formula1ApiConstants.Parameters.limit : limit, Formula1ApiConstants.Parameters.offset: offset]
        case .getPilotsInSeason(year: _, limit: let limit, offset: let offset):
            return [Formula1ApiConstants.Parameters.limit : limit, Formula1ApiConstants.Parameters.offset: offset]
        case .getSeasonList(limit: let limit, offset: let offset):
            return [Formula1ApiConstants.Parameters.limit : limit, Formula1ApiConstants.Parameters.offset: offset]
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
