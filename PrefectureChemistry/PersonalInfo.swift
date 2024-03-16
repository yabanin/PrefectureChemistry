//
//  PersonalInfo.swift
//  PrefectureChemistry
//
//  Created by Ryo Hanma on 2024/03/17.
//

import Foundation

struct PersonalInfo: Codable {
    let name: String
    let birthday: YearMonthDay
    let blood_type: String
    let today: YearMonthDay
    
}

struct YearMonthDay: Codable {
    let year: Int
    let month: Int
    let day: Int
}
