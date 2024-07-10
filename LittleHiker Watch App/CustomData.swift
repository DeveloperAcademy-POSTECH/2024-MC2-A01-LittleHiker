//
//  CustomData.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/10/24.
//

import SwiftData

@Model
class CustomSummaryData {
    var id: String
    var Data: SummaryModel
    
    init(id: String, Data: SummaryModel) {
        self.id = id
        self.Data = Data
    }
}


