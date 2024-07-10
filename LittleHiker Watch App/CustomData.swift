//
//  CustomData.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/10/24.
//

import SwiftData

@Model
class CustomComplementaryHikingData {
    var id: String
    var data: SummaryModel
    
    init() {
        self.id = ""
        self.data = SummaryModel()
    }
}


@Model
class LogsWithTimeStamps {
    var id: String
    var logs: [String: String]
    
    init() {
        self.id = ""
        self.logs = [:]
    }
}
