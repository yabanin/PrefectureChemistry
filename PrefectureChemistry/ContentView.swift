//
//  ContentView.swift
//  PrefectureChemistry
//
//  Created by Ryo Hanma on 2024/02/26.
//

import SwiftUI

struct YearMonthDay: Codable {
    let year: Int
    let month: Int
    let day: Int
}

struct PersonalInfo: Codable {
    let name: String
    let birthday: YearMonthDay
    let blood_type: String
    let today: YearMonthDay
    
}

struct ContentView: View {
    @ObservedObject var prefectureFetcher = PrefectureFetcher()
    
    let bloodTypes = ["a", "b", "ab", "o"]
    
    @State private var name = ""
    @State private var birthday = Date()
    @State private var userBloodType = "a"
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            Text("名前と誕生日、血液型を入力して占う！")
            TextField("名前", text: $name)
            DatePicker(
                "誕生日",
                selection: $birthday,
                displayedComponents: [.date]
            )
            .environment(\.locale, Locale(identifier: "ja_JP"))
            Picker(selection: $userBloodType) {
                Text("A型").tag("a")
                Text("B型").tag("b")
                Text("AB型").tag("ab")
                Text("0型").tag("o")
            } label: {
                Text("血液型")
            }
            
            Button(action: {tellPrefecture()}, label: {
                Text("診断する")
            }).buttonStyle(.borderedProminent)
            .sheet(isPresented: $showingSheet) {
                ResultView(prefecture: prefectureFetcher.prefecture)
                        }
        }.padding()
    }
    
    func convertYeerMonthDay(date: Date) -> YearMonthDay {
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.year, from: date)
        let day = calendar.component(.day , from: date)
        
        return YearMonthDay(year: year, month: month, day: day)
    }
    
    func setPersonalInfo() -> PersonalInfo {
        let birthdayYearMonthDay = convertYeerMonthDay(date: birthday)
        
        let todayYearMonthDay = convertYeerMonthDay(date: Date())
        
        let person = PersonalInfo(name: name, birthday: birthdayYearMonthDay, blood_type: userBloodType, today: todayYearMonthDay)
        
        return person
    }
    
    func tellPrefecture() {
        let person = setPersonalInfo()
        prefectureFetcher.encodePersonalInfo(person: person)
        prefectureFetcher.postPersonalInfo()
    }
}

class PrefectureFetcher: ObservableObject {
    @Published var prefecture = [Prefecture]()
    var jsonString: String = ""
    
    func encodePersonalInfo(person: PersonalInfo) {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(person)
            if String(data: jsonData, encoding: .utf8) != nil {
            }
        } catch {
            print("Failed to encode: \(error)")
        }
    }
    
    func postPersonalInfo() {
        guard var url = URL(string: "https://yumemi-ios-junior-engineer-codecheck.app.swift.cloud/my_fortune") else {
            print("Invalid URL")
            return
        }
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonString) else {
            print("Error converting JSON to Data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = ["API-Version": "v1"]
        request.httpBody = jsonData
        
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
                    print(prefecture)
                }
            } catch let error {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
