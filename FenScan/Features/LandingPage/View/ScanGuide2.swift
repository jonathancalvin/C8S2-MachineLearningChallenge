//
//  ScanGuide2.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 19/06/25.
//

import SwiftUI

struct ScanGuide2: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @State var isNavigating = false
    @Binding var currentPage: Int
    var body: some View {

        NavigationStack {
            VStack {
                ZStack {
                    // Background gradient
                    Color.white
                    
                    // Union1 - pojok kiri atas (overflow keluar)
                    Image("Union4")
                        .resizable()
                        .frame(width: 425, height: 413)
                        .position(x: 30, y: 150)
                    
                    Image("asetSGV1")
                        .resizable()
                        .frame(width: 144, height: 154)
                        .position(x: 325, y: 70)

                    
                    // Union2 - pojok kanan bawah (overflow keluar)
                    GeometryReader { geo in
                        Image("Union5")
                            .resizable()
                            .frame(width: 425, height: 413)
                            .position(x: geo.size.width - 20, y: geo.size.height - 180 )
                        
                        Image("asetSGV2")
                            .resizable()
                            .frame(width: 144, height: 154)
                            .position(x: geo.size.width - 330, y: geo.size.height - 20 )
                        
                    }
                    
                    VStack {
                        
                        HStack(alignment: .center, spacing: 4) {
                            Text("Scan with")
                                .font(.system(size: 28))
                                .kerning(0.56)
                                .foregroundColor(Color(red: 0.2, green: 0.21, blue: 0.67))
                            
                            Text("Fen")
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 1, green: 0.15, blue: 0.16))
                            
                            Text("Scan")
                                .font(.system(size: 28))
                                .fontWeight(.bold)
                                .kerning(0.56)
                                .foregroundColor(Color(red: 0.14, green: 0.13, blue: 1))
                                .offset(x: -3)
                        }
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                        
                        InstructionView()
                        
                        Button {
                            isNavigating = true
                            currentPage = 2
                        } label: {
                            Text("Get Started")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(width: 139, height: 49)
                                .background(Color(red: 0.06, green: 0.06, blue: 1))
                            
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        }
                        .padding(.bottom, 60)
                        
                    }
                }
            }
            .navigationDestination(isPresented: $isNavigating) {
                ScanView()
//                    .environmentObject(alertViewModel)
                  
            }
            
        }

        
    }
    
}
