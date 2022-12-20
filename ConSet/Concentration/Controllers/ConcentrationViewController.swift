
import UIKit

class ConcentrationViewController: UIViewController {
    
    private lazy var game = Concentration(numberOfPairsOfCards: (buttonsFromFrontLayer.count + 1) / 2)
    private var emoji = [CardConcentration:String]()
    private var cardBackColor: UIColor?
    private var indexOfTouchedCard = 0
    private var indexOfCardsToBeCurlDown = [Int]()
    private var emojisOfCurrentTheme = String()
    
    private(set) var flipCount = 0
    {
        didSet {
            flipCountLable.text = "Flips: \(flipCount)"
            flipCountLable.sizeToFit()
        }
    }
    
    private var customTabBarController: CustomTabBarController? {
        return tabBarController as? CustomTabBarController
    }
    
    
    
    private var attributesForScoreAndCountLables: [NSAttributedString.Key:Any] = [
        .foregroundColor: ConcentrationGraphicColor.scoreAndCoundLablesColor,
        .strokeWidth: -4,
    ]
    
    var defaultTheme: [String : Any]? = [
            "icons": "🎹🎼🎧🎸🪘🎻🪗🎺🎷",
            "backgroundColor" : ConcentrationGraphicColor.ThemeColor.musicBackgroundColor,
            "cardColor": ConcentrationGraphicColor.ThemeColor.musicCardColor
    ]
    
    lazy var theme = defaultTheme {
        didSet {
            emoji = [:]
            setTheme()
            updateViewFromModel()
        }
    }
    
    var numberOfPairsOfCards: Int {
        return (buttonsFromFrontLayer.count + 1) / 2
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
            adjustShadow(for: scoreLable)
        }
    }
    
    @IBOutlet private weak var flipCountLable: UILabel! {
        didSet {
            updateFlipCountLable()
            adjustShadow(for: flipCountLable)
        }
    }
    
    @IBOutlet private weak var startNewGame: UIButton! {
        didSet {
            adjustShadow(for: startNewGame)
        }
    }
    
    @IBOutlet var buttonsFromFrontLayer: [UIButton]!
    {
        didSet {
            for button in buttonsFromFrontLayer {
                button.layer.cornerRadius = 5
//                button.backgroundColor = #colorLiteral(red: 0.664758265, green: 0.2567061186, blue: 0.635348022, alpha: 1)
            }
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
    
    @IBAction private func newGameButtonTouched(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emoji = [:]
        flipCount = 0
        setTheme()
        scoreCount = game.scoreCount
        resetView()
        updateViewFromModel()
        switch sender.state {
        case .focused: startNewGame.bounds = startNewGame.bounds.insetBy(dx: 30, dy: 30)
        default: break
        }
    }
    
    @IBOutlet var buttonsFromBehindLayer: [UIButton]! {
        didSet {
            for button in buttonsFromBehindLayer {
                button.layer.cornerRadius = 5
                button.layer.shadowRadius = 3
                button.layer.shadowOpacity = 0.65
                button.layer.shadowOffset = CGSize(width: 2, height: 3)
//                button.layer.shadowColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
//                button.backgroundColor = #colorLiteral(red: 0.664758265, green: 0.2567061186, blue: 0.635348022, alpha: 1)
            }
        }
    }
    
    override func viewDidLoad() {
        setTheme()
        updateViewFromModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let customTabBarController = customTabBarController {
            customTabBarController.blockRotation = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let customTabBarController = customTabBarController {
            customTabBarController.blockRotation = true
        }
    }
    
    private func adjustShadow(for viewType: UIView) {
        viewType.layer.cornerRadius = 10.0
        viewType.layer.shadowRadius = 7.0
        viewType.layer.shadowColor = ConcentrationGraphicColor.flipScoreNewGameShadowColor.cgColor
        viewType.layer.shadowOpacity = 2.0
        viewType.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
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
    
    func resetView() {
        buttonsFromFrontLayer.forEach { $0.isHidden = true; $0.isHidden = false }
        buttonsFromBehindLayer.forEach { $0.isHidden = true; $0.isHidden = false }
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
                            button.backgroundColor = ConcentrationGraphicColor.revealedCardColor
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
