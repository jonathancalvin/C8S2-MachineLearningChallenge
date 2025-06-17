//
//  CIImaeg+Extension.swift
//  FenScan
//
//  Created by Kenneth Mayer on 17/06/25.
//

import Foundation
import UIKit

extension CIImage {
    var data: Data? {
        let context = CIContext()
        guard let cgImage = context.createCGImage(self, from: self.extent) else { return nil }
        let uiImage = UIImage(cgImage: cgImage)
        return uiImage.jpegData(compressionQuality: 1)
    }
}
