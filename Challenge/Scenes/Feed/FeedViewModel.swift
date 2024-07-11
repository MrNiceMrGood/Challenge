//
//  FeedViewModel.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import Combine
import Foundation
import UIKit

final class FeedViewModel: ViewModel {
  @Published var photos: [Photo] = [] {
    didSet {
      didUpdatePhotos()
    }
  }
  
  @Published var imagesDict: [String: UIImage] = [:]
  
  private var currentPageNumber = 0
  private var dataIsLoading = false
  private var photosPerPage: Int
  private var coordinator: Coordinator
  private var feedService: FeedServiceProtocol
  private var photoService: PhotoServiceProtocol

  init(coordinator: Coordinator,
       feedService: FeedServiceProtocol,
       photoService: PhotoServiceProtocol,
       photosPerPage: Int = 10) {
    self.coordinator = coordinator
    self.photoService = photoService
    self.feedService = feedService
    self.photosPerPage = photosPerPage
  }
  
  func loadMorePhotosIfNeeded(photo: Photo) {
    let index = photos.firstIndex(where: { $0.id == photo.id }) ?? photos.count - 1
    if photos.count < 1 || index >= photos.count - 1 {
      loadFeed()
    }
  }
  
  func refreshFeed() {
    photoService.clearCache()
    currentPageNumber = 0
    loadFeed(refresh: true)
  }
  
  func loadFeed(refresh: Bool = false) {
    guard !dataIsLoading else { return }
    dataIsLoading = true
    feedService
      .loadCuratedPhotos(photosPerPage: photosPerPage, pageNumber: currentPageNumber + 1)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self = self else { return }
        switch completion {
        case .failure(let error):
          self.photos = []
          self.error = error
          self.showError = true
        case .finished:
          break
        }
        self.dataIsLoading = false
      } receiveValue: { [weak self] photosResponse in
        guard let self = self else { return }
        let photos = photosResponse.photos.map { Photo(response: $0) }
        switch refresh {
        case true:
          self.photos = photos
        case false:
          self.photos.append(contentsOf: photos)
        }
        self.currentPageNumber = photosResponse.page
        self.dataIsLoading = false
      }
      .store(in: &cancelBag)
  }
  
  func didSelectPhoto(_ photo: Photo) {
    self.coordinator.routeToDetails(photo)
  }
  
  deinit {
    cancelBag.removeAll()
  }
}

private extension FeedViewModel {
  func didUpdatePhotos() {
    photos.forEach { photo in
      loadPhoto(urlString: photo.mediumSizeImageUrl)
    }
  }
  
  func loadPhoto(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    photoService
      .loadPhoto(from: url)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] completion in
        guard let self = self else { return }
        switch completion {
        case .failure(let error):
          self.error = error
        case .finished:
          break
        }
      } receiveValue: { [weak self] image in
        guard let self = self else { return }
        self.imagesDict[urlString] = image
      }
      .store(in: &cancelBag)
  }
}
