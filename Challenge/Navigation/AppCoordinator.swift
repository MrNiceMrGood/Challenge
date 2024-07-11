//
//  AppCoordinator.swift
//  Challenge
//
//  Created by Dejan Zuza on 10. 7. 2024..
//

import UIKit
import SwiftUI

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }

    func startFlow()
    func routeToDetails(_ photo: Photo)
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let dependenciesContainer = DependenciesContainer()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func startFlow() {
        let feedService = dependenciesContainer.getFeedService()
        let photoService = dependenciesContainer.getPhotoService()
        let viewModel = FeedViewModel(coordinator: self,
                                      feedService: feedService,
                                      photoService: photoService)

        let mainView = FeedView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: mainView)
        navigationController.setViewControllers([hostingController], animated: false)
    }

    func routeToDetails(_ photo: Photo) {
        let photoService = dependenciesContainer.getPhotoService()
        let viewModel = PhotoDetailsViewModel(photo: photo,
                                              photoService: photoService)

        let detailsView = PhotoDetailsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: detailsView)
        navigationController.pushViewController(hostingController, animated: true)
    }
}

