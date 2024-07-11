//
//  PhotoDetailsView.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import SwiftUI

struct PhotoDetailsView: View {
    @StateObject private var viewModel: PhotoDetailsViewModel
    
    init(viewModel: PhotoDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let horizontalPadding: CGFloat = 20
    private let verticalPadding: CGFloat = 8
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                } else {
                    ZStack(alignment: .center) {
                        Image(.placeholder)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipped()
                        ProgressView()
                    }
                }
                
                Text(viewModel.photo.imageName)
                    .font(.title)
                    .foregroundStyle(Color(.foreground))
                    .multilineTextAlignment(.center)
                    .accessibilityLabel("\(viewModel.photo.imageName)")
            }
        }
        .background(Color(.background))
        .navigationBarTitleDisplayMode(.automatic)
        .navigationTitle(viewModel.photo.authorsName)
        .alert("Error", isPresented: $viewModel.showError) {
            Button("Dismiss") {
                viewModel.onErrorAlertClose()
            }
        }
    }
}
