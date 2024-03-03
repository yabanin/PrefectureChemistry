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
    
    @State private var showingWarning = false
    
    var body: some View {
        VStack {
            Text("あなたと相性のいい都道府県を占う！").font(.title)
            if showingWarning {
                Text("名前を入力してください").foregroundColor(.red)
            }
            Text("○ 名前").frame(maxWidth: .infinity, alignment: .leading)
            TextField("例：ゆめみん", text: $name)
            Text("○ 誕生日").frame(maxWidth: .infinity, alignment: .leading)
            DatePicker(
                "誕生日",
                selection: $birthday,
                displayedComponents: [.date]
            ).datePickerStyle(.wheel)
            .environment(\.locale, Locale(identifier: "ja_JP"))
            .labelsHidden()
            Text("○ 血液型").frame(maxWidth: .infinity, alignment: .leading)
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
                if let prefecture = prefectureFetcher.prefecture {
                    ResultView(prefecture: prefecture)
                }
            }
        }.padding()
    }
    
    func convertYearMonthDay(from: Date) -> YearMonthDay {
        let calendar = Calendar(identifier: .gregorian)
        let date = Date()
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day , from: date)
        
        return YearMonthDay(year: year, month: month, day: day)
    }
    
    func tellPrefecture() {
        if name.count == 0 {
            showingWarning = true
            
            return
        } else {
            showingSheet = false
        }
        
        let birthdayYearMonthDay = convertYearMonthDay(from: birthday)
        
        let todayYearMonthDay = convertYearMonthDay(from: Date())
        
        let person = PersonalInfo(name: name, birthday: birthdayYearMonthDay, blood_type: userBloodType, today: todayYearMonthDay)
        
        
        prefectureFetcher.postPersonalInfo(person: person)
        showingSheet.toggle()
    }
    
    
}

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
            if let error = error {                print("Error: \(error.localizedDescription)")
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

#Preview {
    ContentView()
}
