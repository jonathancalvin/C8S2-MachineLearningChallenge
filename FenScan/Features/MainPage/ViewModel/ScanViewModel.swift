//
//  ScanViewModel.swift
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
    @Published var capturedImage: UIImage? = nil
    @Published var translatedText: String = ""
    @Published var isReadyToNavigate: Bool = false

    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()
        setupNavigationCheck()
    }

    private func setupNavigationCheck() {
        Publishers.CombineLatest($capturedImage, $translatedText)
            .map { image, text in
                return image != nil && !text.isEmpty
            }
            .removeDuplicates()
            .assign(to: \.isReadyToNavigate, on: self)
            .store(in: &cancellables)
    }
    
    var session = AVCaptureSession()
    private var latestBuffer: CMSampleBuffer?
    @Published var latestImageData: Data?

    func startCamera() {
        checkPermissionAndConfigure()
    }
    
    func reset() {
            capturedImage = nil
            recognizedText = ""
            translatedText = ""
    }

    private func checkPermissionAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined, .denied, .restricted:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.configureSession()
                    }
                }
            }
        default:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.configureSession()
                    }
                }
            }
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


    func performTextRecognition(boundingBox: CGRect, previewSize: CGSize) {
        guard let buffer = latestBuffer,
              let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) else { return }
        
        // 1. Ambil citra kamera dengan orientasi yang sesuai
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer).oriented(.right)

        let cameraImageSize = ciImage.extent.size

        // 2. Hitung skala dari UI ke kamera
        let scaleX = cameraImageSize.width / previewSize.width
        let scaleY = cameraImageSize.height / previewSize.height

        // 3. Flip Y axis dari koordinat UI ke citra kamera (CIImage origin ada di kiri bawah)
        let flippedY = previewSize.height - boundingBox.origin.y - boundingBox.height

        let mappedBox = CGRect(
            x: boundingBox.origin.x * scaleX,
            y: flippedY * scaleY,
            width: boundingBox.width * scaleX,
            height: boundingBox.height * scaleY
        )

        // 4. Crop hanya pada boundary box
        let cropped = ciImage.cropped(to: mappedBox)
        
        if let uiImage = cropped.toUIImage() {
            capturedImage = uiImage
        }
        
//        5. OCR hanya di area dalam bounding box
        let OCR = OCRManager()
        OCR.imageToTextHandler(image: cropped) { [weak self] text in
            DispatchQueue.main.async {
                self?.recognizedText = text
            }
        }
    }
}
