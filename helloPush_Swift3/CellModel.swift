//
//  CellModel.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit

public protocol CellModel: CellConvertible {
    var cellHeight: CGFloat { get }
    var highlighting: Bool { get }
    var separatorIsHidden: Bool { get }
}

public extension CellModel {
    var cellHeight: CGFloat {
        return 50
    }

    var highlighting: Bool {
        return true
    }

    var separatorIsHidden: Bool {
        return false
    }
}
