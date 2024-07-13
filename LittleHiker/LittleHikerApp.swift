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
