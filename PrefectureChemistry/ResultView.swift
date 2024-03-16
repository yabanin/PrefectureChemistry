//
//  ResultView.swift
//  PrefectureChemistry
//
//  Created by Ryo Hanma on 2024/02/26.
//

import SwiftUI

struct ResultView: View {
    let prefecture: Prefecture
    let result = Result()
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
            result.downloadImageAsync(url: URL(string: url)!) { image in
                self.image = image
            }
        }
    }
    
}

class Result {
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
