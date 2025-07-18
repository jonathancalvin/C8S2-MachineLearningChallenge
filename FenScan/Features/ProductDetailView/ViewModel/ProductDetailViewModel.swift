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
    @Published var productImage: UIImage
    @Published var haramIngredient: [String] = []
    @Published var translatedText: String = "" {
        didSet {
            Task {
                await reset()
                let (hasIngredientSection, ingredientSection) = getIngredientSection(translatedText)
                guard hasIngredientSection else {
                    await MainActor.run {
                        if let vm = alertViewModel {
                            vm.show(title: "Scan Unsuccessful", message: "We couldn't detect any ingredient info. Let's try scanning again.")
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
    
    var imageGradient: Gradient {
        if isHaram {
            return Gradient(colors: [Color.red.opacity(0.5), Color.clear])
        } else {
            return Gradient(colors: [Color.blue.opacity(0.5), Color.clear])
        }
    }
    
    init(productImage: UIImage) {
        self.productImage = productImage
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
        var result: [String] = []
        for ingredient in cleanData {
            if let output = MLManager.shared.classifyIngredient(word: ingredient), output == "haram" {
                result.append(ingredient)
            }
        }

        Task { @MainActor in
            self.haramIngredient = result
        }
    }}
