//
//  ProductDetailView.swift
//  FenScan
//
//  Created by Kenneth Mayer on 16/06/25.
//

import Foundation
import SwiftUI

struct ProductDetailView: View {

    @ObservedObject var viewModel: ProductDetailViewModel

    var body: some View {
//        if let image = UIImage(data: viewModel.productImageData) {
        Image(uiImage: viewModel.productImage)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(maxHeight: 300, alignment: .top)
                .cornerRadius(20)
                .overlay {
                    LinearGradient(
                        gradient: viewModel.imageGradient,
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .cornerRadius(20)
                }
//        } else {
//            Image(systemName: "image.fill")
//                .resizable()
//                .scaledToFill()
//                .aspectRatio(contentMode: .fit)
//                .clipped()
//                .frame(maxHeight: 300, alignment: .top)
//                .foregroundColor(.gray)
//        }
        VStack {
            ScrollView {
                VStack(alignment: .center) {
                    if viewModel.isHaram {
                        productHaramDisplay()
                    } else {
                        productHalalDisplay()
                    }
                }
            }
            .onDisappear {
                viewModel.haramIngredient.removeAll()
            }
            Spacer()
            disclaimerBox()
        }
//        .ignoresSafeArea(edges: .bottom)
    }
    // Extracted Component Functions
    func productHaramDisplay() -> some View {
        let gradientColors = [Color.red.opacity(0.8), Color.red.opacity(0.6)]
        return VStack {
            VStack(alignment: .center) {
                Text("Haram")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: 300, maxHeight: 300, alignment: .center)
                    .padding(9)
                    .background(
                        LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .bottom, endPoint: .top)
                    )
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.red.opacity(0.5), lineWidth: 2))
                    .padding(.horizontal)
                Text("This product contains ingredients considered haram.")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .padding(.top)
                    .padding(.horizontal, 12)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 24)
            VStack(alignment: .leading) {
                Text("INGREDIENTS")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 10)
                ingredientsFound(ingredients: viewModel.haramIngredient)
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }

    func productHalalDisplay() -> some View {
        return VStack(alignment: .center) {
            Text("We couldn't find any haram ingredients in this product.")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top)
                .padding(.bottom, 10)
                .multilineTextAlignment(.center)
                .foregroundStyle(.tint)
            Text("Check other indicators on the product package, such as:")
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top)
                .padding(.bottom, 10)
                .multilineTextAlignment(.center)
                .opacity(0.6)
            otherIndicators()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }

    func otherIndicators() -> some View {
        let customIcons: [String] = ["halalLogo", "noAlcohol", "noPork", "noLard"]
        let texts: [String] = ["HALAL Logo", "No Alcohol", "No Pork", "No Lard"]

        return HStack(alignment: .top, spacing: 10) {
            ForEach(Array(zip(customIcons, texts)), id: \.1) { customIcon, text in
                VStack {
                    Image(customIcon)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .padding(.vertical)
                    Text(text)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .opacity(0.4)
                        .multilineTextAlignment(.center)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 5)
    }

    func ingredientsFound(ingredients: [String]) -> some View {
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]
        return LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
            ForEach(ingredients.sorted(), id: \.self) { ingredient in
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width: 20, height: 20)
                    Text(ingredient.capitalized)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    func disclaimerBox() -> some View {
        return HStack(alignment: .center) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30)
                .foregroundStyle(.yellow)
                .overlay(
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30)
                        .foregroundStyle(.red.opacity(0.8))
                )
                .padding(.trailing, 4)
            Text("This app is not an official halal authority. Verify with trusted sources for full assurance before consuming.")
                .font(.caption2)
                .italic(true)
                .opacity(0.6)
        }
        .padding(10)
        .padding(.horizontal, 6)
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.red.opacity(0.2), lineWidth: 2))
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}
