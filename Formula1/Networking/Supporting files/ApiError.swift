//
//  ApiError.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 24.01.2021.
//

import Foundation

enum ApiError: Error {
    case getDataError(message: String)
    case parseJSONError
}
