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
            ZStack {
                // Background gradient
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color(red: 1, green: 0.14, blue: 0.15), location: 0.38),
                        Gradient.Stop(color: Color(red: 0.6, green: 0.08, blue: 0.09), location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: -0.1),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .ignoresSafeArea()

                // Union1 - pojok kiri atas (overflow keluar)
                Image("Union1")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .position(x: 100, y: 100)

                // Union2 - pojok kanan bawah (overflow keluar)
                GeometryReader { geo in
                    Image("Union2")
                        .resizable()
                        .frame(width: 380, height: 380)
                        .position(x: geo.size.width, y: geo.size.height )
                }

                VStack {
                    Spacer()

                    // Logo center
                    ZStack {
                        Image("addLogo")
                            .resizable()
                            .frame(width: 210, height: 210)
                            .padding()

                        Image("logo1")
                            .resizable()
                            .frame(width: 175, height: 175)
                            .padding()
                    }

                    Spacer()
                    
                    Text("Welcome to FenScan")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .foregroundColor(.white)
                        .padding(.bottom, 10)

                    Text("Haram Ingredients Detection App ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 30)
                    

                    NavigationLink(destination: ScanView()) {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 180)
                            .background(Color.white)
                            .cornerRadius(50)
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    LandingPageView()
}
