//
//  PhoneRowView.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/16/24.
//

import SwiftUI

struct PhoneRowView: View {
    var record: HikingRecord
    
    var body: some View {
        VStack{
            HStack{
                Text("\(record.title)")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
            }
            HStack{
                Text("\(record.formattedEndDateTime)")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.gray)
                Spacer()
            }
        }
    }
}

//#Preview {
//    PhoneRowView()
//}
