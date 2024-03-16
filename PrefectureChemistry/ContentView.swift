//
//  ContentView.swift
//  PrefectureChemistry
//
//  Created by Ryo Hanma on 2024/02/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var prefectureFetcher = PrefectureFetcher()
    
    //let bloodTypes = ["a", "b", "ab", "o"]
    
    @State private var name = ""
    @State private var birthday = Date()
    @State private var userBloodType = "a"
    
    @State private var isShowingSheet = false
    
    @State private var shouldShowingWarning = false
    
    var body: some View {
        VStack {
            Text("あなたと相性のいい都道府県を占う！").font(.title)
            if shouldShowingWarning {
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
            .sheet(isPresented: $isShowingSheet) {
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
            shouldShowingWarning = true
            
            return
        } else {
            isShowingSheet = false
        }
        
        let birthdayYearMonthDay = convertYearMonthDay(from: birthday)
        
        let todayYearMonthDay = convertYearMonthDay(from: Date())
        
        let person = PersonalInfo(name: name, birthday: birthdayYearMonthDay, blood_type: userBloodType, today: todayYearMonthDay)
        
        
        prefectureFetcher.postPersonalInfo(person: person)
        isShowingSheet.toggle()
    }
}

#Preview {
    ContentView()
}
