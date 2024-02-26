//
//  ResultView.swift
//  PrefectureChemistry
//
//  Created by Ryo Hanma on 2024/02/26.
//

import SwiftUI

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

class PrefectureFetcher: ObservableObject {}

struct ResultView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ResultView()
}
