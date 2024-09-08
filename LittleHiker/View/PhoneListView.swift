//
//  PhoneListView.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/16/24.
//

import SwiftUI

//hikingRecord에 대한 List
struct PhoneListView: View {
    @StateObject var iosToWatch = IOSToWatchConnector()
    
    var body: some View {
        NavigationStack{
            //TODO: 테스트용 출력
            Text("ID")
            Text(iosToWatch.id)
            Text("BODY")
            Text(iosToWatch.body)
//            List{
//                //TODO: ForEach hikingRecord
//                NavigationLink{
//                    PhoneDetailView()
//                } label: {
//                    PhoneRowView()
//                }
//            }
//            .navigationBarTitle("Little Hiker🐿️")
        }
        .onAppear{
            //MARK: 통신 1. UUID 조회요청 잠시꺼둠
//            IOSToWatchConnector().sendDataToWatch(Method.get)
        }
    }
}

#Preview {
    PhoneListView()
}
