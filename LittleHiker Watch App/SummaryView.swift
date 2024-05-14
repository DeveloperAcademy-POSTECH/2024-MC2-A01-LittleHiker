//
//  ContentView.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI

struct SummaryView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("총 시간")
                Text("5:20:36")
                    .font(.system(size: 32))
                    .foregroundColor(Color(red: 1, green: 0.84, blue: 0.04))
                Divider()
                Text("총 거리")
                HStack (spacing: 0) {
                    Text("6.88")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.35, green: 0.78, blue: 0.98))
                    Text("KM")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.35, green: 0.78, blue: 0.98))
                        .padding(.top)
                }
                
                Divider()
                Text("하산 평균 충격량")
                HStack (spacing: 0) {
                    Text("33")
                        .font(.system(size: 32))
                        .foregroundColor(Color(red: 0.01, green: 0.96, blue: 0.92))
                    Text("J")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.01, green: 0.96, blue: 0.92))
                        .padding(.top)
                }
                Divider()
                Text("abc")
                Text("스크롤을 위해 대충 써봄")
            }
        }
    }
}

#Preview {
    SummaryView()
}
