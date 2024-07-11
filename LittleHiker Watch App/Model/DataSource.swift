//
//  DataSource.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/10/24.
//

import SwiftData

final class DataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = DataSource()
    
    @MainActor
    private init() {
        self.modelContainer = try! ModelContainer(for: CustomComplementaryHikingData.self, LogsWithTimeStamps.self)
        self.modelContext = modelContainer.mainContext
    }
    
    func appendCustomComplementaryHikingData(item: CustomComplementaryHikingData) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func appendLogsWithTimeStamps(item: LogsWithTimeStamps) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
//    func fetchItems() -> [Item] {
//        do {
//            return try modelContext.fetch(FetchDescriptor<Item>())
//        } catch {
//            fatalError(error.localizedDescription)
//        }
//    }
//    
//    func removeItem(_ item: Item) {
//        modelContext.delete(item)
//    }
    
    
}
