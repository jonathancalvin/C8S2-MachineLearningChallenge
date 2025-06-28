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
    @State private var currentPage = 0

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    if currentPage < 2 {
                        OnboardingViewWithIndicator(currentPage: $currentPage)
                            .environmentObject(alertViewModel)
                    } else {
                        ScanView()
                            .environmentObject(alertViewModel)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
