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

}

extension NotificationCellModel: CellModel {
    func cellType() -> UIView.Type {
        return NotificationCell.self
    }

    var cellHeight: CGFloat {
        return 80.0
    }
}
