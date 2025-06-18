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
    @Published var haramIngredient: [String] = []
    @Published var translatedText: String = "" {
        didSet {
            if !classify(translatedText) {
                reset()
                return
            }
            isNavigating = true
        }
    }
    @Published var isNavigating = false
    private var ingredientTerm: String = ""
    var alertViewModel: AlertViewModel? = nil
    
    private func reset() {
        if let vm = alertViewModel {
            vm.show(title: "Ingredient info is not found", message: "It’s usually located at the back of the package. Let’s try scanning again.")
        }
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
