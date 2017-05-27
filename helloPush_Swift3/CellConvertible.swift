//
//  CellConvertible.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit

public protocol CellConvertible {
    var reuseIdentifier: String { get }

    func cellType() -> UIView.Type
    func model() -> Any
}

extension CellConvertible {
    public var reuseIdentifier: String {
        return cellType().nibName
    }

    public func model() -> Any {
        return self
    }
}

public protocol CellConfigurable {
    associatedtype Model
    func configure(with model: Model)
}
