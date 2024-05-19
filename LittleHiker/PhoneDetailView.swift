//
//  PhoneDetailView.swift
//  LittleHiker
//
//  Created by Hyungeol Lee on 5/17/24.
//

import SwiftUI

struct PhoneDetailView: View {
    var body: some View {
        ScrollView {
            HStack{
                Text("산행 시간")
                    .bold()
                    .frame(width: 150)
                Text("04:08:22")
                    .frame(width: 250, alignment: .leading)
            }
            Divider()
            HStack{
                Text("등반 고도")
                    .bold()
                    .frame(width: 150)
                Text("223km ~ 786km")
                    .frame(width: 250, alignment:
                            .leading)
            }
            Divider()
            HStack{
                Text("평균 속도")
                    .bold()
                    .frame(width: 150)
                VStack{
                    HStack{
                        Text("등산평균속도")
                        Text("3km/h")
                    }
                    HStack{
                        Text("하산평균속도")
                        Text("4km/h")
                    }
                }.frame(width: 250, alignment: .leading)
            }
            Divider()
            HStack{
                Text("평균충격량")
                    .bold()
                    .frame(width: 150)
                Text( "XXXXXX ")
                    .frame(width: 250, alignment: .leading)
            }
        }
        .navigationTitle("2024/05/01")
    }
}

#Preview {
    PhoneDetailView()
}
