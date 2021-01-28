//
//  Formula1Model.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 24.01.2021.
//

import Foundation

struct Pilot: Decodable {
    var permanentNumber: String?
    var givenName: String
    var familyName: String
    var url: String
}

struct PilotTime: Decodable {
    let time: String
    let millis: String
}

struct RaceResult: Decodable {
    let Driver: Pilot
    let Time: PilotTime?
}

struct Race: Decodable {
    let raceName: String
    let season: String
    let round: String
    let url: String
    let date: String
    let Results: [RaceResult]
    
    func getPilotsDataModel() -> [PilotModel] {
        return Results.compactMap({
            PilotModel(driver: $0.Driver, raceName: raceName, season: season, round: round, raceUrl: url, date: date, time: $0.Time?.time ?? "")
        })
    }
}

struct RaceTable: Decodable {
    let Races: [Race]
}

struct RData: Decodable {
    let RaceTable: RaceTable
    let total: String
}

struct Season: Decodable {
    let season: String
}

struct SeasonTable: Decodable {
    let Seasons: [Season]
}

struct SData: Decodable {
    let SeasonTable: SeasonTable
    let total: String
}

struct MRData<T: Decodable>: Decodable {
    let MRData: T
}
