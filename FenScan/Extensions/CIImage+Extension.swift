//
//  UIImage+Extension.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 18/06/25.
//

import SwiftUI

extension CIImage {
    func toUIImage(context: CIContext = CIContext(), scale: CGFloat = UIScreen.main.scale, orientation: UIImage.Orientation = .up) -> UIImage? {
        guard let cgImage = context.createCGImage(self, from: self.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: scale, orientation: orientation)
    }
}
