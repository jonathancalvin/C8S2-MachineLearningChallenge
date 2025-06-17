//
//  OCRView.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 13/06/25.
//

import Foundation
import SwiftUI
import AVFoundation
import Vision
import VisionKit
import Combine


struct OCRView: View {
    @State private var isShowingResult = false
    @StateObject private var viewModel = OCRViewModel()
    
    let boxWidth: CGFloat = 318
    let boxHeight: CGFloat = 485
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Camera feed
                CameraView(viewModel: viewModel)
                    .ignoresSafeArea()
                    .onAppear {
                        viewModel.startCamera()
                    }

                // Blur overlay dengan lubang berbentuk rounded rectangle
                Color.black.opacity(0.4)
                    .mask {
                        Rectangle()
                            .fill(style: FillStyle(eoFill: true))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(width: boxWidth, height: boxHeight)
                                    .blendMode(.destinationOut)
                            )
                    }
                    .compositingGroup()
                    .ignoresSafeArea()
                

                Image("boundaryBox")
                    .resizable()
                    .frame(width: 322, height: 490)
                    .padding(.bottom, 20)
                
                // Tombol Scan di bagian bawah
                VStack {
                    Spacer()
                    Button(action: {
                        let origin = CGPoint(
                            x: (geo.size.width - boxWidth) / 2,
                            y: (geo.size.height - boxHeight) / 2
                        )
                        let frame = CGRect(origin: origin, size: CGSize(width: boxWidth, height: boxHeight))
                        viewModel.performTextRecognition(in: frame, imageSize: geo.size)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            if !viewModel.recognizedText.isEmpty {
                                isShowingResult = true
                            }
                        }
                    }) {
                        Text("Scan")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(14)
                            .padding(.horizontal, 24)
                            .shadow(radius: 5)
                    }
                    .padding(.bottom, 30)
                }
            }
            .sheet(isPresented: $isShowingResult) {
                VStack(spacing: 16) {
                    Text("Hasil Scan")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    ScrollView {
                        Text(viewModel.recognizedText)
                            .font(.body)
                            .padding()
                    }

                    Button(action: {
                        isShowingResult = false
                    }) {
                        Text("Tutup")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom)
                }
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
