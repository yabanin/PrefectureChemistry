//
//  PrefectureFetcher.swift
//  PrefectureChemistry
//
//  Created by Ryo Hanma on 2024/03/17.
//

import Foundation

class PrefectureFetcher: ObservableObject {
    @Published var prefecture: Prefecture?
    
    func postPersonalInfo(person: PersonalInfo) {
        guard let url = URL(string: "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud/my_fortune") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["API-Version": "v1"]
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let encodeData = try encoder.encode(person)
            request.httpBody = encodeData
        } catch {
            print("Failed to encode: \(error)")
        }
        
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
                let decodedData = try decoder.decode(Prefecture.self, from: data)
                DispatchQueue.main.async {
                    self.prefecture = decodedData
                    print(self.prefecture!)
                    
                }
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}
