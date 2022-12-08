//
//  setGameStartViewController.swift
//  Concentration
//
//  Created by Andrei Pripa on 11/13/22.
//

import UIKit

class startSetGameViewController: UIViewController {
    
    @IBAction func startSetGameButton(_ sender: UIButton) {}

    @IBOutlet weak var newGameButton: UIButton! {
        didSet {
            newGameButton.layer.cornerRadius = 10
        }
    }

//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//        return .portrait
//    }
    
    

    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidesBottomBarWhenPushed = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "New Game", let cvc = segue.destination as? TestIntegrationViewController {
            hidesBottomBarWhenPushed = true
        }
    }
    
}
