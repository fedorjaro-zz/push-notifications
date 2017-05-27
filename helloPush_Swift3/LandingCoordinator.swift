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

    var navigationController: UINavigationController?
    weak var viewController: LandingViewController?
    var viewModel: LandingViewModel

    init(navigationController: UINavigationController, viewModel: LandingViewModel) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle

    func start() {
        guard let viewController = viewController else {
            return
        }
        viewController.viewModel = viewModel
        viewController.coordinator = self
        navigationController?.pushViewController(viewController, animated: true)
    }

    func stop() {
        _ = navigationController?.popViewController(animated: true)
    }
}
