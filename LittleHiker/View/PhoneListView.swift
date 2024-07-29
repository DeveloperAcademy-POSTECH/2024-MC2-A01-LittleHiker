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
            Text("BODY2222")
            Text(iosToWatch.body)
            List(iosToWatch.resultArray.keys.sorted(), id: \.self) { key in
                HStack {
                    Text(key)
                        .font(.headline)
                    Spacer()
                    if let value = iosToWatch.resultArray[key] as? String {
                        Text(value)
                            .font(.subheadline)
                    } else if let value = iosToWatch.resultArray[key] as? Int {
                        Text("\(value)")
                            .font(.subheadline)
                    } else if let value = iosToWatch.resultArray[key] as? Double {
                        Text(String(format: "%.2f", value))
                            .font(.subheadline)
                    } else {
                        Text("Unknown type")
                            .font(.subheadline)
                    }
                }
            }
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
