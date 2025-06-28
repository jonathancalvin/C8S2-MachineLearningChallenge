//
//  ScanInstructionView.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 19/06/25.
//


import SwiftUI

struct InstructionView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {

                VStack {
                    
                    // Area gambar produk dengan frame
                 
                    ZStack {
                        // Gambar produk dengan rounded corner
                        Image("gambar1")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: geometry.size.width * 0.8,
                                height: geometry.size.height * 0.8
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .clipped()
                        

                        ZStack {
                            
                            // Instructions content
                            VStack(alignment: .leading, spacing: 20) {
                                Spacer()
                                
                                // Instruction 1
                                InstructionRow(
                                    text: "Ensure area with good lighting and hold the product steady"
                                    
                                )
                                
                                // Instruction 2
                                InstructionRow(
                                    text: "Make sure to scan at the back of package and fit the text inside the scan area"
                                )
                                
                                // Instruction 3
                                InstructionRow(
                                    text: "Tap the scan button and wait for the result"
                                )
                            }
                            .padding(.horizontal, 10)
                            .padding(.bottom, 10)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.98, green: 0.98, blue: 1).opacity(0.02), location: 0.19),
                                        Gradient.Stop(color: Color(red: 0.93, green: 0.46, blue: 0.46).opacity(0.71), location: 0.35),
                                        Gradient.Stop(color: Color(red: 0.96, green: 0.43, blue: 0.44), location: 0.60),
                                        Gradient.Stop(color: Color(red: 1, green: 0.41, blue: 0.41).opacity(0.92), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0.3),
                                    endPoint: UnitPoint(x: 0.5, y: 1)                     )
                                
                            )
                            .frame(width: geometry.size.width * 0.8, height: geometry.size.height * 0.8)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .clipped()
                        }
                        
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

// Helper Views untuk Instructions
struct InstructionRow: View {
    let text: String
    
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            // Bullet point
            Circle()
                .fill(Color.white)
                .frame(width: 12, height: 12)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(text)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                
            }
            
            Spacer()
        }
    }
}

#Preview {
    InstructionView()
}
