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
            Task {
                await reset()
                let (hasIngredientSection, ingredientSection) = getIngredientSection(translatedText)
                guard hasIngredientSection else {
                    await MainActor.run {
                        if let vm = alertViewModel {
                            vm.show(title: "Ingredient info is not found", message: "It’s usually located at the back of the package. Let’s try scanning again.")
                        } 
                    }
                    return
                }
                classify(ingredientSection)
                await MainActor.run {
                    isNavigating = true
                }
            }
        }
    }
    @Published var isNavigating = false
    private var ingredientTerm: String = ""
    var alertViewModel: AlertViewModel? = nil
    
    private func reset() async {
        await MainActor.run {
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
    private func getIngredientSection(_ text: String) -> (Bool, [String]) {
        guard let cleanData = MLManager.shared.preProcessData(
            rawText: text,
            ingredientTerm: Binding(
                get: { self.ingredientTerm },
                set: { self.ingredientTerm = $0 }
            )
        ) else {
            return (false, [])
        }
        return (true, cleanData)
    }
    func classify(_ cleanData: [String]) {
        for ingredient in cleanData {
            guard let output = MLManager.shared.classifyIngredient(word: ingredient) else { continue }
            if output == "haram" {
                let i = haramIngredient
                haramIngredient.append(ingredient)
            }
        }
    }
}
