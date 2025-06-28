//
//  OnboardingView.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 19/06/25.
//
//
import SwiftUI



struct OnboardingViewWithIndicator: View {

    @EnvironmentObject var alertViewModel: AlertViewModel
    @Binding var currentPage: AppPageEnum

    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                LandingPageView()
                    .tag(AppPageEnum.landing)

                ScanGuide2(currentPage : $currentPage)
                    .tag(AppPageEnum.guide)
                    .environmentObject(alertViewModel)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // tetap hide default dots
            .animation(.easeInOut, value: currentPage)

            // Custom indicator hanya ditampilkan di halaman onboarding
            if currentPage != .scan {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(AppPageEnum.allCases, id: \.self) { page in
                            Circle()
                                .fill(currentPage == page ? Color.blue : Color.gray.opacity(0.5))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    .padding(.bottom, 50)
                }
            }
        }
        .ignoresSafeArea()
    }
}
