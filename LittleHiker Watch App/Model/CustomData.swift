//
//  CustomData.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/10/24.
//

import SwiftData

@Model
class CustomComplementaryHikingData: Encodable {
    var id: String
    var data: SummaryModel
    
    init() {
        self.id = ""
        self.data = SummaryModel()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(data, forKey: .data)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case data
    }
}


@Model
class LogsWithTimeStamps: Encodable {
    var id: String
    var logs: [String: String] //key가 시간, value가 충격량
    
    init() {
        self.id = ""
        self.logs = [:]
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(logs, forKey: .logs)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case logs
    }
}
