//
//  LemonCapstoneApp.swift
//  LemonCapstone
//
//  Created by Geovani Mendoza on 29/5/26.
//

import SwiftUI
import CoreData

@main
struct LemonCapstoneApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Onboarding()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
