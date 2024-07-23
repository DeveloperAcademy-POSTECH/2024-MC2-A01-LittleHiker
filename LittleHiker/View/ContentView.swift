//
//  ContentView.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var messsageText = "2.9"
    
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
            Text("다람이와 함께하는 등산 Life")
        }
        
    }
}

#Preview {
    ContentView()
}
