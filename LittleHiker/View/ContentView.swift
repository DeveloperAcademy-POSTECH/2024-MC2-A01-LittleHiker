//
//  ContentView.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModelIPhone()
    
    var body: some View {
        ScrollView {
            VStack {
                Text("여기 밑에 Array가 뜰 것임 테스트용")
                //TODO: - WatchOS에서 전달받은 데이터가 여기 바로 뜨면 됨!
                Text(self.model.message)
                    .font(.system(size: 8))
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
