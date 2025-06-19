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
    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                LandingPageView()
                    .tag(0)

                ScanGuide2(currentPage : $currentPage)
                    .tag(1)
                    .environmentObject(alertViewModel)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // tetap hide default dots
            .animation(.easeInOut, value: currentPage)

            // Custom indicator hanya ditampilkan di halaman onboarding
            if currentPage < 2 {
                VStack {
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(0..<2, id: \.self) { index in
                            Circle()
                                .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.5))
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
////// MARK: - Preview
//struct onboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingViewWithIndicator()
//            .environmentObject(AlertViewModel())
//          
//        
//    }
//}

