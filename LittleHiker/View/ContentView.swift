//
//  ContentView.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model = ViewModelIPhone()
    @State var messsageText = "2.7"
    
    var body: some View {
        ScrollView {
            VStack {
                Text("여기 밑에 Array가 뜰 것임 테스트용")
                Text("현재충격량:" + self.messsageText)
                Text(self.model.message)
                    .font(.system(size: 8))
                //충격량 입력받기
                TextField("충격량을 입력해주세요", text: $messsageText)
                Button {
                    self.model.session.sendMessage(["message" : self.messsageText], replyHandler: nil) { error in
                        /**
                         다음의 상황에서 오류가 발생할 수 있음
                         -> property-list 데이터 타입이 아닐 때
                         -> watchOS가 reachable 상태가 아닌데 전송할 때
                         */
                        print(error.localizedDescription)
                    }
                } label: {
                    Text("Send Message")
                }.border(Color.black)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
