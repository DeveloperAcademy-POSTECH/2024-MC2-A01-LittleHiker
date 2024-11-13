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
    //리스트 그리기 샘플데이터
    @Query private var records: [HikingRecord]
    
    //추후 검색용 텍스트
    @State var text: String = ""
    
    var body: some View {
        NavigationStack{
            VStack {
                HStack {
                    //TODO: 테스트용 출력
                    Text("BODY2222")
                    Text(iosToWatch.body)
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
            if !records.isEmpty {
                List {
                    ForEach(records) { record in
                        NavigationLink(destination: PhoneDetailView(record: record)) {
                            
                            PhoneRowView(record: record)
                                .swipeActions(edge: .trailing) {
                                    Button(action: {
                                        // Edit action
                                        //                                    editRecord(at: index)
                                    }) {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                    
                                    Button(action: {
                                        // Delete action
//                                        deleteRecord(at: index)
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

private func editRecord(at index: Int) {
    // 편집 액션 수행
    //        print("Edit \(records[index].title)")
}

private func deleteRecord(at index: Int) {
    // 삭제 액션 수행
    //        records.remove(at: index)
}

//#Preview {
//    PhoneListView()
//}
