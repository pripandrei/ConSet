//
//  CustomTabBarController.swift
//  Concentration
//
//  Created by Andrei Pripa on 12/14/22.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var blockRotation = false
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if blockRotation {
                return .portrait
            }
            return .all
        }
    }  
}
