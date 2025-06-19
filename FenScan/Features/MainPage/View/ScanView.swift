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
    @StateObject private var productDetailViewModel: ProductDetailViewModel = ProductDetailViewModel(productImageData: Data())
    @State var preventTranslationLoop: Bool = false

    let boxWidth: CGFloat = 318
    let boxHeight: CGFloat = 485

    @State var translationRequest: TranslationSession.Request = .init(sourceText: "")
    @State var translationConfiguration: TranslationSession.Configuration?

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
                        preventTranslationLoop = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            print("rrrrrrrrrrrrr:\(viewModel.recognizedText)")
                            if !viewModel.recognizedText.isEmpty {
                                viewModel.captureImage()
                                translationRequest = TranslationSession.Request(sourceText: viewModel.recognizedText)
                                if translationConfiguration == nil {
                                    translationConfiguration = TranslationSession.Configuration(
                                        source: Locale.Language(identifier: "zh-Hant"),
                                        target: Locale.Language(identifier: "en")
                                    )
                                }
                                productDetailViewModel.productImageData = viewModel.latestImageData ?? Data()
                                productDetailViewModel.alertViewModel = self.alertViewModel
                                translationConfiguration?.invalidate()
                            } else {
                                alertViewModel.show(title: "Scan Unsuccessful", message: "We couldn’t detect any ingredient info. Let’s try scanning again.")
                            }
                        }
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
                                    print("Translation: \(response.targetText)")
                                    productDetailViewModel.translatedText = response.targetText
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
        }
        .alert(alertViewModel.title, isPresented: $alertViewModel.showAlert) {
            Button("Retake", role: .cancel) { }
        } message: {
            Text(alertViewModel.message)
        }
        .navigationDestination(isPresented: $productDetailViewModel.isNavigating) {
            ProductDetailView(viewModel: productDetailViewModel)
        }
        .onAppear {
            if viewModel.capturedImage != nil {
                print("ada foto")
            } else {
                print("tidak ada foto")
            }
            
            if viewModel.translatedText.isEmpty {
                print("tidak ada translated text")
            } else {
                print("translated ada, ", viewModel.translatedText)
            }
            
            if viewModel.recognizedText.isEmpty {
                print("tidak ada recognized text")
            } else {
                print("recognized text ada, ", viewModel.recognizedText)
            }
            viewModel.capturedImage = nil
            viewModel.translatedText = ""
            viewModel.recognizedText = ""
            print("Setelah =============================")
            if viewModel.capturedImage != nil {
                print("ada foto")
            } else {
                print("tidak ada foto")
            }
            
            if viewModel.translatedText.isEmpty {
                print("tidak ada translated text")
            } else {
                print("translated ada, ", viewModel.translatedText)
            }
            
            if viewModel.recognizedText.isEmpty {
                print("tidak ada recognized text")
            } else {
                print("recognized text ada, ", viewModel.recognizedText)
            }

        }
        .navigationBarBackButtonHidden(true)
    }
}
