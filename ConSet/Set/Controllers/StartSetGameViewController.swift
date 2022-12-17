//
//  setGameStartViewController.swift
//  Concentration
//
//  Created by Andrei Pripa on 11/13/22.
//

import UIKit

class StartSetGameViewController: UIViewController {
    
    @IBAction func startSetGameButton(_ sender: UIButton) {}

    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.cornerRadius = 10
        }
    }
    
    private var customTabBarController: CustomTabBarController? {
        return tabBarController as? CustomTabBarController
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hidesBottomBarWhenPushed = false
        
        if let tabBarController = customTabBarController {
            tabBarController.blockRotation = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarController = customTabBarController {
            tabBarController.blockRotation = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "New Game", let _ = segue.destination as? SetViewController {
            hidesBottomBarWhenPushed = true
        }
    }
    
}
