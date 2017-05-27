//
//  Storyboard.swift
//  helloPush_Swift3
//
//  Created by Milan Strnad on 27/05/17.
//  Copyright © 2017 Ananth. All rights reserved.
//

import UIKit
import FuntastyKit

struct Storyboard {

    struct Landing: StoryboardType {
        static let name: String = "Landing"
        static let LandingNavigationController = StoryboardReference<Landing, UINavigationController>(id: "LandingNavigationControllerID")
    }
}
