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
    //var api: APIAdapter?

    // MARK: - Init

    init() {
        //api = APIAdapter()
        //api?.delegate = self
        APIAdapter.sharedInstance.delegate = self
    }

    // MARK: - Actions

    func viewDidLoad() {
        cells.removeAll()
        //api?.getMessages()
        APIAdapter.sharedInstance.getMessages()
    }

    func post(notification: String) {
//        api?.postMessage(text: notification)
        APIAdapter.sharedInstance.postMessage(text: notification)
    }
}

extension LandingViewModel: APIAdapterDelegate {
    func didLoadMessage(message: String) {
        cells.append(NotificationCellModel(message: message))
        delegate?.reloadTableView()
    }
}
