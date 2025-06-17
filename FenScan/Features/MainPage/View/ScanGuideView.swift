//
//  ScanGuideView.swift
//  FenScan
//
//  Created by Ahmad Al Wabil on 16/06/25.
//

import SwiftUI

struct ScanGuideView: View {
    @Environment(\.dismiss) var dismiss
    let guideTexts = [
        "Ensure good lighting and hold the product steady",
        "Align the text within the frame for better accuracy",
        "Avoid glare or reflection when scanning"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName:"camera.fill")
                .resizable()
                .frame(width: 80, height: 60)
                .foregroundColor(.white)
            
            Text("How To Scan")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top)
            

            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 322, height: 217)

                VStack(alignment: .leading, spacing: 16) {
                    ForEach(guideTexts, id: \.self) { text in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .foregroundColor(.blue)
                                .padding(.top, 6)
                            
                            Text(text)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                }
                .frame(width: 300, alignment: .leading)
            }
            
            Button(action: {
                dismiss()
            }) {
                Text("Got it")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 150, height: 40)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ScanGuideView()
}
