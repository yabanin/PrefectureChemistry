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

struct ResultView: View {
    let prefecture: Prefecture
    @State var image: UIImage?
    
    var body: some View {
         ScrollView {
            Text("相性のいい都道府県は...")
            Text(prefecture.name).font(.largeTitle)
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
            }
            HStack {
                Text("県庁所在地")
                Text(prefecture.capital)
            }
             if let citizen_day = prefecture.citizen_day {
                 HStack {
                     Text("県民の日")
                     Text("\(citizen_day.month)月\(citizen_day.day)")
                 }
             }
            if prefecture.has_coast_line {
                Text("海あり県")
            } else {
                Text("海なし県")
            }
            Text(prefecture.brief)
        }.onAppear {
            let url = prefecture.logo_url
            downloadImageAsync(url: URL(string: url)!) { image in
                self.image = image
            }
        }
    }
    
    func downloadImageAsync(url: URL, completion: @escaping (UIImage?) -> Void) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, _, _) in
            var image: UIImage?
            if let imageData = data {
                image = UIImage(data: imageData)
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}


let jsonSamplePrefecture = """
{
    "name": "富山県",
    "has_coast_line": true,
    "citizen_day": {
        "month": 5,
        "day": 9
    },
    "capital": "富山市",
    "logo_url": "https://japan-map.com/wp-content/uploads/toyama.png"
    "brief": "富山県（とやまけん）は、日本の中部地方に位置する県。県庁所在地は富山市。\n中部地方の日本海側、新潟県を含めた場合の北陸地方のほぼ中央にある。\n※出典: フリー百科事典『ウィキペディア（Wikipedia）』",
}
""".data(using: .utf8)!

