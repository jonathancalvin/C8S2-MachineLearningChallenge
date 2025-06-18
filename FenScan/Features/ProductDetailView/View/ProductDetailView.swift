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
        ZStack(alignment: .top) {
            GeometryReader { geometry in
                if let selectedImage = UIImage(data: viewModel.productImageData) {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .frame(maxWidth: geometry.size.width, alignment: .top)
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        .frame(maxWidth: geometry.size.width, alignment: .top)
                        .foregroundColor(.gray)
                }
            }
            VStack {
                Spacer()
                VStack {
                    VStack(alignment: .center) {
                        productStatusDisplay(productStatus: viewModel.productStatus)
                        Text(viewModel.isHaram ? "This product contains ingredients considered haram." : "No haram ingredients were detected in this product.")
                            .font(.headline)
                            .fontWeight(.medium)
                            .padding(.top)
                            .padding(.horizontal, 12)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.black)
                    }
                    .padding(.top, 24)
                    VStack(alignment: .leading) {
                        Text("INGREDIENTS")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 10)
                            .foregroundStyle(.black)

                        if !viewModel.haramIngredient.isEmpty {
                            ingredientsFound(ingredients: viewModel.haramIngredient)
                            Spacer()
                        } else {
                            Spacer()
                            noIngredientsFound()
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
                    Spacer()
                    disclaimerBox()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 550)
                .background(Color.white)
                .cornerRadius(20)
        } else {
            Image(systemName: "image.fill")
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .frame(maxHeight: 300, alignment: .top)
                .foregroundColor(.gray)
        }
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
        .ignoresSafeArea(edges: .bottom)
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
                    .frame(maxWidth: 280, alignment: .center)
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
            Text("Check other indicators on the product package, such as:")
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top)
                .padding(.bottom, 10)
                .multilineTextAlignment(.center)
            otherIndicators()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }

    func otherIndicators() -> some View {
        let systemNames: [String] = ["minus.circle.fill", "minus.circle.fill", "minus.circle.fill", "minus.circle.fill"]
        let texts: [String] = ["HALAL Logo", "No Alcohol", "No Pork", "No Lard"]

        return HStack(alignment: .top, spacing: 10) {
            ForEach(Array(zip(systemNames, texts)), id: \.1) { systemName, text in
                VStack {
                    Image(systemName: systemName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .opacity(0.5)
                        .padding(.vertical)
                    Text(text)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .opacity(0.4)
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
                    Text(ingredient)
                        .font(.headline)
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

//#Preview {
//    ProductDetailView(viewModel: .init())
//}
