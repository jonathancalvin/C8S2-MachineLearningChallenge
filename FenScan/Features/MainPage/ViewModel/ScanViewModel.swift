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

class ScanViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
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
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
//        session.startRunning()
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        latestBuffer = sampleBuffer
    }

    func performTextRecognition(in frame: CGRect, imageSize: CGSize) {
        guard let buffer = latestBuffer,
              let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return }

        // 1. Ambil citra kamera dengan orientasi yang sesuai
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            .oriented(.right) // ← sesuaikan orientasi jika perlu (lihat catatan di bawah)

        let cameraImageSize = ciImage.extent.size
        let previewSize = imageSize // ← misalnya: previewSize = geo.size dari GeometryReader

        // 2. Hitung skala dari UI ke kamera
        let scaleX = cameraImageSize.width / previewSize.width
        let scaleY = cameraImageSize.height / previewSize.height

        // 3. Flip Y axis dari koordinat UI ke citra kamera (CIImage origin ada di kiri bawah)
        let flippedY = previewSize.height - frame.origin.y - frame.height

        let mappedBox = CGRect(
            x: frame.origin.x * scaleX,
            y: flippedY * scaleY,
            width: frame.width * scaleX,
            height: frame.height * scaleY
        )

        // 4. Crop hanya pada boundary box
        let cropped = ciImage.cropped(to: mappedBox)

        // 5. OCR hanya di area dalam bounding box
        let OCR = OCRManager()
        OCR.imageToTextHandler(image: cropped) { [weak self] text in
            if text.isEmpty {
                print("OCR failed")
            } else {
                print("recognized: \(text)")
            }
            DispatchQueue.main.async {
                self?.recognizedText = text
            }
        }
    }
}
