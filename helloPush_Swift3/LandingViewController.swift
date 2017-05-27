//
//  LandingViewController.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright (c) 2017 Ananth. All rights reserved.
//

import UIKit

final class LandingViewController: UIViewController {

    var coordinator: LandingCoordinator!
    var viewModel: LandingViewModel!

    // MARK: - Properties

    var dataSource: CellModelDataSource?

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Setup methods

    private func setupTableView() {
        tableView.registerNib(for: NotificationCell.self)

        dataSource = CellModelDataSource(cells: viewModel.cells, configure: { (cell, model) in
            if let cell = cell as? NotificationCell, let model = model as? NotificationCellModel {
                cell.configure(with: model)
            } else {
                assertionFailure("Unrecognized (\(cell), \(model)) combination.")
            }
        })
        tableView.dataSource = dataSource
        tableView.delegate = dataSource
    }

    // MARK: - Actions

    @IBAction func sendButtonPressed(_ sender: Any) {
        // TODO
    }
}
