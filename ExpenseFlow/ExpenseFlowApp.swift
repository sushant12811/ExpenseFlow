//
//  ExpenseTracker_IOSApp.swift
//  ExpenseTracker-IOS
//
//  Created by Sushant Dhakal on 2025-10-17.
//

import SwiftUI
import SwiftData

@main
struct ExpenseFlowApp: App {
    var body: some Scene {
        WindowGroup {
        ContentView()
                .tint(.primary)

           }
              .modelContainer(for: ExpenseModel.self)

              
          }
        }

