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
    @State private var currentPage = AppPageEnum.landing

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                Group {
                    switch currentPage {
                    case .landing, .guide:
                        OnboardingViewWithIndicator(currentPage: $currentPage)
                            .environmentObject(alertViewModel)

                    case .scan:
                        ScanView()
                            .environmentObject(alertViewModel)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}
