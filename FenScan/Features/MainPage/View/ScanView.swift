//
//  ScanView.swift
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
import Translation

class ViewModelWrapper: ObservableObject {
    @Published var vm: ProductDetailViewModel? = nil
}

struct ScanView: View {
    @EnvironmentObject var alertViewModel: AlertViewModel
    @StateObject private var viewModel = ScanViewModel()
    @StateObject private var productDetailViewModel: ProductDetailViewModel = ProductDetailViewModel(productImage: UIImage())
    @State var preventTranslationLoop: Bool = false


    @State var translationRequest: TranslationSession.Request = .init(sourceText: "")
    @State var translationConfiguration: TranslationSession.Configuration?

    private func onScan(containerSize: CGSize, boxWidth: CGFloat, boxHeight: CGFloat) {
        let origin = CGPoint(
            x: ((containerSize.width - boxWidth) / 2) + 50,
            y: ((containerSize.height - boxHeight) / 2) + 25
        )
        let frame = CGRect(origin: origin, size: CGSize(width: boxWidth - 100, height: boxHeight - 50))
        viewModel.performTextRecognition(boundingBox: frame, previewSize: containerSize)
        preventTranslationLoop = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            if let image = viewModel.capturedImage, !viewModel.recognizedText.isEmpty {
                translationRequest = TranslationSession.Request(sourceText: viewModel.recognizedText)
                if translationConfiguration == nil {
                    translationConfiguration = TranslationSession.Configuration(
                        source: Locale.Language(identifier: "zh-Hant"),
                        target: Locale.Language(identifier: "en")
                    )
                }
                productDetailViewModel.productImage = image
                productDetailViewModel.alertViewModel = self.alertViewModel
                translationConfiguration?.invalidate()
            } else {
                alertViewModel.show(title: "Scan Unsuccessful", message: "We couldn’t detect any ingredient info. Let’s try scanning again.")
            }
        }
    }
    struct CornerBoundingBox: View {
        let boxWidth: CGFloat
        let boxHeight: CGFloat
        let cornerRadius: CGFloat
        let cornerLength: CGFloat = 30
        let lineWidth: CGFloat = 4
        let color: Color = .white

        var body: some View {
            ZStack {
                // Top-Left Corner
                Path { path in
                    path.move(to: CGPoint(x: 0, y: cornerRadius))
                    path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(180),
                                endAngle: .degrees(270),
                                clockwise: false)
                    path.move(to: CGPoint(x: 0, y: cornerRadius))
                    path.addLine(to: CGPoint(x: 0, y: cornerRadius + cornerLength))
                    path.move(to: CGPoint(x: cornerRadius, y: 0))
                    path.addLine(to: CGPoint(x: cornerRadius + cornerLength, y: 0))
                }
                .stroke(color, lineWidth: lineWidth)

                // Top-Right Corner
                Path { path in
                    path.move(to: CGPoint(x: boxWidth - cornerRadius, y: 0))
                    path.addArc(center: CGPoint(x: boxWidth - cornerRadius, y: cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(270),
                                endAngle: .degrees(0),
                                clockwise: false)
                    path.move(to: CGPoint(x: boxWidth, y: cornerRadius))
                    path.addLine(to: CGPoint(x: boxWidth, y: cornerRadius + cornerLength))
                    path.move(to: CGPoint(x: boxWidth - cornerRadius, y: 0))
                    path.addLine(to: CGPoint(x: boxWidth - cornerRadius - cornerLength, y: 0))
                }
                .stroke(color, lineWidth: lineWidth)

                // Bottom-Left Corner
                Path { path in
                    path.move(to: CGPoint(x: 0, y: boxHeight - cornerRadius))
                    path.addArc(center: CGPoint(x: cornerRadius, y: boxHeight - cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(180),
                                endAngle: .degrees(90),
                                clockwise: true)
                    path.move(to: CGPoint(x: 0, y: boxHeight - cornerRadius))
                    path.addLine(to: CGPoint(x: 0, y: boxHeight - cornerRadius - cornerLength))
                    path.move(to: CGPoint(x: cornerRadius, y: boxHeight))
                    path.addLine(to: CGPoint(x: cornerRadius + cornerLength, y: boxHeight))
                }
                .stroke(color, lineWidth: lineWidth)

                // Bottom-Right Corner
                Path { path in
//                    path.move(to: CGPoint(x: boxWidth - cornerRadius, y: boxHeight))
                    path.addArc(center: CGPoint(x: boxWidth - cornerRadius, y: boxHeight - cornerRadius),
                                radius: cornerRadius,
                                startAngle: .degrees(0),
                                endAngle: .degrees(90),
                                clockwise: false)
                    path.move(to: CGPoint(x: boxWidth, y: boxHeight - cornerRadius))
                    path.addLine(to: CGPoint(x: boxWidth, y: boxHeight - cornerRadius - cornerLength))
                    path.move(to: CGPoint(x: boxWidth - cornerRadius, y: boxHeight))
                    path.addLine(to: CGPoint(x: boxWidth - cornerRadius - cornerLength, y: boxHeight))
                }
                .stroke(color, lineWidth: lineWidth)
            }
            .frame(width: boxWidth, height: boxHeight)
        }
    }
    var body: some View {
            GeometryReader { geo in
                let containerSize = geo.size
                let boxWidth: CGFloat = containerSize.width * 0.8
                let boxHeight: CGFloat = containerSize.height * 0.5
                let radius: CGFloat = 20
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

                    CornerBoundingBox(boxWidth: boxWidth, boxHeight: boxHeight, cornerRadius: radius)
                        .frame(width: boxWidth, height: boxHeight)

                    // Tombol Scan di bagian bawah
                    VStack {
                        Spacer()
                        Button(action: {
                            onScan(containerSize: containerSize, boxWidth: boxWidth, boxHeight: boxHeight)
                        }) {
                            Image("CameraShutter")
                                .resizable()
                                .frame(width: 90, height: 90)
                        }
                        .padding(.bottom, 20)
                        .translationTask(translationConfiguration) { session in
                            guard !preventTranslationLoop else { return }
                            Task { @MainActor in
                                do {
                                    for try await response in session.translate(batch: [translationRequest]) {
                                        productDetailViewModel.translatedText = response.targetText
                                    }
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea()
            .alert(alertViewModel.title, isPresented: $alertViewModel.showAlert) {
                Button("Retake", role: .cancel) { }
            } message: {
                Text(alertViewModel.message)
            }
            .navigationDestination(isPresented: $productDetailViewModel.isNavigating) {
                ProductDetailView(viewModel: productDetailViewModel)
            }
            .navigationBarBackButtonHidden(true)
        }
        
    }
}
