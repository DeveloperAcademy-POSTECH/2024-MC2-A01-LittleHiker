//
//  PhoneListView.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/16/24.
//

import SwiftUI
import SwiftData

//hikingRecord에 대한 List
struct PhoneListView: View {
    @StateObject var iosToWatch = IOSToWatchConnector()
    @Environment(\.modelContext) private var modelContext
    @Query private var records: [HikingRecord]
    
    //추후 검색용 텍스트
    @State var text: String = ""
    
    var body: some View {
        NavigationStack{
            ZStack{
                if records.count == 0 { //데이터가 없을 때 보여질 뷰
                    VStack {
                        Spacer()
                        Image("NoDataSquirrel")
                            .resizable()
                            .frame(width: 128, height: 128)
                        Text("아직 산행 기록이 없네요!\n지금부터 첫 산행을 기록해 보세요")
                            .font(.custom("Moneygraphy-Rounded", size: 16))
                            .fontWeight(.regular)
                            .multilineTextAlignment(.center)
                            .padding(.top, 16)
                        Spacer()
                    }
                }
                VStack{
                    VStack {
                        HStack {
                            Text("산행기록")
                                .font(.system(size: 34, weight: .bold))
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 7)
                            TextField("Search", text: $text)
                                .padding(7)
                                .cornerRadius(8)
                        }
                        .background(Color(.systemGray5))
                        .cornerRadius(10)
                    }
                    
                    
                    List {
                        ForEach(records) { record in
                            NavigationLink(destination: PhoneDetailView(record: record)) {
                                PhoneRowView(record: record)
                                    .swipeActions(edge: .trailing) {
                                        Button(action: {
                                            deleteRecord(record: record)
                                        }) {
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                    }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
    }
    
    
    private func deleteRecord(record: HikingRecord) {
        withAnimation {
            modelContext.delete(record)
        }
        // TODO: healthKit 기록도 지울 것인지 action sheet로 확인 필요
    }
    
}
