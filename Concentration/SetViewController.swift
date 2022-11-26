//
//  ViewController.swift
//  Set_Game
//
//  Created by Andrei Pripa on 4/15/22.
//

import UIKit

class SetViewController: UIViewController {
    
    
    @IBOutlet weak var cardsBoardView: CardsBoardView! {
        didSet {
                   let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreCardsWithSwipe))
                   swipe.direction = .down
                   cardsBoardView.addGestureRecognizer(swipe)
                   let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCardsWithRotation))
                   cardsBoardView.addGestureRecognizer(rotate)
               }
    }
    
    
//    @IBOutlet weak var cardsBoardView: CardsBoardView! {
//        didSet {
//            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(dealThreCardsWithSwipe))
//            swipe.direction = .down
//            cardsBoardView.addGestureRecognizer(swipe)
//            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(shuffleCardsWithRotation))
//            cardsBoardView.addGestureRecognizer(rotate)
//        }
//    }
    
    @objc func shuffleCardsWithRotation(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .ended:
            game.shuffleCards()
            updateView()
        default: break
        }
    }
    
    @IBOutlet weak var setLable: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(dealThreeCardsWhenSetLableIsTaped))
            setLable.addGestureRecognizer(tap)
            setLable.isUserInteractionEnabled = true
        }
    }
    
    @objc private func dealThreeCardsWhenSetLableIsTaped(_ gesture: UITapGestureRecognizer) {
        switch gesture.state {
        case .ended: addThreeMoreCards()
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
    
    var cardsViews = [CardsView]()
    {
        didSet {
            for view in cardsViews {
                if let index = cardsViews.firstIndex(of: view) {
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(buttonAction(_:)))
                    cardsViews[index].addGestureRecognizer(tap)
//                    print(view.isUserInteractionEnabled)
//                    print(index)
                }
            }
        }
    }
    
    private var setCount: Int = 0 {
        didSet {
//            discardPile.text = setCount == 0 ? "Set" : "\(setCount) Set's"
        }
    }

    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior = CardBehavior(animator)
    
//    lazy var collision: UICollisionBehavior = {
//        let collisionBehavior = UICollisionBehavior()
//        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
//        animator.addBehavior(collisionBehavior)
//        return collisionBehavior
//    }()
    
//    lazy var itemBehavior: UIDynamicItemBehavior = {
//        let behavior = UIDynamicItemBehavior()
//        behavior.allowsRotation = true
//        behavior.elasticity = 1.0
//        behavior.resistance = 0.0
//        animator.addBehavior(behavior)
//        return behavior
//    }()
//
//    private func itemPush(_ item: UIDynamicItem) {
////        itemPushBehavior.addItem(item)
//        let push = UIPushBehavior(items: [item], mode: .instantaneous)
//        push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
//        push.magnitude = 7
////        push.action = { [unowned push] in
////            push.dynamicAnimator?.removeBehavior(push)
////        }
//        animator.addBehavior(push)
//    }
    
//    var senderItem = UIView()
//
//    var previous = UIView()
    
//    lazy var pushItem: UIPushBehavior = {
//        let push = UIPushBehavior()
//        push.removeItem(previous)
//        push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
//        push.magnitude = 1.1
//        push.active = true
////        push.action = { [unowned push] in
////            push.dynamicAnimator?.removeBehavior(push)
////        }
//            animator.addBehavior(push)
//        previous = senderItem
//        return push
//        }()
    
//    var count = 0
    
//    var previuousItemPushed: UIView?

    @objc func buttonAction(_ sender: UITapGestureRecognizer)
    {
        let senderView = sender.view!

        if let cardIndex = cardsViews.firstIndex(of: senderView as! CardsView)
        {
            switch sender.state {
            case .ended:
                game.chooseCard(at: cardIndex)
//                updateView()

                if let _ = sender.view as? CardsView {
                    updateView()
                }
            default: break
            }
        }

    //        updateView()
//        game.updatePlayingCards()

        if game.playingCards.count <= 18, game.findAllSetsInDeck() == 0 {
            updateView()
        }
    }
    
    var game = SetGame()
    
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
    
    //    var selectedCards = [Card]() {
    //        didSet(newVal) {
    //            if let lastValue = newVal.last, newVal.count == 3 {
    //                selectedCards = [lastValue]
    //            }
    //        }
    //    }
    
    var scoreCount = Int() {
        didSet {
            scoreLabel.text = "Score: \(scoreCount)"
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var dealThreeMoreCardButton: UIButton!
    
    
    @IBOutlet var discardPile: UILabel! {
        didSet {
            //            self.discardPile.bringSubviewToFront(cardsBoardView)
        }
    }
    
    @IBAction func showSet(_ sender: UIButton) {
        
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
        //        print(setOnTable)
    }
    
    // MARK: Modify createCardView function to: createCardViews(defaultParam: game.CardsOnTable, optionalParam: int?)
    
    var initiatedCardsNumber = 0
    
    var gameStart = true
    
    func createCardViews()
    {
        let upperRange = gameStart ? game.cardsOnTable : 3
        var viewVish = [CardsView]()
        for _ in 0..<upperRange
        {
            let cardView = CardsView()
            cardView.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
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
    
    @IBAction func newGameButton(_ sender: UIButton)
    {
        //        cardsBoardView = cardsBoardView!
        game = SetGame()
        gameStart = true
        firstTimeDeal = true
//        cardsBoardView.firstTimeDeal = true
        removeViewsFromSuperView()
        createCardViews()
        updateView()
        cardsBoardView.setNeedsDisplay()
        setCount = 0
    }
    
    private func startNewGame() {
        
    }
    
    private func checkIfDealMoreCardsNeedsToBeDisabled()
    {
        dealThreeMoreCardButton.isEnabled = game.cardsOnTable >= game.playingCards.count ? false : true
    }
    
    private func addThreeMoreCards()
    {
//        shouldDealThreeCards = true
        cardsBoardView.setNeedsDisplay()
//        game.manageThreeCardsButton()
        checkIfDealMoreCardsNeedsToBeDisabled()
        createCardViews()
//        cardsBoardView.numberOfCardsToBeDisplayed = game.cardsOnTable
//        updateView()
    }
    
    private var shouldDealThreeCards = false
    
    @IBAction func dealThreeMoreCards(_ sender: UIButton)
    {
        //        shouldDealThreeCards = true
        //        cardsBoardView.setNeedsDisplay()
        shouldDealThreeCards = true
        game.manageThreeCardsButton()
        addThreeMoreCards()
        cardsBoardView.numberOfCardsToBeDisplayed = game.cardsOnTable
        updateView()
    }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        if let discard = self.discardPile {
            
            self.view.sendSubviewToBack(self.discardPile)
            createCardViews()
        }
        
        
        gameStart = false
        //        updateView()
    }
    
    private(set) var setIsPresentInChoosenCards = false
    
    func removeFromSuperViewIfSet() {
        cardsViews = cardsViews.filter {
            if let isset = $0.isSet, isset {
                $0.removeFromSuperview()
            }
            return $0.isSet != true
        }
    }
    
    private var setCards = [CardSet]()
    private var selectedSetCards = [UIView]()
    
    var activated = false
    
    lazy var discardPile2: UILabel = {
        let discardPil = UILabel(frame: CGRect(x: 60.0, y: 60.0, width: 76.0, height:  110.0))
        discardPil.backgroundColor = UIColor.purple
        self.view.addSubview(discardPil)
        
        return discardPil
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if activated {
            updateView()
            activated = false
        } else {
            activated = true
        }
    }
    
    private func setFeatures(for view: CardsView, with card: CardSet) {
        view.shapeStyle = card.shapeStyle
        view.colorStyle = card.colorStyle
        view.shadingStyle = card.shadingStyle
        view.number = card.number
        view.isSet = card.cardIsSet
        view.isSelected = card.isSelected
    }
    
    private var firstTimeDeal = true
    
    private func updateView() {
        if let dealCheck = dealThreeMoreCardButton, let cardCheck = cardsBoardView {
            
            checkIfDealMoreCardsNeedsToBeDisabled()
            cardsBoardView.numberOfCardsToBeDisplayed = game.cardsOnTable
            cardsBoardView.grid.frame = cardsBoardView.bounds
            
            
            
            
            var delay = 0.3
            for index in 0..<game.cardsOnTable {
                
                let card = game.playingCards[index]
                let view = cardsViews[index]
                //            print(self.game.playingCards[1])
                //            if index == 1 {
                //                print("ee",card)
                //            }
                
                if let rect = cardsBoardView.grid[index] {
                    //            view.layer.masksToBounds = true
                    //            view.layer.cornerRadius = cardsBoardView.cornerRadious
                    
                    if firstTimeDeal {
                        view.frame = rect
                        view.frame.origin = CGPoint(x: cardsBoardView.frame.midX - (rect.width / 1.7) , y: cardsBoardView.frame.midY - (rect.height / 1.7))
                        
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.7,
                            delay: delay,
                            animations: {
                                view.frame = rect.insetBy(dx: 4.0, dy: 4.0)
                                delay += 0.1
                            },
                            completion: { initial in
                                UIView.transition(
                                    with: view,
                                    duration: 1.0,
                                    options: [.transitionFlipFromLeft],
                                    animations: {
                                        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                        self.setFeatures(for: view, with: card)
                                    })
                            })
                    }
                    else
                    //                if selectedSetCards.count != 3
                    {
                        //                    shouldDealThreeCards = true
                        UIViewPropertyAnimator.runningPropertyAnimator(
                            withDuration: 0.5,
                            delay: 0.0,
                            animations: {
                                if self.shouldDealThreeCards == false {
                                    view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
                                    self.setFeatures(for: view, with: card)
                                }
                                else {
                                    if !(((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index)
                                    {
                                        view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
                                    }
                                }
                            }
                        )
                        if ((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index && self.shouldDealThreeCards == true
                        {
                            view.frame.origin = self.dealThreeMoreCardButton.frame.origin.offsetBy(dx: -6.0, dy: -60.0)
                            
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.5,
                                delay: delay,
                                animations: {
                                    view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
                                },
                                completion: { initial in
                                    UIView.transition(
                                        with: view,
                                        duration: 0.5,
                                        options: .transitionFlipFromLeft,
                                        animations: {
                                            view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                                            self.setFeatures(for: view, with: card)
                                            self.shouldDealThreeCards = false
                                        })
                                })
                            delay += 0.5
                        }
                    }
                }
                if let cardIsSet = card.cardIsSet, cardIsSet {
                    selectedSetCards.append(cardsViews[index])
                }
            }
            
            if selectedSetCards.count == 3 {
                self.game.updatePlayingCards()
                
                //        createCardViews()
                addThreeMoreCards()
                //            print("Entered Selected cards", self.game.playingCards[1])
                //            self.shouldDealThreeCards = true
                var delayForReplacedCards = 0.0
                //            var indexToBeIncremented = 0
                //        var indexOfIncomingCardFromDeck = game.cardsOnTable
                var indexOfSelectedCards = [Int]()
                //        var indexCount = 0
                for index in 0..<self.selectedSetCards.count {
                    
                    let discardOrigin = self.discardPile.center
                    
                    //            let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
                    //            push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
                    //            push.magnitude = 7
                    
                    //            let snap = UISnapBehavior(item: self.selectedSetCards[index], snapTo: discardOrigin)
                    //            snap.damping = 0.55
                    
                    self.selectedSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                    
                    cardBehavior.addItem(self.selectedSetCards[index])
                    
                    //            self.itemBehavior.addItem(self.selectedSetCards[index])
                    //            self.collision.addItem(self.selectedSetCards[index])
                    //            self.animator.addBehavior(push)
                    
                    if let indexOfreplacedCard = cardsViews.firstIndex(of: selectedSetCards[index] as! CardsView) {
                        indexOfSelectedCards.append(indexOfreplacedCard)
                        //                indexOfSelectedCards.insert(indexOfreplacedCard, at: index)
                    }
                    
                    let indexOfAddedView2 = cardsViews.endIndex - index - 1
                    
                    cardsViews.swapAt(indexOfAddedView2, indexOfSelectedCards[index])
                    let replacedCardView2 = cardsViews[indexOfSelectedCards[index]]
                    
                    //            replacedCardView2.bounds = self.discardPile.bounds
                    //            replacedCardView2.bounds.size = self.discardPile.bounds.size
                    replacedCardView2.center = dealThreeMoreCardButton.frame.origin
                    //            replacedCardView2.center = discardPile.convert(discardPile.center, to: view)
                    //            print("s")
                    //            let replacedCardView = CardsView(frame: self.discardPile.frame)
                    //            replacedCardView.backgroundColor = #colorLiteral(red: 0.6642242074, green: 0.6642400622, blue: 0.6642315388, alpha: 1)
                    //            replacedCardView.isUserInteractionEnabled = true
                    //            replacedCardView.layer.masksToBounds = true
                    //            replacedCardView.layer.cornerRadius = cardsBoardView.cornerRadious
                    //
                    //            cardsBoardView.addSubview(replacedCardView)
                    //            cardsViews.append(replacedCardView)
                    //            let indexOfAddedView = cardsViews.firstIndex(of: replacedCardView)
                    //            cardsViews.swapAt(indexOfAddedView!, indexOfSelectedCards[0])
                    //            indexOfSelectedCards = indexOfSelectedCards.sorted(by: >)
                    
                    //                    self.cardsViews.insert(replacedCardView, at: indexOfSelectedCards[indexCount])
                    //            indexCount += 1
                    //                if let indexOfreplacedCard = cardsViews.firstIndex(of: selectedSetCards[index] as! CardsView) {
                    //                    indexOfSelectedCards.append(indexOfreplacedCard)
                    //                    print("indexPosition",indexOfreplacedCard)
                    ////                    var sd = cardsViews[indexOfreplacedCard]
                    //                    cardsViews[indexOfreplacedCard] = replacedCardView
                    //                }
                    //                replacedCardView = self.selectedSetCards[index]
                    //                self.cardsViews[index] = replacedCardView as! CardsView
                    
                    
                    //                self.cardsViews[index].center = self.discardPile.center
                    
                    UIView.animate(
                        withDuration: 0.5,
                        delay: delayForReplacedCards,
                        animations: {
                            replacedCardView2.frame = self.selectedSetCards[index].frame
                            delayForReplacedCards += 0.4
                        }, completion: { _ in
                            UIView.transition(with: replacedCardView2, duration: 0.7, options: [.transitionFlipFromLeft], animations: {
                                //                    self.game.updatePlayingCards()
                                self.setFeatures(for: replacedCardView2 , with: self.game.playingCards[indexOfSelectedCards[index]])
                                print("---Index",indexOfSelectedCards[0])
                                //                    print("Controller Card", self.game.playingCards[indexOfSelectedCards[0]])
                                replacedCardView2.backgroundColor = UIColor.white
                                //                    indexOfSelectedCards.remove(at: indexOfSelectedCards.endIndex - 1)
                                //                    indexOfSelectedCards.remove(at: 0)
                            })
                        })
                    
                    UIView.animate(
                        withDuration: 1.2,
                        delay: 0.0,
                        options: .curveEaseIn,
                        animations: {
                            self.selectedSetCards[index].layer.opacity = 0.99
                        },
                        completion:  {_ in
                            for item in self.selectedSetCards {
                                self.cardBehavior.removeItem(item)
                                //                        push.removeItem(item)
                                //                        self.collision.removeItem(item)
                                //                        self.itemBehavior.removeItem(item)
                            }
                            UIView.animate(
                                withDuration: 0.4,
                                delay: 0.0,
                                animations: {
                                    self.selectedSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                                    //                                       self.selectedSetCards[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
                                    
                                    self.cardBehavior.addSnapItem(self.selectedSetCards[index], discardOrigin)
                                    self.selectedSetCards[index].bounds = self.discardPile.bounds
                                    //                            self.animator.addBehavior(snap)
                                    self.selectedSetCards[index].layer.borderWidth = 0.0
                                },
                                completion: {_ in
                                    UIView.animate(
                                        withDuration: 0.8,
                                        delay: 0.0,
                                        animations: {
                                            self.selectedSetCards[index].layer.opacity = 1.0
                                        },
                                        completion: {_ in
                                            UIView.transition(
                                                with: self.discardPile,
                                                duration: 0.5,
                                                options: [.transitionFlipFromLeft],
                                                animations: {
                                                    _ = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false, block: { _ in
                                                        self.selectedSetCards[index].layer.isHidden = true
                                                    })
                                                })
                                            UIView.transition(
                                                with: self.selectedSetCards[index],
                                                duration: 0.5,
                                                options: [.transitionFlipFromLeft],
                                                animations: {
                                                    self.selectedSetCards[index].backgroundColor = UIColor.orange
                                                    //                                                if let indexOfreplacedCard = self.cardsViews.firstIndex(of: self.selectedSetCards[index] as! CardsView) {
                                                    //                                                    indexOfSelectedCards.append(indexOfreplacedCard)
                                                    ////                                                    print("indexPosition",indexOfreplacedCard)
                                                    //                                //                    var sd = cardsViews[indexOfreplacedCard]
                                                    ////                                                    self.cardsViews[indexOfreplacedCard] = replacedCardView
                                                    //                                                    self.cardsViews.insert(replacedCardView, at: index)
                                                    //                                                }
                                                },
                                                completion: {_ in
                                                    //                                                self.setCount += 1
                                                    self.removeFromSuperViewIfSet()
                                                    self.cardsBoardView.setNeedsDisplay()
                                                    //                                                self.game.updatePlayingCards()
                                                    self.selectedSetCards = []
                                                    //                                                for index in indexOfSelectedCards {
                                                    //
                                                    //                                                print(self.cardsViews.count)
                                                    //                                                    self.cardsViews.insert(replacedCardView, at: indexOfSelectedCards[indexToBeIncremented])
                                                    //                                                indexToBeIncremented += 1
                                                    //                                                }
                                                    //                                                self.updateView()
                                                    //                                                print("cardsView",self.cardsViews.count)
                                                })
                                        })
                                })
                        })
                    //                for index in indexOfSelectedCards {
                    //
                    //                    self.cardsViews.insert(replacedCardView, at: index)
                    //                }
                    self.selectedSetCards[index].layer.zPosition = 1
                    //            delayForReplacedCards += 0.7
                }
                self.setCount += 1
            }
            //        print("exit Selected cards", self.game.playingCards[1])
            firstTimeDeal = false
            
            if let _ = scoreLabel {
                scoreCount = game.scoreCount
            }
        }
    
    }
    
}

//extension Array {
//    func indexExists(_ index: Int) -> Bool {
//        return self.indices.contains(index)
//    }
//}
//
//extension UIApplication {
//    
//    static var keyWindow: UIWindow? {
//        // Get connected scenes
//        return UIApplication.shared.connectedScenes
//            // Keep only active scenes, onscreen and visible to the user
//            .filter { $0.activationState == .foregroundActive }
//            // Keep only the first `UIWindowScene`
//            .first(where: { $0 is UIWindowScene })
//            // Get its associated windows
//            .flatMap({ $0 as? UIWindowScene })?.windows
//            // Finally, keep only the key window
//            .first(where: \.isKeyWindow)
//    }
//    
//}





//extension Collection {
//    var notDisplayedRandomCard: Int? {
//        for card in SetGame().playingCards {
//            if card.cardIsSet == false {
//                return Int.random(in: ViewController().cardsToDisplay..<SetGame().playingCards.count)
//            }
//        }
//        return nil
//    }
//}

//extension Int {
//    var notDisplayedRandomCard: Int {
//        return Int.random(in: 24..<SetGame().playingCards.count)
//    }
//}
//




// --------- LAST WORKING VERSION
//
//private func updateView() {
//
//    checkIfDealMoreCardsNeedsToBeDisabled()
//    cardsBoardView.numberOfCardsToBeDisplayed = game.cardsOnTable
//    cardsBoardView.grid.frame = cardsBoardView.bounds
//
//    var delay = 0.3
//    for index in 0..<game.cardsOnTable {
//
//        let card = game.playingCards[index]
//        let view = cardsViews[index]
//
//        if let rect = cardsBoardView.grid[index] {
//            view.layer.masksToBounds = true
//            view.layer.cornerRadius = cardsBoardView.cornerRadious
//
//            if firstTimeDeal {
//                view.frame = rect
//                view.frame.origin = CGPoint(x: cardsBoardView.frame.midX - (rect.width / 1.7) , y: cardsBoardView.frame.midY - (rect.height / 1.7))
//
//                UIViewPropertyAnimator.runningPropertyAnimator(
//                    withDuration: 0.7,
//                    delay: delay,
//                    animations: {
//                        view.frame = rect.insetBy(dx: 4.0, dy: 4.0)
//                        delay += 0.1
//                    },
//                    completion: { initial in
//                        UIView.transition(
//                            with: view,
//                            duration: 1.0,
//                            options: [.transitionFlipFromLeft],
//                            animations: {
//                                view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                                self.setFeatures(for: view, with: card)
//                            })
//                    })
//            }
//            else
////                if selectedSetCards.count != 3
//            {
//                UIViewPropertyAnimator.runningPropertyAnimator(
//                    withDuration: 0.5,
//                    delay: 0.0,
//                    animations: {
//                        if self.shouldDealThreeCards == false {
//                            view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
//                            self.setFeatures(for: view, with: card)
//                        }
//                        else {
//                            if !(((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index)
//                            {
//                                view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
//                            }
//                        }
//                    }
//                )
//                if ((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index && self.shouldDealThreeCards == true
//                {
//                    view.frame.origin = self.dealThreeMoreCardButton.frame.origin.offsetBy(dx: -6.0, dy: -60.0)
//
//                    UIViewPropertyAnimator.runningPropertyAnimator(
//                        withDuration: 0.5,
//                        delay: delay,
//                        animations: {
//                            view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
//                        },
//                        completion: { initial in
//                            UIView.transition(
//                                with: view,
//                                duration: 0.5,
//                                options: .transitionFlipFromLeft,
//                                animations: {
//                                    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                                    self.setFeatures(for: view, with: card)
//                                    self.shouldDealThreeCards = false
//                                })
//                        })
//                    delay += 0.5
//                }
//            }
//        }
//        if let cardIsSet = card.cardIsSet, cardIsSet {
//            selectedSetCards.append(cardsViews[index])
//        }
//    }
//
//    if selectedSetCards.count == 3 {
////            self.shouldDealThreeCards = true
//        var delay = 0.5
//        for index in 0..<self.selectedSetCards.count {
//
//            let discardOrigin = self.discardPile.center
//
//            let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
//            push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
//            push.magnitude = 7
//
//            let snap = UISnapBehavior(item: self.selectedSetCards[index], snapTo: discardOrigin)
//            snap.damping = 0.55
//
//            self.selectedSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//            self.itemBehavior.addItem(self.selectedSetCards[index])
//            self.collision.addItem(self.selectedSetCards[index])
//            self.animator.addBehavior(push)
//
//            UIView.animate(
//                withDuration: 1.4,
//                delay: 0.0,
//                options: .curveEaseIn,
//                animations: {
//                    self.selectedSetCards[index].layer.opacity = 0.99
//                },
//                completion:  {_ in
//                    for item in self.selectedSetCards {
//                        push.removeItem(item)
//                        self.collision.removeItem(item)
//                        self.itemBehavior.removeItem(item)
//                    }
//                    UIView.animate(
//                        withDuration: 0.4,
//                        delay: 0.0,
//                        animations: {
//                            self.selectedSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//                            //                                       self.selectedSetCards[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
//
//                            self.selectedSetCards[index].bounds = self.discardPile.bounds
//                            self.animator.addBehavior(snap)
//                            self.selectedSetCards[index].layer.borderWidth = 0.0
//                        },
//                        completion: {_ in
//                            UIView.animate(
//                                withDuration: 0.6,
//                                delay: 0.0,
//                                animations: {
//                                    self.selectedSetCards[index].layer.opacity = 1.0
//                                },
//                                completion: {_ in
//                                    UIView.transition(
//                                        with: self.discardPile,
//                                        duration: 0.4,
//                                        options: [.transitionFlipFromLeft],
//                                        animations: {
//                                            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { _ in
//                                                self.selectedSetCards[index].layer.isHidden = true
//                                            })
//                                    })
//                                    UIView.transition(
//                                        with: self.selectedSetCards[index],
//                                        duration: 0.4,
//                                        options: [.transitionFlipFromLeft],
//                                        animations: {
//                                            self.selectedSetCards[index].backgroundColor = UIColor.orange
//                                        },
//                                        completion: {_ in
////                                                self.setCount += 1
//                                            self.removeFromSuperViewIfSet()
//                                            self.cardsBoardView.setNeedsDisplay()
//                                            self.game.updatePlayingCards()
//                                            self.selectedSetCards = []
//                                            self.updateView()
//                                        })
//                                })
//                        })
//                })
//            self.selectedSetCards[index].layer.zPosition = 1
//            delay += 0.7
//        }
//        self.setCount += 1
//    }
//    firstTimeDeal = false
//
//    if let _ = scoreLabel {
//        scoreCount = game.scoreCount
//    }
//}
//}



















//private func updateView() {
//
//    checkIfDealMoreCardsNeedsToBeDisabled()
//    cardsBoardView.numberOfCardsToBeDisplayed = game.cardsOnTable
//    cardsBoardView.grid.frame = cardsBoardView.bounds
//
//    var delay = 0.3
//    for index in 0..<game.cardsOnTable {
//
//        let card = game.playingCards[index]
//        let view = cardsViews[index]
//
//        if let rect = cardsBoardView.grid[index]
//        {
//            view.layer.masksToBounds = true
//            view.layer.cornerRadius = cardsBoardView.cornerRadious
//
//            if firstTimeDeal {
//                view.frame = rect
//                view.frame.origin = CGPoint(x: cardsBoardView.frame.midX - (rect.width / 1.7) , y: cardsBoardView.frame.midY - (rect.height / 1.7))
//
//                UIViewPropertyAnimator.runningPropertyAnimator(
//                    withDuration: 0.7,
//                    delay: delay,
//                    animations: {
//                        view.frame = rect.insetBy(dx: 4.0, dy: 4.0)
//                        delay += 0.1
//                    },
//                    completion: { initial in
//                        UIView.transition(
//                            with: view,
//                            duration: 1.0,
//                            options: [.transitionFlipFromLeft],
//                            animations: {
//                                view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                                self.setFeatures(for: view, with: card)
//                            },
//                            completion: { _ in })
//                    })
//            } else if selectedSetCards.count != 3 {
//
//
//                UIViewPropertyAnimator.runningPropertyAnimator(
//                    withDuration: 0.5,
//                    delay: 0.0,
//                    animations: {
//                        if self.shouldDealThreeCards == false {
//                            view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
//                            self.setFeatures(for: view, with: card)
//                        }
//                        else {
//                            if !(((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index)
//                            {
//                                view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
//                            }
//                        }
//                    }
//                )
//                if ((self.game.cardsOnTable - 3)...self.game.cardsOnTable) ~= index && self.shouldDealThreeCards == true
//                {
//
//                    view.frame.origin = self.dealThreeMoreCardButton.frame.origin.offsetBy(dx: -6.0, dy: -60.0)
//
//                    UIViewPropertyAnimator.runningPropertyAnimator(
//                        withDuration: 0.5,
//                        delay: delay,
//                        animations: {
//                            view.frame = rect.insetBy(dx: 3.0, dy: 3.0)
//                        },
//                        completion: { initial in
//                            UIView.transition(
//                                with: view,
//                                duration: 0.5,
//                                options: .transitionFlipFromLeft,
//                                animations: {
//                                    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//                                    self.setFeatures(for: view, with: card)
//                                    self.shouldDealThreeCards = false
//                                })
//                        })
//                    delay += 0.5
//                }
//            }
//        }
//        if let cardIsSet = card.cardIsSet, cardIsSet {
//            selectedSetCards.append(cardsViews[index])
//        }
//    }
//
//    if selectedSetCards.count == 3 {
//        var delay = 0.5
//
//        for index in 0..<self.selectedSetCards.count {
//
//            //--------------
////               let snap = UISnapBehavior(item: self.selectedSetCards[1], snapTo: self.discardPile.frame.origin.offsetBy(dx: 80.0, dy: 40.0))
////                snap.damping = 3
////                self.animator.addBehavior(snap)
//
//            let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
//            let discardOrigin = self.discardPile.center
//            let snap = UISnapBehavior(item: self.selectedSetCards[index], snapTo: discardOrigin)
//                               snap.damping = 0.4
//
//            UIView.animate(withDuration: 1.4, delay: 0.0, options: .curveEaseIn, animations: {
////                                   let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
////                                                                 rotation.toValue = NSNumber(value: Double.pi * 2)
////                                   rotation.duration = 0.1
////                                                                 rotation.isCumulative = true
////                                                                 rotation.repeatCount = Float.greatestFiniteMagnitude
////
////                                                         self.selectedSetCards[index].layer.add(rotation, forKey: "rotationAnimation")
//
////                                   let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
//
//                self.selectedSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
//                               push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
//               push.magnitude = 7
//                               self.itemBehavior.addItem(self.selectedSetCards[index])
//                               self.collision.addItem(self.selectedSetCards[index])
//                               self.animator.addBehavior(push)
//                               self.selectedSetCards[index].layer.opacity = 0.99
//                           }, completion:  {_ in
//                               for item in self.selectedSetCards {
//                                   push.removeItem(item)
//                                   self.collision.removeItem(item)
//                                   self.itemBehavior.removeItem(item)
//                               }
//
//                               UIView.animate(withDuration: 0.4, delay: 0.0, animations: {
//                                   self.selectedSetCards[index].transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
////                                       self.selectedSetCards[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
//
//                                   self.selectedSetCards[index].bounds = self.discardPile.bounds
//                                                       self.animator.addBehavior(snap)
////                                       let snap = UISnapBehavior(item: self.selectedSetCards[index], snapTo: self.discardPile.frame.origin.offsetBy(dx: 80.0, dy: 40.0))
////                                       snap.damping = 3
////                                       self.animator.addBehavior(snap)
//                               }, completion: {_ in
//
//                                   UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
//                                       self.selectedSetCards[index].layer.opacity = 0.9
//                                   }, completion: {_ in
//
//                                       UIView.transition(with: self.selectedSetCards[index], duration: 0.4, options: [.transitionFlipFromLeft], animations: {
//                                           self.selectedSetCards[index].backgroundColor = UIColor.orange
//                                           self.selectedSetCards[index].layer.opacity = 0.1
//                                       })
//                                       UIView.transition(with: self.discardPile, duration: 0.4, options: [.transitionFlipFromLeft], animations: {
//                                           self.selectedSetCards[index].layer.opacity = 0.0
//
//                                       }, completion: {_ in
//                                           self.setCount += 1
//                                           self.removeFromSuperViewIfSet()
//                                           self.cardsBoardView.setNeedsDisplay()
//                                           self.game.updatePlayingCards()
//                                           self.selectedSetCards = []
//                                           self.updateView()
//                                       })
//                                   })
//
//                               })
//
//                           })
//
//           //// //--------------
//
////
//            // //--------------
////                            // Snap needs to initiate at the end of items(cards) flew away, before that items should be pushed
////
////                            let snap = UISnapBehavior(item: selectedViews[index], snapTo: selectedViews[index].frame.origin.offsetBy(dx: 80.0, dy: 40.0))
////                            snap.damping = 3
////                            animator.addBehavior(snap)
////                            animator.addBehavior(collision)
//
////                UIView.animate(withDuration: 1.0, delay: 0.0, animations: {
////                    let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
////                    push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
////                    push.magnitude = 18.1
////                    self.itemBehavior.addItem(self.selectedSetCards[index])
////                    self.collision.addItem(self.selectedSetCards[index])
////                    self.animator.addBehavior(push)
////                }, completion: { _ in
////                    print("asd")
////                })
//
////                    UIViewPropertyAnimator.runningPropertyAnimator(
////                        withDuration: 0.0,
////                        delay: delay,
////                        animations:
////                            {
////                                UIView.transition(with: self.selectedSetCards[index], duration: 1.0, animations: {
//////                                    let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
//////                                    push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
//////                                    push.magnitude = 18.1
//////                                    self.itemBehavior.addItem(self.selectedSetCards[index])
//////                                    self.collision.addItem(self.selectedSetCards[index])
//////                                    self.animator.addBehavior(push)
////                                }, completion: { _ in
//////                                    self.setCount += 1
//////                                    self.removeFromSuperViewIfSet()
//////                                    self.cardsBoardView.setNeedsDisplay()
//////                                    self.game.updatePlayingCards()
//////                                    self.selectedSetCards = []
//////                                    self.updateView()
////                                })
//
////                                let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
////                                push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
////                                push.magnitude = 18.1
////                                self.itemBehavior.addItem(self.selectedSetCards[index])
////                                self.collision.addItem(self.selectedSetCards[index])
////                                self.animator.addBehavior(push)
//
////                                self.selectedSetCards[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
//                            self.selectedSetCards[index].layer.zPosition = 1
////                                self.view.bringSubviewToFront(self.selectedSetCards[index])
////                                        self.setFeatures(for: view, with: card)
////                            },
////                        completion: { _ in
////                            if index == 2 {
////                                        self.selectedSetCards[0].removeFromSuperview()
////                                        self.selectedSetCards[1].removeFromSuperview()
//
////                                        UIView.transition(
////                                            with: self.selectedSetCards[index],
////                                            duration: 0.9,
////                                            options: .transitionFlipFromLeft,
////                                            animations: {
////                                                self.selectedSetCards[index].layer.opacity = 0.0
////                                                (self.selectedSetCards[index] as? CardsView)?.shapeStyle = 0
////                                            },
////                                            completion:  { _ in })
//
//
////                itemPushBehavior.addItem(self.selectedSetCards[index])
////                                let push = UIPushBehavior(items: [self.selectedSetCards[index]], mode: .instantaneous)
////                                push.angle = CGFloat.pi * CGFloat.random(in: 1...5)
//////                    let randomNumber = [2,6,10]
////                push.magnitude = 7
////                                self.itemBehavior.addItem(self.selectedSetCards[index])
////                                self.collision.addItem(self.selectedSetCards[index])
////                                self.animator.addBehavior(push)
////                UIView.animate(withDuration: 0.8, delay: 0.0, animations: {
//////                                    push.active = false
//////                                    push.action = { [unowned push] in
//////                                                    push.dynamicAnimator?.removeBehavior(push)
//////                                                }
//////                                    self.animator.removeBehavior(push)
//////                                    self.selectedSetCards[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
//////                                    self.selectedSetCards[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
////                                    self.selectedSetCards[index].layer.opacity = 0.5
//////                    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
//////                    rotationAnimation.fromValue = CGFloat.random(in: 13...17)
//////                    rotationAnimation.toValue = CGFloat.pi * 2
//////                    print(Double.pi)
//////                    rotationAnimation.duration = 2.0
//////                    self.selectedSetCards[index].layer.add(rotationAnimation, forKey: "rotationAnimation")
////
//////                    UIView.transition(with: self.selectedSetCards[index], duration: 1.0, animations: {
////////                        self.selectedSetCards[index].transform = CGAffineTransform.rotated(<#T##self: CGAffineTransform##CGAffineTransform#>)
//////
//////                        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
//////                                rotation.toValue = NSNumber(value: Double.pi * 2)
//////                                rotation.duration = 1
//////                                rotation.isCumulative = true
//////                                rotation.repeatCount = Float.greatestFiniteMagnitude
//////
//////                        self.selectedSetCards[index].layer.add(rotation, forKey: "rotationAnimation")
//////                    })
//////                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration:1.4, delay: 0.0, animations: {
////////                        self.selectedSetCards[index].transform = CGAffineTransform.init(rotationAngle: 180)
//////                    })
////
////                                }, completion: { _ in
////
////                                    UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
////                                        self.selectedSetCards[index].layer.opacity = 0.9
////                                    }, completion: { _ in
//////                                        self.animator.removeAllBehaviors()
////                                        for item in self.selectedSetCards {
////                                            push.removeItem(item)
////                                            self.collision.removeItem(item)
////                                            self.itemBehavior.removeItem(item)
////
////                                        }
////
////                                        UIView.transition(with: self.selectedSetCards[index], duration: 1.4, animations: {
////                                            self.selectedSetCards[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
////                                            self.itemBehavior.allowsRotation = false
////    //                                        let snap = UISnapBehavior(item: self.selectedSetCards[index], snapTo: self.selectedSetCards[index].frame.origin.offsetBy(dx: 80.0, dy: 40.0))
////    //                                        snap.damping = 0.3
////    //                                        self.animator.addBehavior(snap)
////
////                                        }, completion: { _ in
////
////                                            UIView.transition(with: self.discardPile, duration: 1.4, options: [.transitionFlipFromLeft], animations: {
////                                                self.selectedSetCards[index].layer.borderWidth = 10.0
////                                                self.selectedSetCards[index].backgroundColor = #colorLiteral(red: 0.938970983, green: 0.3479673266, blue: 0.1912576258, alpha: 1)
//////                                                self.discardPile
////                                                self.selectedSetCards[index].layer.backgroundColor = #colorLiteral(red: 0.938970983, green: 0.3479673266, blue: 0.1912576258, alpha: 1)
////        //                                        self.discardPile.
////                                                self.selectedSetCards[index].layer.borderWidth = 0.0
////                                            })
////                                            UIView.animate(withDuration: 1.0, delay: 1.0, options: [.transitionFlipFromLeft], animations: {
////                                                self.selectedSetCards[index].layer.opacity = 0.3
////                                            }, completion: {_ in
////                                                self.setCount += 1
////                                                self.removeFromSuperViewIfSet()
////                                                self.cardsBoardView.setNeedsDisplay()
////                                                self.game.updatePlayingCards()
////                                                self.selectedSetCards = []
////                                                self.updateView()
////                                            })
////
//////                                            UIView.transition(with: self.discardPile, duration: 1.0,  options: [.transitionFlipFromLeft],  animations: {
//////                                                print("asd")
//////                                            }, completion: { _ in
//////                                                self.setCount += 1
//////                                                self.removeFromSuperViewIfSet()
//////                                                self.cardsBoardView.setNeedsDisplay()
//////                                                self.game.updatePlayingCards()
//////                                                self.selectedSetCards = []
//////                                                self.updateView()
//////                                            })
////                                        })
////                                    })
////
//////                                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 4.0, delay: 1.0, animations: {
//////                                        self.selectedSetCards[index].layer.opacity = 1.0
//////                                    }, completion: { _ in
//////                                        self.animator.removeAllBehaviors()
//////                                    })
//////
////
////
////
////
////
////
////
//////                                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.4, delay: 0.0, animations: {
//////
//////                                    }, completion: { _ in
////////                                        self.setCount += 1
////////                                        self.removeFromSuperViewIfSet()
////////                                        self.cardsBoardView.setNeedsDisplay()
////////                                        self.game.updatePlayingCards()
////////                                        self.selectedSetCards = []
////////                                        self.updateView()
//////
//////                                    })
////
//////                                        self.setCount += 1
//////                                        self.removeFromSuperViewIfSet()
//////                                        self.cardsBoardView.setNeedsDisplay()
//////                                        self.game.updatePlayingCards()
//////                                        self.selectedSetCards = []
//////                                        self.updateView()
//////
////
//////                                    self.setCount += 1
//////                                    self.removeFromSuperViewIfSet()
//////                                    self.cardsBoardView.setNeedsDisplay()
//////                                    self.game.updatePlayingCards()
//////                                    self.selectedSetCards = []
//////                                    self.updateView()
////                                })
////
////                                        UIView.transition(
////                                            with: self.discardPile,
////                                            duration: 0.9,
////                                            options: [ .transitionFlipFromLeft],
////                                            animations: {
////
////                                            },
////                                            completion: { _ in
//////                                                push.removeItem(senderView)
////                                                self.setCount += 1
////                                                self.removeFromSuperViewIfSet()
////                                                self.cardsBoardView.setNeedsDisplay()
////                                                self.game.updatePlayingCards()
////                                                self.selectedSetCards = []
////                                                self.updateView()
////                                            })
////                            }
////                        })
//            // //--------------
//                delay += 0.7
//            }
//    }
//    firstTimeDeal = false
//
//    if let _ = scoreLabel {
//        scoreCount = game.scoreCount
//    }
//}
//}



//
//
//@objc func buttonAction(_ sender: UITapGestureRecognizer)
//{
//    let senderView = sender.view!
//
//    if let cardIndex = cardsViews.firstIndex(of: senderView as! CardsView)
//    {
//        switch sender.state {
//        case .ended:
//            buttonAcctionWas = true
//            game.chooseCard(at: cardIndex)
//            updateView()
//
//            if let _ = sender.view as? CardsView {
//
//                if !selectedViews.isEmpty {
//                    var delay = 0.5
//
//                    for index in 0..<self.selectedViews.count {
//                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: delay, animations: {
//
////                                self.selectedViews[index].layer.frame.origin = self.discardPile.frame.origin
////                                self.selectedViews[index].bounds = self.discardPile.bounds
//                            self.selectedViews[index].frame = self.discardPile.frame.offsetBy(dx: -16, dy: -107.0)
////                                self.selectedViews[index].layer.zPosition = 1
//                            self.view.bringSubviewToFront(self.selectedViews[index])
////                                self.selectedViews[index].alpha = 0.0
//
////                                self.view.sendSubviewToBack(self.discardPile)
//                        }, completion: { initial in
////                                self.selectedViews[index].frame = self.discardPile.frame.offsetBy(dx: 0.0, dy: -80.0)
//
////                                self.selectedViews[index].layer.borderColor = UIColor.magenta.cgColor
//                            if index == 2 {
//                                self.selectedViews[0].removeFromSuperview()
//                                self.selectedViews[1].removeFromSuperview()
////                                    self.selectedViews[index].layer.borderColor = UIColor.magenta.cgColor
////                                    self.selectedViews[index].layer.borderWidth = 0.0
//
//
//                                UIView.transition(with: self.selectedViews[index], duration: 2.0, options: .transitionFlipFromLeft, animations: {
//                                    self.selectedViews[index].layer.borderWidth = 0.0
//                                    self.selectedViews[index].layer.opacity = 0.0
//                                }, completion:  {_ in})
//
////                                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2.0, delay: 0.0, options: .transitionFlipFromLeft, animations: {
//////                                        self.selectedViews[index].layer.borderWidth = 0.0
//////                                        self.selectedViews[index].layer.opacity = 0.0
////                                    }, completion:  { _ in
////
////                                    })
//
//                                UIView.transition(with: self.discardPile, duration: 2.0, options: [ .transitionFlipFromLeft], animations: {
////                                        self.selectedViews[index].layer.borderWidth = 10.0
////                                        self.selectedViews[index].backgroundColor = #colorLiteral(red: 0.938970983, green: 0.3479673266, blue: 0.1912576258, alpha: 1)
////                                        self.discardPile
////                                        self.selectedViews[index].layer.backgroundColor = #colorLiteral(red: 0.938970983, green: 0.3479673266, blue: 0.1912576258, alpha: 1)
//////                                        self.discardPile.
////                                        self.selectedViews[index].layer.borderWidth = 0.0
//                                }, completion: { _ in
//                                    self.setCount += 1
//                                    self.removeFromSuperViewIfSet()
//                                    self.cardsBoardView.setNeedsDisplay()
//                                    self.game.updatePlayingCards()
//                                    self.selectedViews = []
//                                    self.updateView()
//                                })
//
////                                    self.setCount += 1
////                                    self.removeFromSuperViewIfSet()
////                                    self.cardsBoardView.setNeedsDisplay()
////                                    self.game.updatePlayingCards()
////                                    self.selectedViews = []
////                                    self.updateView()
//                            }
//                        })
//                        delay += 0.7
//                    }
//                }
//            }
//        default: break
//        }
//    }
//
////        updateView()
//    game.updatePlayingCards()
//
//    if game.playingCards.count <= 18, game.findAllSetsInDeck() == 0 {
//        updateView()
//    }
//    buttonAcctionWas = false
//
//}
