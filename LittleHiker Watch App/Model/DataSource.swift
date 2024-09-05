//
//  DataSource.swift
//  LittleHiker Watch App
//
//  Created by Lyosha's MacBook   on 7/10/24.
//

import SwiftData

@MainActor
final class DataSource {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    static let shared = DataSource()
    
    private init() {
        self.modelContainer = try! ModelContainer(for: CustomComplementaryHikingData.self, LogsWithTimeStamps.self)
        self.modelContext = modelContainer.mainContext
    }
    
    /// 데이터 저장 함수
    func saveItem<T: PersistentModel>(_ item: T) {
        modelContext.insert(item)
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchCustomComplementaryHikingData() -> [CustomComplementaryHikingData] {
        do {
            return try modelContext.fetch(FetchDescriptor<CustomComplementaryHikingData>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func fetchLogsWithTimeStamps() -> [LogsWithTimeStamps] {
        do {
            return try modelContext.fetch(FetchDescriptor<LogsWithTimeStamps>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
 
//    func removeItem(_ item: Item) {
//        modelContext.delete(item)
//    }
    
    
}
