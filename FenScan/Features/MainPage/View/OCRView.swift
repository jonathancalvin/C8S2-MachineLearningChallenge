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
    let boxWidth: CGFloat = 250
    let boxHeight: CGFloat = 300

    var body: some View {
        GeometryReader { geo in
            ZStack {
                CameraView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.startCamera()
                    }

                // Blur overlay di luar boundary box
                Color.black.opacity(0.5)
                    .mask {
                        Rectangle()
                            .fill(style: FillStyle(eoFill: true))
                            .overlay(
                                Rectangle()
                                    .frame(width: boxWidth, height: boxHeight)
                                    .blendMode(.destinationOut)
                            )
                    }
                    .compositingGroup()
                    .ignoresSafeArea(.all)

                // Garis boundary box
                Rectangle()
                    .stroke(Color.blue, lineWidth: 3)
                    .frame(width: boxWidth, height: boxHeight)

                VStack {
                    Spacer()
                    Button("Scan") {
                        let origin = CGPoint(
                            x: (geo.size.width - boxWidth) / 2,
                            y: (geo.size.height - boxHeight) / 2
                        )
                        let frame = CGRect(origin: origin, size: CGSize(width: boxWidth, height: boxHeight))

                        viewModel.performTextRecognition(in: frame, imageSize: geo.size)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            // Tampilkan modal jika teks tidak kosong
                            if !viewModel.recognizedText.isEmpty {
                                isShowingResult = true
                            }
                        }
                    }
                    .sheet(isPresented: $isShowingResult) {
                        VStack {
                            Text("Hasil Scan")
                                .font(.title2)
                                .padding(.top)

                            ScrollView {
                                Text(viewModel.recognizedText)
                                    .padding()
                            }

                            Button("Tutup") {
                                isShowingResult = false
                            }
                            .padding()
                        }
                        .presentationDetents([.medium]) // <- Modal ukuran medium
                        .presentationDragIndicator(.visible)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}
