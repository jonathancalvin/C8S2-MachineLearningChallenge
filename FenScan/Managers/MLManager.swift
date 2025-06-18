//
//  MLManager.swift
//  FenScan
//
//  Created by jonathan calvin sutrisna on 18/06/25.
//

import Foundation
import CoreML
import SwiftUI

final class MLManager {
    static let shared = MLManager()
    private init() { }
    let ingredientSynonym: [String] = [
        "internal name",
        "ingredients",
        "contents",
        "components",
        "constituents",
        "elements",
        "materials",
        "substances",
        "composition",
        "formula",
        "raw materials",
        "inputs"
    ]
    
    func classifyIngredient(word: String) -> String?{
        do {
            let config = MLModelConfiguration()
            let model = try HaramClassifier(configuration: config)
            let output = try model.prediction(text: word)
            return output.label
        }
        catch {
            print(error.localizedDescription)
        }
        return nil
    }
    private func levenshtein(_ lhs: String, _ rhs: String) -> Int {
        let lhs = Array(lhs)
        let rhs = Array(rhs)
        let mike = lhs.count
        let november = rhs.count

        var dp = Array(repeating: Array(repeating: 0, count: november + 1), count: mike + 1)

        for india in 0...mike { dp[india][0] = india }
        for juliett in 0...november { dp[0][juliett] = juliett }

        for india in 1...mike {
            for juliett in 1...november {
                if lhs[india - 1] == rhs[juliett - 1] {
                    dp[india][juliett] = dp[india - 1][juliett - 1]
                } else {
                    dp[india][juliett] = min(dp[india - 1][juliett - 1], dp[india][juliett - 1], dp[india - 1][juliett]) + 1
                }
            }
        }

        return dp[mike][november]
    }

    private func normalizedSimilarity(_ alpha: String, _ beta: String) -> Double {
        let distance = Double(levenshtein(alpha, beta))
        let maxLength = Double(max(alpha.count, beta.count))
        if maxLength == 0 { return 1.0 }
        return 1.0 - (distance / maxLength)
    }
    
    private func findSimilarWord(in rawText: String, synonymList: [String], threshold: Double = 0.6) -> String {
        let words = rawText.split(separator: " ").map { String($0) }

        for term in synonymList {
            for word in words {
                let similarity = normalizedSimilarity(word, term)
                if similarity >= threshold {
                    return word
                }
            }
        }
        return ""
    }
    
    private func extractIngredientsSection(from text: String) -> (String?, String?) {
        let text = text.lowercased()
        let term = findSimilarWord(in: text, synonymList: ingredientSynonym)

        guard !term.isEmpty else {
            print("ingredient term not found")
            return (nil, nil)
        }

        guard let startRange = text.range(of: term) else {
            print("startRange not found")
            return (nil, nil)
        }

        let substringFromIngredients = text[startRange.upperBound...]
        
        var result = term
        var isCloseParantheses = false

        for char in substringFromIngredients {
            if char == "(" || char == "[" {
                isCloseParantheses = false
            } else if char == ")" || char == "]" {
                isCloseParantheses = true
            } else if char == "." && isCloseParantheses {
                break
            }
            result.append(char)
        }
        result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        print("ingredient section: \(result)")
        return (term, result)
    }

    private func tokenizeIngredients(_ ingredientsText: String, ingredientTerm: String) -> [String] {
        guard let ingredientsRange = ingredientsText.range(of: ingredientTerm) else { return [] }
        let raw = ingredientsText[ingredientsRange.upperBound...]

        // Gunakan regex untuk mengambil token yang diapit () sebagai satu elemen
        let pattern = #"\([^)]+\)|[^,()]+(?:\([^)]+\))?"#

        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }

        let nsrange = NSRange(raw.startIndex..<raw.endIndex, in: raw)
        
        let matches = regex.matches(in: String(raw), options: [], range: nsrange)

        let tokens = matches.compactMap { match -> String? in
            if let range = Range(match.range, in: raw) {
                return raw[range].trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                return nil
            }
        }
        // 2. Hapus karakter () dan []
//        let cleaned = raw.replacingOccurrences(of: "[\\[\\]\\(\\)]", with: "", options: .regularExpression)
//
//        // 3. Pisahkan berdasarkan koma dan spasi
//        let separators = CharacterSet(charactersIn: ", ")
//
//        let tokens = cleaned
//            .components(separatedBy: separators)
//            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
//            .filter { !$0.isEmpty }
        
        return tokens
    }

    private func uniqueIngredients(from tokens: [String]) -> [String] {
        let uniqueWords = Array(Set(tokens)).sorted()
        var filteredWords = Set<String>()
        for word1 in uniqueWords {
            for word2 in uniqueWords {
                //cari yang mirip
                let similarity = normalizedSimilarity(word1, word2)
                if similarity > 0.6 {
                    filteredWords.insert(word1)
                }
            }
        }
        return Array(filteredWords)
    }
    
    func preProcessData(rawText: String, ingredientTerm: Binding<String>) -> [String]? {
        let (term, ingredientsSection) = extractIngredientsSection(from: rawText)

        guard let ingredientsSection, let term else {
            print("Ingredients section not found.")
            return nil
        }

        let tokens = tokenizeIngredients(ingredientsSection, ingredientTerm: term)
        if tokens.isEmpty {
            print("Fail to tokenize ingredients")
            return nil
        }

        let uniqueList = uniqueIngredients(from: tokens)
        print(uniqueList)
        return uniqueList
    }
}
