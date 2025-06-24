//
//  OCRManager.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 15/06/25.
//
import UIKit
import Vision
import SwiftUI

final class OCRManager: OCRManagerProtocol {
    
    func imageToTextHandler(image: CIImage?, frame: CGRect, completion: @escaping (String) -> Void) {
        // Get the CGImage on which to perform requests.
        guard let ciImage = image else { return }
        
        // normalize frame to image size
        let normalizedFrame = normalizeBoundingBox(frame, in: ciImage)

        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(ciImage: ciImage, orientation: .right)

        // Create a new request to recognize text.
        let request = makeTextRecognitionRequest(boundingBox: normalizedFrame) { recognizedStrings in
            let resultText = self.processResults(recognizedStrings)
            DispatchQueue.main.async {
                completion(resultText)
            }
        }

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }
    
    func normalizeBoundingBox(_ frame: CGRect, in image: CIImage) -> CGRect {
        let imageWidth = image.extent.width
        let imageHeight = image.extent.height

        // Normalize the bounding box values to be within the image's extent
        let normalizedX = max(0, min(1, frame.origin.x / imageWidth))  // Ensure the value is between 0 and 1
        let normalizedY = max(0, min(1, frame.origin.y / imageHeight))  // Ensure the value is between 0 and 1
        let normalizedWidth = max(0, min(1, frame.width / imageWidth)) // Ensure the value is between 0 and 1
        let normalizedHeight = max(0, min(1, frame.height / imageHeight)) // Ensure the value is between 0 and 1

        print("X: \(normalizedX), Y: \(normalizedY), w: \(normalizedWidth), h: \(normalizedHeight)")

        return CGRect(x: normalizedX, y: normalizedY, width: normalizedWidth, height: normalizedHeight)
    }
}

private extension OCRManager {
    func makeTextRecognitionRequest(boundingBox: CGRect, completion: @escaping ([String]) -> Void) -> VNRecognizeTextRequest {
        
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil,
                  let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([])
                return
            }

            let recognizedStrings = observations.compactMap { (observation: VNRecognizedTextObservation) -> String? in
//                $0.topCandidates(1).first?.string
                guard let topCandidate = observation.topCandidates(1).first else { return nil }
                let boundingBox = observation.boundingBox
                if boundingBox.intersects(boundingBox) {
                    return topCandidate.string
                }
                return nil
            }

            completion(recognizedStrings)
        }

        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en"]
        request.regionOfInterest = boundingBox
        return request
    }

    func processResults(_ texts: [String]) -> String {
        return texts.joined(separator: ", ")
    }
}
