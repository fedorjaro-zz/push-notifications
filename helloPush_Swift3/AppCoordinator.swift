//
//  AppCoordinator.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import FuntastyKit

class AppCoordinator: Coordinator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        navigateToLanding()
    }

    private func navigateToLanding() {
        let viewModel = LandingViewModel()
        let coordinator = LandingCoordinator(window: window, viewModel: viewModel)
        coordinator.start()
    }
}
