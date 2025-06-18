//
//  ProductDetailView.swift
//  FenScan
//
//  Created by Kenneth Mayer on 16/06/25.
//

import Foundation
import SwiftUI
import Translation

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
                        Text(viewModel.productStatus == "Haram" ? "This product contains ingredients considered haram." : "No haram ingredients were detected in this product.")
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

                        if viewModel.ingredients.isEmpty {
                            Spacer()
                            noIngredientsFound()
                            Spacer()
                        } else {
                            ingredientsFound(ingredients: viewModel.ingredients)
                            Spacer()
                        }
                    }
                    .padding(.horizontal, 24)
//                    Spacer()
                    disclaimerBox()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 550)
                .background(Color.white)
                .cornerRadius(20)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    // Extracted Component Functions
    func productStatusDisplay(productStatus: String) -> some View {
        let gradientColors = productStatus == "Haram" ? [Color.red.opacity(0.8), Color.red.opacity(0.6)] : [Color.blue.opacity(0.8), Color.blue.opacity(0.6)]
        return Text(productStatus)
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(9)
            .background(
                LinearGradient(gradient: Gradient(colors: gradientColors), startPoint: .bottom, endPoint: .top)
            )
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(productStatus == "Haram" ? Color.red.opacity(0.5) : Color.blue.opacity(0.5), lineWidth: 2))
            .padding(.horizontal)
    }
    func noIngredientsFound() -> some View {
        return VStack(alignment: .center) {
            Image(systemName: "minus.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.gray.opacity(0.3))
                .padding(.vertical)
            Text("No Haram ingredients found.")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(.black.opacity(0.4))
                .opacity(0.4)
        }
        .frame(maxWidth: .infinity)
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
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
//        .padding(.horizontal)
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
                .foregroundStyle(.black.opacity(0.6))
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
