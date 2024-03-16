//
//  PrefectureModel.swift
//  PrefectureChemistry
//
//  Created by Ryo Hanma on 2024/03/17.
//

import Foundation

class Prefecture: Codable {
    let name: String
    let capital: String
    let citizen_day: MonthDay?
    let has_coast_line: Bool
    let logo_url: String
    let brief: String
}

class MonthDay: Codable {
    let month: Int
    let day: Int
}
