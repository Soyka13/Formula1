//
//  PilotModel.swift
//  Formula1
//
//  Created by Olena Stepaniuk on 24.01.2021.
//

import Foundation

struct PilotModel : Decodable {
    private(set) var givenName: String
    private(set) var familyName: String
    private(set) var permanentNumber: String
    private(set) var url: String
    private(set) var raceName: String
    private(set) var season: String
    private(set) var round: String
    private(set) var raceUrl: String
    private(set) var date: String
    private(set) var time: String
    
    init(driver: Pilot, raceName: String, season: String, round: String, raceUrl: String, date: String, time: String) {
        self.raceName = raceName
        self.givenName = driver.givenName
        self.familyName = driver.familyName
        self.permanentNumber = driver.permanentNumber ?? ""
        self.url = driver.url
        self.season = season
        self.round = round
        self.raceUrl = raceUrl
        self.date = date
        self.time = time
    }
    
    init(givenName: String, familyName: String, permanentNumber: String, url: String, raceName: String, season: String, round: String, raceUrl: String, date: String, time: String) {
        self.raceName = raceName
        self.givenName = givenName
        self.familyName = familyName
        self.permanentNumber = permanentNumber
        self.url = url
        self.season = season
        self.round = round
        self.raceUrl = raceUrl
        self.date = date
        self.time = time
    }
    
    init() {
        self.raceName = ""
        self.givenName = ""
        self.familyName = ""
        self.permanentNumber = ""
        self.url = ""
        self.season = ""
        self.round = ""
        self.raceUrl = ""
        self.date = ""
        self.time = ""
    }
 }
