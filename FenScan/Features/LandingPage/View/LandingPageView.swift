//
//  LandingPageView.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 13/06/25.
//

import Foundation
import SwiftUI

struct LandingPageView: View {
//    @EnvironmentObject var alertViewModel: AlertViewModel
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                Color.white
                // Union1 - pojok kiri atas (overflow keluar)
                Image("Union4")
                    .resizable()
                    .frame(width: 425, height: 413)
                    .position(x: 200, y: 150)

                Image("assetCircle2")
                    .resizable()
                    .frame(width: 200, height: 255)
                    .position(x: 100, y: 50)

                // Union2 - pojok kanan bawah (overflow keluar)
                GeometryReader { geo in
                    Image("Union5")
                        .resizable()
                        .frame(width: 425, height: 413)
                        .position(x: geo.size.width - 180, y: geo.size.height - 180 )
                }

                VStack {

                    Text("Welcome to")
                        .font(.system(size: 20))
                        .kerning(0.56)
                        .foregroundColor(Color(red: 0.2, green: 0.21, blue: 0.67))
                        .padding(.top, 140)

                    Image("fenscan4")
                        .resizable()
                        .frame(width:210, height: 56)
                        .offset(x: 0, y: -15)

                    // Logo center
                    ZStack {
                        Image("Logofix")
                            .resizable()
                            .frame(width: 380, height: 380)
                            .position(x:180, y: 180)
                            .padding()

                    }

                    VStack (alignment: .center, spacing: 5) {
                        
                        Text("Scan Haram Ingredients")
                            .font(.system(size: 28))
                            .fontWeight(.bold)
                            .foregroundColor(Color(red: 0.93, green: 0.08, blue: 0.09))

                        Text("Quickly and Easily")
                            .font(.system(size: 21))
                            .fontWeight(.regular)
                            .foregroundColor(Color(red: 0.2, green: 0.21, blue: 0.67))
                    }
                    .offset(x: 0, y: -100)
                    


                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    LandingPageView()
//        .environmentObject(AlertViewModel())
}
