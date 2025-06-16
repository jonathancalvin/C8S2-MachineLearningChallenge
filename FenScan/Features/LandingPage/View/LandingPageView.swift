//
//  LandingPageView.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 13/06/25.
//

import Foundation
import SwiftUI

struct LandingPageView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image(systemName: "qrcode.viewfinder")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .padding()
                    .foregroundColor(.white)
                
                Text("Welcome to FenScan")
                    .font(.headline)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                
                Text("Haram Ingredients Detection App for Travellers")
                    .font(.subheadline)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: ContentView()) {
                    Text("Get Started")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(red: 1, green: 1, blue: 1))
                        .cornerRadius(10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 0.81, green: 0.19, blue: 0.31), location: 0.30),
                        Gradient.Stop(color: Color(red: 0.29, green: 0.56, blue: 0.93), location: 0.80),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: -0.1),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
        }
    }
}

#Preview {
    LandingPageView()
}
