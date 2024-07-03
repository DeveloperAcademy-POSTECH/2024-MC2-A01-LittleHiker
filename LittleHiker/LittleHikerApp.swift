//
//  LittleHikerApp.swift
//  LittleHiker
//
//  Created by Lyosha's MacBook   on 5/13/24.
//

import SwiftUI
import SwiftData

@main
struct LittleHikerApp: App {
    var modelContainer: ModelContainer = {
        let schema = Schema([HikingRecord.self, HikingLog.self])
        // TODO: - CloudKit을 사용하게 되면 여기에서 cloudKitDatabase 옵션을 추가해줘야 함
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            PhoneListView()
                .modelContainer(modelContainer)
        }
    }
}
