//
//  ThemeChooseViewController.swift
//  Concentration
//
//  Created by Andrei Pripa on 11/6/22.
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
            "icons": Emoji.sportEmoji,
            "backgroundColor" : ConcentrationGraphicColor.ThemeColor.sportsBackgroundColor,
            "cardColor": ConcentrationGraphicColor.ThemeColor.sportsCardColor
        ],
        "People": [
            "icons": Emoji.peopleEmoji,
            "backgroundColor" : ConcentrationGraphicColor.ThemeColor.peopleBackgroundColor,
            "cardColor": ConcentrationGraphicColor.ThemeColor.peopleCardColor
        ],
        "Animals": [
            "icons": Emoji.animalEmoji,
            "backgroundColor" : ConcentrationGraphicColor.ThemeColor.animalBackgroundColor,
            "cardColor": ConcentrationGraphicColor.ThemeColor.animalCardColor
        ],
        "Music": [
            "icons": Emoji.musicEmoji,
            "backgroundColor" : ConcentrationGraphicColor.ThemeColor.musicBackgroundColor,
            "cardColor": ConcentrationGraphicColor.ThemeColor.musicCardColor
        ],
        "Food": [
            "icons": Emoji.foodEmoji,
            "backgroundColor" : ConcentrationGraphicColor.ThemeColor.foodBackgroundColor,
            "cardColor": ConcentrationGraphicColor.ThemeColor.foodCardColor
        ],
        "Weather": [
            "icons": Emoji.weatherEmoji,
            "backgroundColor" : ConcentrationGraphicColor.ThemeColor.weatherBackgroundColor,
            "cardColor": ConcentrationGraphicColor.ThemeColor.weatherCardColor
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
    
    /// splitsplitViewController was removed
    ///
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
//        return true
//    }
    
}

extension UIImage {
    func withAlpha(_ a: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
            draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
        }
    }
}
