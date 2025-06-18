//
//  ProductDetailViewModel.swift
//  FenScan
//
//  Created by Kenneth Mayer on 17/06/25.
//

import Foundation
import SwiftUI
import Translation

class ProductDetailViewModel: ObservableObject {

    @Published var productImageData: Data
    var productStatus: String = "Haram"
    var productDescription: String?
//    var ingredients: [String] = []
    var ingredients: [String] = ["Babi", "Carminic Acid", "Keku", "Mie", "Salycilic Acid", "Sapi", "Sate", "Sausage", "Soto", "Susu"]
    
    init(productImageData: Data) {
        self.productImageData = productImageData
    }
}
