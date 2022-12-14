//
//  ViewController.swift
//  Set_Game
//
//  Created by Andrei Pripa on 9/16/22.
//

import UIKit

class TestIntegrationViewController: UIViewController {
    
    private(set) var setIsPresentInChoosenCards = false
    private var setCards = [CardSet]()
    private var threeSetCards = [UIView]()
    private var shouldDealThreeCards = false
    private var firstTimeDeal = true
    private var game = SetGame()
    private var firstTimeLayoutSubviews = true
    private var gameStart = true
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(animator)
    
    var cardsViews = [CardsView]()
    {
        didSet {
            for view in cardsViews {
                if let index = cardsViews.firstIndex(of: view) {
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(buttonAction(_:)))
                    cardsViews[index].addGestureRecognizer(tap)
                }
            }
        }
    }
    
    var setCount: Int = 0
    {
        didSet
        {
            if let setTextTitleOnDiscardPile = setTextTitleOnDiscardPile
            {
                setTextTitleOnDiscardPile.attributedText = setCount <= 1 ? NSAttributedString(string: "\(setCount)", attributes: attributedTextForSetCount) : NSAttributedString(string: "\(setCount)", attributes: attributedTextForSetCount)
            }
        }
    }
    
    var scoreCountDecorator: NSAttributedString {
        get {
            let label = NSAttributedString(string: "Score \(scoreCount)", attributes: attributedTextForScoreLable)
            return label
        }
    }
        
    var scoreCount = Int() {
        didSet {
            if let scoreLable = scoreLabelOrigin {
                scoreLable.attributedText = scoreCountDecorator
            }
        }
    }
    
    private let attributedTextForScoreLable: [NSAttributedString.Key:Any] = [
        .foregroundColor : #colorLiteral(red: 0.7960312963, green: 0.6205748916, blue: 0.5277707577, alpha: 1),
        .strokeWidth: 3
    ]
    
    private let attributedTextForSetCount: [NSAttributedString.Key:Any] = [
        .foregroundColor : #colorLiteral(red: 0.44463709, green: 0.2662724555, blue: 0.2968143821, alpha: 1),
        .strokeWidth: -7
    ]
    
    @IBOutlet weak var dealThreeMoreCardButton: UIButton!
    @IBOutlet weak var setTextTitleOnDiscardPile: UITextField!
    
    @IBOutlet weak var cardsBoardView: CardsBoardView! {
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreCardsWithSwipe))
            swipe.direction = .down
            cardsBoardView.addGestureRecognizer(swipe)
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCardsWithRotation))
            cardsBoardView.addGestureRecognizer(rotate)
        }
    }
    
    
    
    @IBOutlet weak var discardPileUIImageView: UIImageView!
//    {
//        didSet {
//            let tap = UITapGestureRecognizer(target: self, action: #selector(showSetByPressingScore))
//            discardPileUIImageView.isUserInteractionEnabled = true
//            discardPileUIImageView.addGestureRecognizer(tap)
//        }
//    }
    
    
    @IBOutlet weak var scoreLabel: UITextField!
    
//    @IBOutlet weak var discardPile: UILabel! {
//        didSet {
//            let tap = UITapGestureRecognizer(target: self, action: #selector(dealThreeCardsWhenSetLableIsTaped))
//            discardPile.addGestureRecognizer(tap)
//            discardPile.isUserInteractionEnabled = true
//        }
//    }
    
    @IBOutlet weak var scoreLabelOrigin: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(showSetByPressingScore))
            scoreLabelOrigin.isUserInteractionEnabled = true
            scoreLabelOrigin.addGestureRecognizer(tap)
            scoreLabelOrigin.attributedText = scoreCountDecorator
        }
    }

//    @IBOutlet weak var setButton: UIButton! {
//        didSet {
//            var configuration = UIButton.Configuration.filled()
//            configuration.image = UIImage(named: "backCardIamage")
//            configuration.title = "Set"
//            configuration.imagePadding = -76
//            configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30)
//            setButton.tintColor = .clear
//            setButton.configuration = configuration
//        }
//    }
//
//    @IBOutlet weak var discardPileUIImageView: UIImageView! {
//        didSet {
//            let tap = UITapGestureRecognizer(target: self, action: #selector(dealThreeCardsWhenSetLableIsTaped))
//            discardPileUIImageView.addGestureRecognizer(tap)
//            discardPileUIImageView.isUserInteractionEnabled = true
//        }
//    }
    
    @IBOutlet weak var restartImageView: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(restartOnTapImageView))
            restartImageView.addGestureRecognizer(tap)
            restartImageView.isUserInteractionEnabled = true
        }
    }
    
    @objc private func restartOnTapImageView(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            game = SetGame()
            gameStart = true
            firstTimeDeal = true
//            firstTimeLayoutSubviews = true
            scoreCount = 0
            pushCardsOnRestart()
            _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { _ in
                self.removeViewsFromSuperView()
                self.createCardViews()
                self.updateView()
                self.cardsBoardView.setNeedsDisplay()
                self.setCount = 0
            })
        default: break
        }
    }
    
    @IBAction func newGameButton(_ sender: UIButton)
    {
        game = SetGame()
        gameStart = true
        firstTimeDeal = true
        pushCardsOnRestart()
        _ = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false, block: { _ in
            self.removeViewsFromSuperView()
            self.createCardViews()
            self.updateView()
            self.cardsBoardView.setNeedsDisplay()
            self.setCount = 0
        })
    }
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton)
    {
        self.view.isUserInteractionEnabled = false
        _ = Timer.scheduledTimer(withTimeInterval: 2.3, repeats: false, block: { timer in
            self.view.isUserInteractionEnabled = true
            timer.invalidate()
        })
        addThreeMoreCards()
        dealThreeCards()
    }
    
    @objc func showSetByPressingScore(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended: showSet()
        default: break
        }
    }
    
    @objc func shuffleCardsWithRotation(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .ended:
            game.shuffleCards()
            updateView()
        default: break
        }
    }

    @objc private func dealThreeCardsWhenSetLableIsTaped(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended: addThreeMoreCards()
            dealThreeCards()
        default: break
        }
    }
    
    @objc func dealThreCardsWithSwipe(_ gesture: UISwipeGestureRecognizer)
    {
        if game.cardsOnTable == game.playingCards.count
        {
            if let recognizer = cardsBoardView.gestureRecognizers?.first
            {
                cardsBoardView.removeGestureRecognizer(recognizer)
            }
            return
        }
        
        switch gesture.state
        {
        case .ended: addThreeMoreCards()
        default: break
        }
    }
    
    @objc func buttonAction(_ sender: UITapGestureRecognizer)
    {
        let senderView = sender.view! as? CardsView
        
        if let cardIndex = cardsViews.firstIndex(of: senderView!)
        {
            switch sender.state {
            case .ended:
                game.chooseCard(at: cardIndex)
                updateView()
            default: break
            }
        }
        
        if game.playingCards.count <= 18, game.findAllSetsInDeck() == 0 {
            updateView()
        }
    }
    
    func showSet() {
        
        let setOnTable = game.findSetInCardsOnTable()
        
        if let cards = setOnTable {
            for card in cards {
                let index = game.playingCards.firstIndex(of: card)!
                let button = cardsViews[index]
                
                let colorForSelectedButton = #colorLiteral(red: 0.09182011336, green: 0.5400947332, blue: 0.3297850788, alpha: 1).cgColor
                let borderWidth = 3.0
                
                button.layer.borderWidth = borderWidth
                button.layer.borderColor = colorForSelectedButton
            }
        }
    }
    
    func createCardViews()
    {
        let upperRange = gameStart ? game.cardsOnTable : 3
        var viewVish = [CardsView]()
        for _ in 0..<upperRange
        {
            let cardView = CardsView()
            cardsBoardView.layoutIfNeeded()
            
            cardView.isUserInteractionEnabled = true
            cardView.layer.masksToBounds = true
            cardView.layer.cornerRadius = cardsBoardView.cornerRadious
            viewVish.append(cardView)
            cardsBoardView.addSubview(cardView)
        }
        gameStart = false
        cardsViews += viewVish
    }
    
    func removeViewsFromSuperView()
    {
        for cardView in cardsViews {
            cardView.removeFromSuperview()
        }
        cardsViews = []
    }
    
    private func pushCardsOnRestart() {
        for card in cardsViews {
            cardBehavior.addItem(card)
            cardBehavior.toggleItemBehaviours = true
            UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
                self.cardBehavior.push(card)
            })
        }
    }
    
    func toggleDealMoreCardsButton() -> Bool {
        
        let firstSetCardTrue = game.playingCards.first { $0.cardIsSet == true }
        
        if firstSetCardTrue != nil {
            if game.cardsOnTable < game.playingCards.count { return true }
        } else {
            if game.cardsOnTable < game.playingCards.count && game.cardsOnTable != 24 { return true }
            return false
        }
        return false
    }
 
    private func checkIfDealMoreCardsNeedsToBeDisabled()
    {
        dealThreeMoreCardButton.isEnabled = game.cardsOnTable >= game.playingCards.count ? false : true
    }

    private func addThreeMoreCards()
    {
        createCardViews()
        cardsBoardView.setNeedsDisplay()
    }
    
    private func dealThreeCards() {
        shouldDealThreeCards = true
        game.manageThreeCardsButton()
        cardsBoardView.numberOfCardsToBeDisplayed = game.cardsOnTable
        updateView()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
//        self.view.sendSubviewToBack(self.setTextTitleOnDiscardPile)
//        self.view.bringSubviewToFront(self.setTextTitleOnDiscardPile)
//        self.view.sendSubviewToBack(self.discardPileUIImageView)
        createCardViews()
        gameStart = false
    }
    
    

    func removeFromSuperViewIfSet() {
        cardsViews = cardsViews.filter {
            if let isset = $0.isSet, isset {
                $0.removeFromSuperview()
            }
            return $0.isSet != true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        firstTimeLayoutSubviews = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if firstTimeLayoutSubviews {
            updateView()
            firstTimeLayoutSubviews = false
        }

//        firstTimeLayoutSubviews = false
        
        
//        if firstTimeLayoutSubviews {
//            updateView()
//            firstTimeLayoutSubviews = false
//        } else {
//            updateView()
////            firstTimeLayoutSubviews = true
//        }
    }
    
    private func setFeatures(for view: CardsView, with card: CardSet) {
        view.shapeStyle = card.shapeStyle
        view.colorStyle = card.colorStyle
        view.shadingStyle = card.shadingStyle
        view.number = card.number
        view.isSet = card.cardIsSet
        view.isSelected = card.isSelected
    }

    func createBackCardImage() -> UIImageView {
        let image = UIImage(named: "playCard5")
        let imageView = UIImageView(image:  image!)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        cardsBoardView.addSubview(imageView)
        imageView.bounds = dealThreeMoreCardButton.bounds.insetBy(dx: 5.0, dy: 6.5)
        imageView.center = imageView.convert(imageView.center, from: dealThreeMoreCardButton)
//        imageView.frame = dealThreeMoreCardButton.convert(dealThreeMoreCardButton.frame, from: dealThreeMoreCardButton).offsetBy(dx: -10, dy: -145)
        return imageView
    }
    
    func updateView() {
        if let _ = dealThreeMoreCardButton, let _ = cardsBoardView {
            
            checkIfDealMoreCardsNeedsToBeDisabled()
            cardsBoardView.numberOfCardsToBeDisplayed = game.cardsOnTable
            cardsBoardView.grid.frame = cardsBoardView.bounds

            var delay: CGFloat = 0.3
            for index in 0..<game.cardsOnTable {
                
                let card = game.playingCards[index]
                let viewOfCard = cardsViews[index]
                
                if let rect = cardsBoardView.grid[index] {
                    
                    let imageFromBackOfTheCard = createBackCardImage()
                    
                    if firstTimeDeal {
                        initiateFirstCardDealing(with: viewOfCard, imageView: imageFromBackOfTheCard, gridIndex: rect, card: card, delay: &delay)
                    }
                    else if !self.shouldDealThreeCards {
                        self.setFeatures(for: viewOfCard, with: card)
                        
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.2,
                            delay: 0.0,
                            animations: {
                                    if viewOfCard.isSelected {
                                        viewOfCard.frame = rect.insetBy(dx: 1.5, dy: 1.5)
                                    } else {
                                        viewOfCard.frame = rect.insetBy(dx: 4.0, dy: 4.0)
                                    }
                            }
                        )
                        imageFromBackOfTheCard.removeFromSuperview()
                        
                    } else if self.shouldDealThreeCards {
                        if !(((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index)
                        {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.5,
                                delay: 0.0,
                                animations: {
                                viewOfCard.frame = rect.insetBy(dx: 4.0, dy: 4.0)
                            })
                            imageFromBackOfTheCard.removeFromSuperview()
                        }
                        if ((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index
                        {
//                            viewOfCard.frame = self.dealThreeMoreCardButton.frame.insetBy(dx: 6.0, dy: 6.0)
//
//                            viewOfCard.center = self.dealThreeMoreCardButton.convert(self.dealThreeMoreCardButton.center, to: viewOfCard).offsetBy(dx: 9.0, dy: 2.5)
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.5,
                                delay: delay,
                                animations: {
                                    viewOfCard.frame = rect.insetBy(dx: 4.0, dy: 4.0)
                                    imageFromBackOfTheCard.frame = rect.insetBy(dx: -(rect.width / 4.5), dy: 4)
                                },
                                completion: { initial in
                                    UIView.transition(
                                        with: imageFromBackOfTheCard,
                                        duration: 0.5,
                                        options: .transitionFlipFromLeft,
                                        animations: {
                                            _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
                                                imageFromBackOfTheCard.layer.isHidden = true
                                                imageFromBackOfTheCard.removeFromSuperview()
                                            })
                                        }, completion: {_ in
                                            imageFromBackOfTheCard.removeFromSuperview()
                                        })
                                    UIView.transition(
                                        with: viewOfCard,
                                        duration: 0.5,
                                        options: .transitionFlipFromLeft,
                                        animations: {
                                            viewOfCard.backgroundColor = #colorLiteral(red: 0.2722899914, green: 0.1926242709, blue: 0.2153902054, alpha: 1)
                                            self.setFeatures(for: viewOfCard, with: card)
                                            self.shouldDealThreeCards = false
                                        })
                                })
                            delay += 0.5
                        }
                    }
                }
                if let cardIsSet = card.cardIsSet, cardIsSet {
                    threeSetCards.append(cardsViews[index])
                }
            }
            
            if !threeSetCards.isEmpty {
                handleThreeCardsWhenSet()
            }
            firstTimeDeal = false
            
            if let _ = scoreLabelOrigin {
                if game.scoreCount != scoreCount {
                    scoreCount = game.scoreCount
                }
            }
        }   
    }
    
    private func initiateFirstCardDealing(with cardView: CardsView, imageView: UIImageView, gridIndex: CGRect, card: CardSet, delay: inout CGFloat) {
        
        self.view.isUserInteractionEnabled = false
        _ = Timer.scheduledTimer(withTimeInterval: 2.3, repeats: false, block: { _ in
            self.view.isUserInteractionEnabled = true
        })
        
        cardView.frame = gridIndex
        cardView.frame.origin = CGPoint(x: cardsBoardView.frame.midX - (gridIndex.width / 1.7) , y: cardsBoardView.frame.midY - (gridIndex.height / 1.7))

        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.7,
            delay: delay,
            animations: {
                cardView.frame = gridIndex.insetBy(dx: 4.0, dy: 4.0)
                imageView.frame = gridIndex.insetBy(dx: -13, dy: 4)
            },
            completion: { initial in
                UIView.transition(
                    with: imageView,
                    duration: 1.0,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        imageView.frame = gridIndex.insetBy(dx: 4.0, dy: 4.0)
                        _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
                            imageView.layer.isHidden = true
                            imageView.removeFromSuperview()
                        })
                    })
                UIView.transition(
                    with: cardView,
                    duration: 1.0,
                    options: [.transitionFlipFromLeft],
                    animations: {
                        cardView.backgroundColor = #colorLiteral(red: 0.2722899914, green: 0.1926242709, blue: 0.2153902054, alpha: 1)
                        self.setFeatures(for: cardView, with: card)
                    })
            })
        delay += 0.1
    }
    
    private func handleThreeCardsWhenSet() {
        self.view.isUserInteractionEnabled = false
        self.game.updatePlayingCards()
        addThreeMoreCards()
        
        var delayForReplacedCards = 0.0
        var indexOfSelectedCards = [Int]()
        
        for index in 0..<self.threeSetCards.count {
            
            let discardOrigin = self.discardPileUIImageView.center
            self.threeSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            cardBehavior.addItem(self.threeSetCards[index])
            cardBehavior.toggleItemBehaviours = false
            cardBehavior.collision.translatesReferenceBoundsIntoBoundary = true
            
            guard let indexOfreplacedCard2 = cardsViews.firstIndex(of: threeSetCards[index] as! CardsView) else {
                return
            }
            indexOfSelectedCards.append(indexOfreplacedCard2)
            
//            if let indexOfreplacedCard = cardsViews.firstIndex(of: selectedSetCards[index] as! CardsView) {
//                indexOfSelectedCards.append(indexOfreplacedCard)
//            }
            
            let indexOfAddedView2 = cardsViews.endIndex - index - 1
            cardsViews.swapAt(indexOfAddedView2, indexOfSelectedCards[index])
            let replacedCardView2 = cardsViews[indexOfSelectedCards[index]]
            let imageView = createBackCardImage()
//            imageView.contentMode = .scaleAspectFill
//            imageView.bounds = imageView.bounds.insetBy(dx: 0.0, dy: 20.0)
            
            UIView.animate(
                withDuration: 0.5,
                delay: delayForReplacedCards,
                animations: {
                    if let rec = self.cardsBoardView.grid[indexOfreplacedCard2] {
                        replacedCardView2.frame = rec.insetBy(dx: 4.0, dy: 4.0)
                    }
                    imageView.frame = self.threeSetCards[index].frame.insetBy(dx: -17, dy: 0.0)
                    delayForReplacedCards += 0.4
                }, completion: { _ in
                    
                    UIView.transition(
                        with: imageView,
                        duration: 0.7,
                        options: [.transitionFlipFromLeft],
                        animations: {
                        _ = Timer.scheduledTimer(withTimeInterval: 0.35, repeats: false, block: { _ in
                            imageView.layer.isHidden = true
                            imageView.removeFromSuperview()
                        })
                    })
                    
                    UIView.transition(
                        with: replacedCardView2,
                        duration: 0.7,
                        options: [.transitionFlipFromLeft],
                        animations: {
                        self.setFeatures(for: replacedCardView2 , with: self.game.playingCards[indexOfSelectedCards[index]])
                        replacedCardView2.backgroundColor = #colorLiteral(red: 0.2722899914, green: 0.1926242709, blue: 0.2153902054, alpha: 1)
                    })
                })
            
            UIView.animate(
                withDuration: 1.3,
                delay: 0.0,
                options: .curveEaseIn,
                animations: {
                    self.threeSetCards[index].layer.opacity = 0.99
                },
                completion:  {_ in
                    for item in self.threeSetCards {
                        self.cardBehavior.removeItem(item)
                    }
                    UIView.animate(
                        withDuration: 0.4,
                        delay: 0.0,
                        animations: {
                            self.threeSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                            self.cardBehavior.addSnapItem(self.threeSetCards[index], discardOrigin)
                            self.threeSetCards[index].bounds = self.discardPileUIImageView.bounds
                            self.threeSetCards[index].layer.borderWidth = 0.0
                        },
                        completion: {_ in
                            UIView.animate(
                                withDuration: 0.8,
                                delay: 0.0,
                                animations: {
                                    self.threeSetCards[index].layer.opacity = 1.0
                                },
                                completion: {_ in
                                    UIView.transition(
                                        with: self.discardPileUIImageView,
                                        duration: 0.5,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
                                                self.threeSetCards[index].layer.isHidden = true
                                            })
                                        })
                                    UIView.transition(
                                        with: self.setTextTitleOnDiscardPile,
                                        duration: 0.5,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                        
                                    })
                                    UIView.transition(
                                        with: self.threeSetCards[index],
                                        duration: 0.5,
                                        options: [.transitionFlipFromLeft],
                                        animations: {
                                            self.threeSetCards[index].backgroundColor = UIColor.orange
                                        },
                                        completion: {_ in
                                            self.removeFromSuperViewIfSet()
                                            self.cardsBoardView.setNeedsDisplay()
                                            self.threeSetCards = []
                                            self.view.isUserInteractionEnabled = true
                                        })
                                })
                        })
                })
            self.threeSetCards[index].layer.zPosition = 1
        }
        self.setCount += 1
    }
}

extension Array {
    func indexExists(_ index: Int) -> Bool {
        return self.indices.contains(index)
    }
}
