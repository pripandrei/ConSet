//
//  ThemeChooseViewController.swift
//  Concentration
//
//  Created by Andrei Pripa on 10/8/22.
//

import UIKit

class ThemeChooseViewController: UIViewController, UISplitViewControllerDelegate {

    private var choosenTheme = [String:Any]()
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?
    
    private var splitViewDetailConcentrationController: ConcentrationViewController?
    {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var customTabBarController: CustomTabBarController? {
        return tabBarController as? CustomTabBarController
    }
    
    var themes = [
        "Sports": [
            "icons": "🏓🏀⛸🤽‍♀️⚾️🏏🏸🥌🏊‍♀️",
            "backgroundColor" : #colorLiteral(red: 0.2913746238, green: 0.5675413609, blue: 0.6501421332, alpha: 1),
            "cardColor": #colorLiteral(red: 0.2970246077, green: 0.6000617743, blue: 0.6640752554, alpha: 1)
        ],
        "People": [
            "icons": "🧑‍🔬🧑‍🔧👨‍💻👩‍🏭👨‍🎓🧑🏻‍🍳🥷🏽👨🏼‍🚀👩🏻‍🎤",
            "backgroundColor" : #colorLiteral(red: 0.6753154397, green: 0.5716267228, blue: 0.8777912259, alpha: 1),
            "cardColor": #colorLiteral(red: 0.7574701997, green: 0.5362252312, blue: 0.6736143881, alpha: 1)
        ],
        "Animals": [
            "icons": "🐥🦔🦑🦢🦩🕊🐩🐋🦍",
            "backgroundColor" : #colorLiteral(red: 0.804077208, green: 0.4270347357, blue: 0.5741969943, alpha: 1),
            "cardColor": #colorLiteral(red: 0.8045666881, green: 0.5222281085, blue: 0.5204966411, alpha: 1)
        ],
        "Music": [
            "icons": "🎹🎼🎧🎸🪘🎻🪗🎺🎷",
            "backgroundColor" : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
            "cardColor": #colorLiteral(red: 0.8175247908, green: 0.6872603297, blue: 0.6778723598, alpha: 1)
        ],
        "Food": [
            "icons": "🍏🍗🧀🫔🥘🍚🎂🍣🍫",
            "backgroundColor" : #colorLiteral(red: 0.4190964103, green: 0.1856082678, blue: 0.1921211481, alpha: 1),
            "cardColor": #colorLiteral(red: 0.6808553479, green: 0.3046491889, blue: 0.2751860591, alpha: 1)
        ],
        "Weather": [
            "icons": "☀️❄️⛄️⛈🌊💨🌈🌪🌏",
            "backgroundColor" : #colorLiteral(red: 0.260191977, green: 0.3891779482, blue: 0.1766087115, alpha: 1),
            "cardColor": #colorLiteral(red: 0.3320336938, green: 0.5563542843, blue: 0.3787606359, alpha: 1)
        ],
    ]
    
    var imageNames: [String] {
        get {
            let images = ["sportRim.jpg","AnimalsHorses.jpg","people3.jpg","musicPian.jpg", "weatherSkyy.jpg", "sport4.jpg", "musicGramofon.jpg", "weather2.jpg"]
            return images
        }
    }
    
    var themeIndex: Int? {
        didSet {
            switch themeIndex {
            case 0: choosenTheme = themes["Sports"]!
            case 1: choosenTheme = themes["Animals"]!
            case 2: choosenTheme = themes["People"]!
            case 3: choosenTheme = themes["Music"]!
            case 4: choosenTheme = themes["Weather"]!
            default: break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        splitViewController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let customTabBarVC = customTabBarController {
            customTabBarVC.blockRotation = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let customTabBarVC = customTabBarController {
            customTabBarVC.blockRotation = false
        }
    }
//
//        override open var shouldAutorotate: Bool {
//            return false
//        }
    
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//       get {
//          return .portrait
//       }
//    }
    
    /// splitViewController was removed
    ///
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
//        return true
//    }
    
    @IBOutlet var themeButtons: [UIButton]! {
        didSet {
            var countOfImages = 0
            for index in 0..<themeButtons.count {
                let image = UIImage(named: imageNames[index])?.withAlpha(0.6)
                themeButtons[index].setImage(image, for: .normal)
                themeButtons[index].imageView?.contentMode = .scaleAspectFill
                themeButtons[index].layer.cornerRadius = 15
                themeButtons[index].clipsToBounds = true
                countOfImages += 1
            }
        }
    }
    
    @IBAction func chooseThemeBasedOnButton(_ sender: Any)
    {
        guard let themeButton = (sender as? UIButton), let indexOfButton = themeButtons.firstIndex(of: themeButton) else {
            return
        }
        
        if let cvc = splitViewDetailConcentrationController
        {
            themeIndex = indexOfButton
            cvc.theme = choosenTheme
        } else if let cvc = lastSeguedToConcentrationViewController {
                themeIndex = indexOfButton
                cvc.theme = choosenTheme
            navigationController?.pushViewController(cvc, animated: true)
        }
        else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "Choose Theme"
        {
            if let themeButton = (sender as? UIButton), let indexOfButton = themeButtons.firstIndex(of: themeButton)
            {
                themeIndex = indexOfButton
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = choosenTheme
                    cvc.hidesBottomBarWhenPushed = true
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
}

extension UIImage {
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
}
