//
//  LandingViewController.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright (c) 2017 Ananth. All rights reserved.
//

import UIKit
import FuntastyKit

final class LandingViewController: UIViewController {

    var coordinator: LandingCoordinator!
    var viewModel: LandingViewModel!

    // MARK: - Properties

    var dataSource: CellModelDataSource?
    var keyboardObservers: [Any] = []

    // MARK: - Outlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputViewBottomConstraint: NSLayoutConstraint!

    @IBOutlet weak var refreshButton: UIBarButtonItem!
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupInteractions()

        viewModel.delegate = self
        viewModel.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startUsingKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopUsingKeyboard()
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

    private func setupTextField() {
        textField.delegate = self
    }

    private func setupInteractions() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    // MARK: - Actions

    @IBAction func refreshButtonPressed(_ sender: Any) {
        viewModel.viewDidLoad()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let text = textField.text else {
            return
        }
        viewModel.post(notification: text)
        textField.text = nil
        updateSendButton()
    }

    // MARK: - Helpers

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSendButton()
    }

    private func updateSendButton() {
        if let text = textField.text, text.characters.count >= 1 {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }

    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LandingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layoutIfNeeded()
    }
}

extension LandingViewController: Keyboardable {
    func keyboardChanges(height: CGFloat) {
        if inputViewBottomConstraint.constant != height {
            UIView.animate(withDuration: 0.3, animations: {
                self.inputViewBottomConstraint.constant = height
                self.view.layoutIfNeeded()
            })
        }
    }
}

extension LandingViewController: LandingViewModelDelegate {
    func reloadTableView() {
        dataSource?.cells = viewModel.cells
        tableView.reloadData()
    }
}
