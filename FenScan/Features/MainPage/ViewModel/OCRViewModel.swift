//
//  OCRViewModel.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 13/06/25.
//

import SwiftUI
import AVFoundation
import Vision
import Combine

class OCRViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var recognizedText: String = ""
    var session = AVCaptureSession()
    private var latestBuffer: CMSampleBuffer?

    func startCamera() {
        checkPermissionAndConfigure()
    }

    private func checkPermissionAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.configureSession()
                    }
                }
            }
        default:
            print("Camera access denied.")
        }
    }

    private func configureSession() {
        session.beginConfiguration()
        session.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            print("Cannot add camera input.")
            return
        }

        session.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "cameraQueue"))
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
        session.startRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        latestBuffer = sampleBuffer
    }

    func performTextRecognition(in frame: CGRect, imageSize: CGSize) {
        guard let buffer = latestBuffer,
              let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return }

        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        // Hitung cropRect berdasarkan posisi boundary box di layar vs citra kamera
        let scaleX = ciImage.extent.width / imageSize.width
        let scaleY = ciImage.extent.height / imageSize.height

        let cropRect = CGRect(
            x: frame.minX * scaleX,
            y: (imageSize.height - frame.maxY) * scaleY, // karena koordinat Y terbalik
            width: frame.width * scaleX,
            height: frame.height * scaleY
        )

        let cropped = ciImage.cropped(to: cropRect)

        let handler = VNImageRequestHandler(ciImage: cropped, options: [:])
        let request = VNRecognizeTextRequest { [weak self] request, _ in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            DispatchQueue.main.async {
                self?.recognizedText = text
            }
        }

        // Aktifkan dukungan bahasa Cina Tradisional (atau Sederhana)
        request.recognitionLanguages = ["zh-Hant", "zh-Hans", "en-US"]
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        try? handler.perform([request])
    }
}
