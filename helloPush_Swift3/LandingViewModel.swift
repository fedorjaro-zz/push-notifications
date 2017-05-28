//
//  LandingViewModel.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright (c) 2017 Ananth. All rights reserved.
//

import Foundation

protocol LandingViewModelDelegate: class {
    func reloadTableView()
}

final class LandingViewModel {

    weak var delegate: LandingViewModelDelegate?

    // MARK: - Properties

    var cells = [NotificationCellModel]()

    // MARK: - Init

    init() {
        APIAdapter.sharedInstance.delegate = self
    }

    // MARK: - Actions

    func viewDidLoad() {
        cells.removeAll()
        APIAdapter.sharedInstance.getMessages()
    }

    func post(notification: String) {
        APIAdapter.sharedInstance.postMessage(text: notification)
    }
}

extension LandingViewModel: APIAdapterDelegate {
    func didLoadMessage(message: String) {
        cells.removeAll()
        APIAdapter.sharedInstance.messagesArray.forEach { message in
            cells.append(NotificationCellModel(message: message))
        }
        delegate?.reloadTableView()
    }
}
