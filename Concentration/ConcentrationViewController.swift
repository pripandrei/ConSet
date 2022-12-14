//
//  ViewController.swift
//  Concentration
//
//  Created by Andrei Pripa on 8/20/22.
//
import UIKit

class ConcentrationViewController: UIViewController {
    
    override func viewDidLoad() {
        setTheme()
        updateViewFromModel()
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: (buttonsFromFrontLayer.count + 1) / 2)
    private var emoji = [CardConcentration:String]()
    private var cardBackColor: UIColor?
    private var indexOfTouchedCard = 0
    private var indexOfCardsToBeCurlDown = [Int]()
    private var emojisOfCurrentTheme = String()
    
    var defaultTheme: [String : Any]? = [
            "icons": "🎹🎼🎧🎸🪘🎻🪗🎺🎷",
            "backgroundColor" : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
            "cardColor": #colorLiteral(red: 0.7352408183, green: 0.5866306935, blue: 0.6192299884, alpha: 1)
    ]
    
    var numberOfPairsOfCards: Int {
        return (buttonsFromFrontLayer.count + 1) / 2
    }
    
     lazy var theme = defaultTheme {
        didSet {
            emoji = [:]
            setTheme()
            updateViewFromModel()
        }
    }
    
    private(set) var flipCount = 0
    {
        didSet {
            flipCountLable.text = "Flips: \(flipCount)"
            flipCountLable.sizeToFit()
        }
    }
    
    var scoreCount = 0
    {
        didSet {
            scoreLable.text = "Score: \(scoreCount)"
            scoreLable.sizeToFit()
        }
    }
    
    @IBOutlet private weak var scoreLable: UILabel! {
        didSet {
            updateScoreCountLable()
        }
    }
    
    @IBOutlet private weak var flipCountLable: UILabel! {
        didSet {
            updateFlipCountLable()
        }
    }
    
    @IBOutlet private weak var startNewGame: UIButton! {
        didSet {
            startNewGame.layer.cornerRadius = 10.0
            startNewGame.layer.shadowRadius = 10
            startNewGame.layer.shadowColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            startNewGame.layer.shadowOpacity = 2.0
            startNewGame.layer.shadowOffset = CGSize(width: 1, height: 1)

        }
    }
    
    var attributesForScoreAndCountLables: [NSAttributedString.Key:Any] = [
        .foregroundColor: #colorLiteral(red: 0.147487998, green: 0.4161318243, blue: 0.5956266522, alpha: 1),
        .strokeWidth: -4,
    ]
    
    @IBOutlet var buttonsFromFrontLayer: [UIButton]!
    {
        didSet {
            for button in buttonsFromFrontLayer {
                button.layer.cornerRadius = 5
                button.backgroundColor = #colorLiteral(red: 0.664758265, green: 0.2567061186, blue: 0.635348022, alpha: 1)
            }
        }
    }
    
    @IBOutlet var buttonsFromBehindLayer: [UIButton]! {
        didSet {
            for button in buttonsFromBehindLayer {
                button.layer.cornerRadius = 5
                button.layer.shadowRadius = 3
                button.layer.shadowOpacity = 0.65
                button.layer.shadowOffset = CGSize(width: 2, height: 4)
                button.layer.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
                button.backgroundColor = #colorLiteral(red: 0.664758265, green: 0.2567061186, blue: 0.635348022, alpha: 1)
            }
        }
    }
    
//    @objc func touchTestButton(_ recognizer: UITapGestureRecognizer) {
//        switch recognizer.state {
//        case .ended:
//            let asView = recognizer.view!
//                UIView.transition(with: asView, duration: 4.7, options: [.transitionCurlDown], animations: {
//                })
//        default: return
//        }
//    }
    
    private func updateScore() {
        scoreCount = game.scoreCount
    }
    
    private func updateScoreCountLable() {
        if let score = scoreLable {
            score.attributedText = NSAttributedString(string: "Score: \(scoreCount)", attributes: attributesForScoreAndCountLables)
            flipCountLable.sizeToFit()
        }
    }
    
    private func updateFlipCountLable() {
        if let countLable = flipCountLable {
            let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributesForScoreAndCountLables)
            countLable.attributedText = attributedString
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = buttonsFromFrontLayer.firstIndex(of: sender) {
            indexOfTouchedCard = cardNumber
            indexOfCardsToBeCurlDown.append(cardNumber)
            game.chooseCard(at: cardNumber)
            flipCount = game.flipCount
            scoreCount = game.scoreCount
            updateViewFromModel()
        }
    }
    
    func resetView() {
        buttonsFromFrontLayer.forEach { $0.isHidden = true; $0.isHidden = false }
        buttonsFromBehindLayer.forEach { $0.isHidden = true; $0.isHidden = false }
    }
    
    @IBAction private func newGameButtonTouched(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emoji = [:]
        flipCount = 0
        setTheme()
        scoreCount = game.scoreCount
        resetView()
        updateViewFromModel()
//        startNewGame.sendActions(for: .touchUpInside)
        switch sender.state {
        case .focused: startNewGame.bounds = startNewGame.bounds.insetBy(dx: 30, dy: 30)
        default: break
        }
    }
    
    private func updateViewFromModel() {
    
        if buttonsFromFrontLayer != nil {
            
            for index in self.buttonsFromFrontLayer.indices{
                let button = self.buttonsFromFrontLayer[index]
                let card = game.cards[index]
                let behindButton = buttonsFromBehindLayer[index]
                behindButton.backgroundColor = self.view.backgroundColor
                
                if card.isFaceUp {
                    if index == indexOfTouchedCard {
                        UIView.transition(with: button, duration: 0.7, options: [.transitionCurlUp], animations: {
                            button.backgroundColor = #colorLiteral(red: 0.7517526746, green: 0.2261639833, blue: 0.4292668104, alpha: 1)
                        })
                    }
                    button.setTitle((emoji(for: card)), for: .normal)
                    button.titleLabel?.minimumScaleFactor = 0.65
                    button.titleLabel?.adjustsFontSizeToFitWidth = true
                    button.titleLabel?.textAlignment = .center
                    
                } else {
                    if indexOfCardsToBeCurlDown.contains(index), !card.isMatched{
                        UIView.transition(with: button, duration: 0.7, options: [.transitionCurlDown], animations: {
                            button.setTitle("", for: .normal)
                            self.indexOfCardsToBeCurlDown = self.indexOfCardsToBeCurlDown.filter { $0 != index }
                        })
                    }
                    if card.isMatched {
                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.0, animations: {
                            behindButton.isHidden = true
                            button.isHidden = true
                        })
                    } else {
                        button.backgroundColor = self.cardBackColor
                    }
                        button.setTitle("", for: .normal)
                }
            }
        }
    }
    
    private func emoji(for card: CardConcentration) -> String {
        
        if emoji[card] == nil, emojisOfCurrentTheme.count > 0 {
            let randomEmoji = emojisOfCurrentTheme.index(emojisOfCurrentTheme.startIndex, offsetBy: emojisOfCurrentTheme.count.arc4random)
            emoji[card] = String(emojisOfCurrentTheme.remove(at: randomEmoji))
        }
        return emoji[card] ?? "?"
    }
    
    private func setTheme() {
        
        if emoji.isEmpty {
            if let emojies = theme?["icons"] {
                emojisOfCurrentTheme = emojies as! String
            }
        }
        
        if let cardBackgroundColor = theme?["cardColor"] {
            cardBackColor = cardBackgroundColor as? UIColor
        }
        
        if let backgroundCardColor = theme?["backgroundColor"] as? UIColor {
            view.backgroundColor = backgroundCardColor
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int.random(in: 0..<abs(self))
        } else if self < 0 {
            return Int.random(in: 0..<self)
        } else {
            return 0
        }
    }
}



//    func toggleTabbar() {
//        guard var frame = tabBarController?.tabBar.frame else { return }
//        let hidden = frame.origin.x != view.frame.origin.x
//        frame.origin.x = hidden ? frame.origin.x + frame.size.width : -view.frame.size.width
//        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.25, delay: 0.0,options: [.curveEaseOut], animations: {
//            self.tabBarController?.tabBar.frame = frame
//        })
//    }


//        override var hidesBottomBarWhenPushed: Bool {
//            get {
//                return navigationController?.topViewController == self
//            }
//            set {
//                super.hidesBottomBarWhenPushed = newValue
//            }
//        }
