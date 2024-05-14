//
//  ContentView.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI

struct WatchDetailView: View {
    var body: some View {
        ScrollView{
            HStack {
                VStack(alignment: .leading) {
                    Text("00:58:30")
                        .font(.system(size: 32))
                        .foregroundColor(Color.yellow)
                        .frame(height: 30)
                    
                    
                    
                    HStack (spacing: 0) {
                        Text("80")
                            .font(.system(size: 32))

                        VStack(alignment: .leading){
                            Text("심박수")
                            Text("")
                        }
                        .font(.system(size: 12))
                        .padding(.horizontal)
                    }
                    .frame(height: 30)
                    
   
                    
                    HStack (spacing: 0) {
                        Text("4")
                            .font(.system(size: 32))
                        
                        VStack{
                            Spacer(minLength: 1)
                            Text("km/h")
                                .font(.system(size: 18))
                        }
                        VStack(alignment: .leading){
                            Text("현재")
                            Text("페이스")
                        }
                        .font(.system(size: 12))
                        .padding(.horizontal)
                    }
                    .frame(height: 30)

                    
                    HStack (spacing: 0) {
                        Text("897")
                            .font(.system(size: 32))
                        
                        VStack{
                            Spacer(minLength: 1)
                            Text("M")
                                .font(.system(size: 18))
                        }
                        VStack(alignment: .leading){
                            Text("등반")
                            Text("고도")
                        }
                        .font(.system(size: 12))
                        .padding(.horizontal)
                    }
                    .frame(height: 30)
                    
                    
                    
                    
                    
                    HStack (spacing: 0) {
                        Text("2.21")
                            .font(.system(size: 32))
                        VStack{
                            Spacer(minLength: 1)
                            Text("km")
                                .font(.system(size: 18))
                        }
                        VStack(alignment: .leading){
                            Text("총")
                            Text("거리")
                        }
                        .font(.system(size: 12))
                        .padding(.horizontal)
                    }
                    .frame(height: 30)

                }
                Spacer()
            }
        }
    }
}

#Preview {
    WatchDetailView()
}
