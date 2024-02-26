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
    let Day: Int
}

struct PersonalInfo: Codable {
    let name: String
    let birthday: YearMonthDay
    let blood_type: String
    let today: YearMonthDay
    
}

struct ContentView: View {
    let bloodTypes = ["a", "b", "ab", "o"]
    
    @State private var name = ""
    @State private var date = Date()
    @State private var userBloodType = "a"
    
    var body: some View {
        VStack {
            Text("名前と誕生日、血液型を入力して占う！")
            TextField("名前", text: $name)
            DatePicker(
                "誕生日",
                selection: $date,
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
            
            Button(action: {}, label: {
                Text("診断する")
            }).buttonStyle(.borderedProminent)
        }.padding()
    }
}

#Preview {
    ContentView()
}
