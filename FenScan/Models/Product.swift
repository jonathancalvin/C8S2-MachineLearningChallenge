//
//  Product.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 13/06/25.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Product: Identifiable {
    // TO DO: lengkapi
    @Attribute var id: UUID? = UUID()
    var productImageData: Data?
    var productImage: Image? {
        guard let data = productImageData else { return nil }
        if let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
            // converts image data into actual image
        }
        return nil
    }
    init(productImageData: Data? = nil) {
        self.productImageData = productImageData
    }
}

// Enum tulis di sini
