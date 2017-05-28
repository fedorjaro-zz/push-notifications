//
//  NotificationCellModel.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import Foundation
import UIKit

class NotificationCellModel {

    var message: String

    init(message: String) {
        self.message = message
    }
}

extension NotificationCellModel: CellModel {
    func cellType() -> UIView.Type {
        return NotificationCell.self
    }

    var cellHeight: CGFloat {
        return 50.0
    }
}
