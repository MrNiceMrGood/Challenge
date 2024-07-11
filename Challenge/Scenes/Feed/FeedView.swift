//
//  FeedView.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import SwiftUI

struct FeedView: View {
    @ObservedObject private var viewModel: FeedViewModel
    
    private let itemSpacing: CGFloat = 20
    private let horizontalPadding: CGFloat = 10
    private let navigationTitle = "Photo Feed"
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List(viewModel.photos) { photo in
            ContentView(
                image: viewModel.imagesDict[photo.mediumSizeImageUrl],
                title: photo.authorsName
            )
            .listRowSeparator(.hidden)
            .listRowBackground(Color(.background))
            .padding(.horizontal, horizontalPadding)
            .onTapGesture {
                viewModel.didSelectPhoto(photo)
            }
            .onAppear {
                viewModel.loadMorePhotosIfNeeded(photo: photo)
            }
        }
        .refreshable {
            viewModel.refreshFeed()
        }
        .background(Color(.background))
        .listRowSpacing(itemSpacing)
        .listStyle(PlainListStyle())
        .navigationTitle(navigationTitle)
        .onAppear {
            viewModel.loadFeed()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("Dismiss") {
                viewModel.onErrorAlertClose()
            }
        }
    }
}
