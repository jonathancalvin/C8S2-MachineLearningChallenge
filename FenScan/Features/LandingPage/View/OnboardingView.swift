//
//  OnboardingView.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 19/06/25.
//
//
import SwiftUI

// MARK: - Alternative dengan page indicator custom (optional)
struct onboardingViewWithIndicator: View {
    @State private var currentPage = 0
    @EnvironmentObject var alertViewModel: AlertViewModel
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                LandingPageView()
                    .tag(0)
                
                ScanGuide2()
                    .environmentObject(alertViewModel)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // Hide default indicator
            .animation(.easeInOut, value: currentPage)
            
            // Custom page indicator (optional)
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
        .ignoresSafeArea(.all)
    }
}

//// MARK: - Preview
//struct onboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        onboardingViewWithIndicator()
//            .environment(.managedObjectContext, PersistenceController.preview.con
//          
//        
//    }
//}

