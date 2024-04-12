//
//  About.swift
//  Keeper2
//
//  Created by 杨寿来 on 2024/4/2.
//

import SwiftUI
struct About: View {
    
    let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Unknown"
    let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
    
    var body: some View {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 8){
            
            Image("Icon", bundle: Bundle.main)
                .resizable()
                .renderingMode(.original)
                .frame(width:80, height: 80)
                .scaledToFill()
            
            VStack(alignment: .leading, spacing: 8){
                HStack(alignment: .bottom){
                    Text("\(appName)")
                        .font(.title)
                        .fontWeight(.medium)
                    Text(appVersion).font(.callout)
                }
                Text("一款实现防休眠功能的小工具，由开发者 [yangshoulai](https://github.com/yangshoulai) 开发。")
                    .multilineTextAlignment(.leading)
                    .lineSpacing(6)
            }
        }.padding().frame(width: 360)
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
