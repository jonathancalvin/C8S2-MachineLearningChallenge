//
//  OCRManager.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 15/06/25.
//
import UIKit
import Vision
import SwiftUI

final class OCRManager : OCRManagerProtocol {
    func imageToTextHandler(image: UIImage?, completion: @escaping (String) -> Void) {
        // Get the CGImage on which to perform requests.
        guard let cgImage = image?.cgImage else { return }


        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)


        // Create a new request to recognize text.
        let request = makeTextRecognitionRequest { recognizedStrings in
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
}

private extension OCRManager {
    func makeTextRecognitionRequest(completion: @escaping ([String]) -> Void) -> VNRecognizeTextRequest {
        let request = VNRecognizeTextRequest { request, error in
            guard error == nil,
                  let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([])
                return
            }

            let recognizedStrings = observations.compactMap {
                $0.topCandidates(1).first?.string
            }

            completion(recognizedStrings)
        }

        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["zh-Hans", "zh-Hant", "en"]
        return request
    }
    
    func processResults(_ texts: [String]) -> String{
        return texts.joined(separator: ", ")
    }
}
