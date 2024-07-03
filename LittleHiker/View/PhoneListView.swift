//
//  PhoneListView.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/16/24.
//

import SwiftUI

//hikingRecord에 대한 List
struct PhoneListView: View {
    var body: some View {
        NavigationStack{
            List{
                //TODO: ForEach hikingRecord
                NavigationLink{
                    PhoneDetailView()
                } label: {
                    PhoneRowView()
                }
            }
            .navigationBarTitle("Little Hiker🐿️")
        }
    }
}

#Preview {
    PhoneListView()
}
