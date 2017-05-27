//
//  LandingCoordinator.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright (c) 2017 Ananth. All rights reserved.
//

import Foundation
import FuntastyKit

final class LandingCoordinator: DefaultCoordinator {

    private var window: UIWindow?
    weak var destinationNavigationController: UINavigationController?
    weak var viewController: LandingViewController?
    var viewModel: LandingViewModel

    // MARK: - Init

    init(window: UIWindow, viewModel: LandingViewModel) {
        self.window = window
        self.destinationNavigationController = Storyboard.Landing.LandingNavigationController.instantiate()
        self.viewController = self.destinationNavigationController?.topViewController as? LandingViewController
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle

    func start() {
        guard let window = window, let destinationNavigationController = destinationNavigationController, let viewController = viewController else {
            return
        }
        viewController.coordinator = self
        viewController.viewModel = viewModel

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.window?.rootViewController = destinationNavigationController
        })
    }

    // MARK: - Actions

    
}
