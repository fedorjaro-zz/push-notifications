//
//  Keyboardable.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 28/05/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import Foundation
import UIKit

protocol Keyboardable: class {
    var keyboardObservers: [Any] { set get }
    func keyboardChanges(height: CGFloat)
}

extension Keyboardable where Self: UIViewController {
    private var center: NotificationCenter {
        return .default
    }

    func startUsingKeyboard() {
        let keyboardChangeFrame: (Notification) -> Void = { [weak self] notification in
            guard let rect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                return
            }
            self?.keyboardChanges(height: rect.size.height)
        }

        let keyboardWillHide: (Notification) -> Void = { [weak self] _ in
            self?.keyboardChanges(height: 0.0)
        }

        keyboardObservers = [
            center.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: nil, using: keyboardChangeFrame),
            center.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil, using: keyboardWillHide)
        ]
    }

    func stopUsingKeyboard() {
        keyboardObservers.forEach { center.removeObserver($0) }
    }

    func keyboardChanges(height: CGFloat) { }
}
