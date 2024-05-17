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
                Text("등산 고도")
                Text("04:08:22")
            }
            Divider()
            HStack{
                Text("등반 고도")
                Text("223km ~ 786km")
            }
            Divider()
            HStack{
                Text("평균 속도")
                VStack{
                    HStack{
                        Text("등산평균속도")
                        Text("3km/h")
                    }
                    HStack{
                        Text("하산평균속도")
                        Text("4km/h")
                    }
                }
            }
            Divider()
            HStack{
                Text("평균충격량")
                Text( "XXXXXX ")
            }
        }
        .navigationTitle("2024/05/01")
    }
}

#Preview {
    PhoneDetailView()
}
