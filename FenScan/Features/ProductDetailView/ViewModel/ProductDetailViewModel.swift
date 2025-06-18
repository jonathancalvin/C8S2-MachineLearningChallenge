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
    var ingredientTerm: String = ""
    @Published var haramIngredient: [String] = []
    @Published var translatedText: String = "" {
        didSet {
            //Fail to Classify
            if !classify(translatedText) {
                reset()
            }
        }
    }
    
    private func reset() {
        DispatchQueue.main.async {
            self.haramIngredient = []
        }
    }
    
    var productDescription: String?
    var isHaram: Bool {
        !(haramIngredient.isEmpty)
    }
    var productStatus: String {
        if isHaram {
            "Haram"
        } else {
            "Halal"
        }
    }
    
    init(productImageData: Data) {
        self.productImageData = productImageData
    }
    
    func classify(_ textToClassify: String) -> Bool {
        guard let cleanData = MLManager.shared.preProcessData(
            rawText: textToClassify,
            ingredientTerm: Binding(
                get: { self.ingredientTerm },
                set: { self.ingredientTerm = $0 }
            )
        ) else {
            return false
        }
        
        for ingredient in cleanData {
            guard let output = MLManager.shared.classifyIngredient(word: ingredient) else { continue }
            if output == "haram" {
                haramIngredient.append(ingredient)
            }
        }
        return true
    }
}
