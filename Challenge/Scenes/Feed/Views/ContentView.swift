//
//  ContentView.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import SwiftUI
import UIKit

struct ContentView: View {
    // Default style
    var verticalPadding: CGFloat = 8
    var shadowRadius: CGFloat = 5
    var shadowColor = Color.gray.opacity(0.7)
    var cornerRadius: CGFloat = 15
    
    var image: UIImage?
    var title: String
    
    var body: some View {
        VStack(alignment: .center) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .padding(.bottom, verticalPadding)
            } else {
                ZStack(alignment: .center) {
                    Image(.placeholder)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                    ProgressView()
                }
                .padding(.bottom, verticalPadding)
            }
            Text(title)
                .font(.headline)
                .foregroundStyle(Color(.foreground))
                .multilineTextAlignment(.center)
                .padding(.bottom, verticalPadding)
        }
        .cornerRadius(cornerRadius)
        .background(
            Rectangle()
                .fill(Color(.background))
                .cornerRadius(cornerRadius)
                .shadow(
                    color: shadowColor,
                    radius: shadowRadius,
                    x: 0,
                    y: 0
                ))
    }
}
