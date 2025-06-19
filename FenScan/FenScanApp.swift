//
//  FenScanApp.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 13/06/25.
//

import SwiftUI

@main
struct FenScanApp: App {
    @StateObject var alertViewModel = AlertViewModel()
    var body: some Scene {
        
        WindowGroup {
            NavigationStack {
                onboardingViewWithIndicator()
                    .environmentObject(alertViewModel)
                    .ignoresSafeArea(edges: .all)
            }
      
        }
    }
}
