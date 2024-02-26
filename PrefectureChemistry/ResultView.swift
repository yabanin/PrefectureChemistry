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

class PrefectureFetcher: ObservableObject {
    @Published var personalInfo = PersonalInfo()
    @Published var prefecture = [Prefecture]()
    
    init() {
        guard var url = URLComponents(string: "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud/my_fortune") else {
            print("Invalid URL")
            return
        }
        
        url.queryItems = [
            URLQueryItem(name: "email", value: "hoge@hoge.com"),
            URLQueryItem(name: "username", value: "hogehoge")         //クエリを追加したければ、ここに書いていく
        ]
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // headerを付与
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["API-Version": "v1"]
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("Invalid data")
                return
            }

            do {
                let decoder = JSONDecoder()
                let prefecture = try decoder.decode([Prefecture].self, from: data)
                DispatchQueue.main.async {
                    self.prefecture = prefecture
                }
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

struct ResultView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ResultView()
}
