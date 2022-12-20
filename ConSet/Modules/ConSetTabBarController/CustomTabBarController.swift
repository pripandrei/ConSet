//
//  CustomTabBarController.swift
//  Concentration
//
//  Created by Andrei Pripa on 12/14/22.
//

import UIKit

class CustomTabBarController: UITabBarController {

    var blockRotation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            if blockRotation {
                return .portrait
            }
            return .all
        }
    }  
}
