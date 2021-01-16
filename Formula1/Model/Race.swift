//
//  Race.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 16.01.2021.
//

import Foundation

struct Result: Decodable {
    let Driver: Driver
}

struct Race: Decodable {
    let raceName: String
    let Results: [Result]
}

struct RaceTable: Decodable {
    let Races: [Race]
}

struct MRData: Decodable {
    let RaceTable: RaceTable
}
