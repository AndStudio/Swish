//
//  SwipeViewController.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/15/17.
//  Copyright © 2017 And. All rights reserved.
//
import UIKit

class SwipeViewController: UIViewController {
    
    //MARK: - Properties
    
    static let shared = SwipeViewController()
    
    var shots: [Shot] = []
    
    var doNotShowShots: [String] = []
    
    var authenticatedUsersLikedShots: [Shot]? {
        didSet {
            
        }
    }
    
    var cards = [ShotCard]()
    
    let threshold: CGFloat = 100
    var page: Int = 1
    var isLoadingShots = false
    
    var emojiOptionsOverlay: EmojiOptionsOverlay!
    
    //MARK: - Outlets
    
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(callRateLimitAlertController), name: presentAPIAlertControllerNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(callBadCredentialsAlertController), name: presentBadCredentialsAlertControllerNotification, object: nil)
        
        fetchAuthenticatedUsersLikedShots()
        
        navigationController?.isNavigationBarHidden = true
        
        dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        
        setUpUI()
        
        // create the card UI
        
        emojiOptionsOverlay = EmojiOptionsOverlay(frame: self.view.frame)
        self.view.addSubview(emojiOptionsOverlay)
        
        // load shots into card view
        ApiController.fetchLikedShots(page: String(page)) { (shots) in
            
            self.doNotShowShots = shots.map({"\($0.shotID)"})
            
            ApiController.loadShots(page: self.page) { (shots) in
                
                for shot in shots {
                    if !self.doNotShowShots.contains("\(shot.shotID)") {
                        self.shots.append(shot)
                    }
                }
                
                guard shots.count > 0 else { return }
                
                DispatchQueue.main.async {
                    for i in 1...shots.count {
                        
                        let card = ShotCard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.view.frame.height * 0.6))
                        card.shot = shots[i - 1]
                        self.cards.append(card)
                    }
                    
                    self.setInitialCardImages(completion: {
                        // setting image in this func
                    })
                    
                    self.layoutCards()
                    
                }
            }
        }
        
    }
    
    // MARK: Observer Functions
    func callRateLimitAlertController() {
        DribbleApi.presentAPIInfoAlertController(view: self)
    }
    
    func callBadCredentialsAlertController() {
        DribbleApi.presentBadCredantialsAlertController(view: self)
    }
    
    func fetchAuthenticatedUsersLikedShots() {
        
        guard let currentUser = DribbleApi.currentUser else { return }
        
        var shotsIDsArray: [Shot] = []
        var page = 1
        let maxPage: Int = Int(ceil(Double(currentUser.likeCount) / Double(DribbleApi.collectionShotsToLoad)))
        
        while page <= maxPage {
            page += 1
            ApiController.fetchLikedShots(page: String(page), completion: { (shots) in
                shotsIDsArray.append(contentsOf:shots)
                print(page)
                
            })
        }
        self.authenticatedUsersLikedShots = shotsIDsArray
    }
    
    //MARK: - Pagination
    
    func incrementShotLoading() {
        // when the number of cards in the arrays hits a certain number new API call will be made to append the next set of shots to the shot array
        
        if !isLoadingShots {
            isLoadingShots = true
            ApiController.loadShots(page: self.page, completion: { (shots) in
                self.page += 1
                for shot in shots {
                    if !self.doNotShowShots.contains("\(shot.shotID)") {
                        
                        let card = ShotCard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 60, height: self.view.frame.height * 0.6))
                        card.shot = shot
                        self.shots.append(shot)
                        self.cards.append(card)
                        
                    }
                }
                self.isLoadingShots = false
            })
        }
    }
    
    // Set the Gif
    
    func setNewShot() {
        
        for i in 0...(cards.count-1) {
            if i == 3 {
                guard shots.count > i else { return }
                let shot = self.shots[i]
                
                DispatchQueue.main.async {
                    
                    if shot.hiDpiImageURL == nil {
                        ImageController.image(forURL: shot.normalImageURL, completion: { (image) in
                            shot.largeImage = image
                            
                            //call the shot's update properties ONLY if it also has an image
                            let card = self.cards[i]
                            card.shot = shot
                            
                        })
                    } else {
                        guard let hiDpiImageURL = shot.hiDpiImageURL else { return }
                        ImageController.image(forURL: hiDpiImageURL, completion: { (image) in
                            shot.largeImage = image
                            
                            //update card's shot properties ONLY if it has an image
                            let card = self.cards[i]
                            card.shot = shot
                            
                        })
                    }
                }
            }
        }
    }
    
    // Scale and alpha of successive cards visible to the user
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1, 1), (0.92, 0.8), (0.84, 0.6), (0.76, 0.4)]
    let cardInteritemSpacing: CGFloat = 15
    
    // Set up the frames, alphas, and transforms of the first 4 cards on the screen
    func layoutCards() {
        
        //check cards.count to reload next batch if needed.
        guard cards.count > 0 else { return }
        
        if shots.count <= 6 {
            incrementShotLoading()
        }
        
        
        let firstCard = cards[0]
        self.view.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center = self.view.center
        firstCard.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleCardPan)))
        firstCard.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCardDetail)))
        
        // the next 3 cards in the deck
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            
            let card = cards[i]
            
            card.layer.zPosition = CGFloat(cards.count - i)
            
            // here we're just getting some hand-picked vales from cardAttributes (an array of tuples)
            // which will tell us the attributes of each card in the 4 cards visible to the user
            
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            // position each card so there's a set space (cardInteritemSpacing) between each card, to give it a fanned out look
            card.center.x = self.view.center.x
            card.frame.origin.y = cards[0].frame.origin.y - (CGFloat(i) * cardInteritemSpacing)
            
            // workaround: scale causes heights to skew so compensate for it with some tweaking
            if i == 3 {
                card.frame.origin.y += 1.5
            }
            
            self.view.addSubview(card)
        }
        
        // make sure that the first card in the deck is at the front
        self.view.bringSubview(toFront: cards[0])
    }
    
    // UIKit dynamics variables that we need references to.
    var dynamicAnimator: UIDynamicAnimator!
    var cardAttachmentBehavior: UIAttachmentBehavior!
    
    // handle pan
    
    func openCardDetail(sender: UITapGestureRecognizer) {
        guard let vc = UIStoryboard(name: "ShotDetailView", bundle: nil).instantiateViewController(withIdentifier: "ShotDetail") as? ShotDetailViewController,
            let shot = cards[0].shot
            else { return }
        
        vc.shot = shot
        
        let navController = UINavigationController(rootViewController: vc)
        
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func handleCardPan(sender: UIPanGestureRecognizer) {
        // change this to your discretion - it represents how far the user must pan up or down to change the option
        let optionLength: CGFloat = 1
        // distance user must pan right or left to trigger an option
        let requiredOffsetFromCenter: CGFloat = 15
        
        let panLocationInView = sender.location(in: view)
        let panLocationInCard = sender.location(in: cards[0])
        switch sender.state {
        case .began:
            dynamicAnimator.removeAllBehaviors()
            let offset = UIOffsetMake(panLocationInCard.x - cards[0].bounds.midX, panLocationInCard.y - cards[0].bounds.midY);
            // card is attached to center
            cardAttachmentBehavior = UIAttachmentBehavior(item: cards[0], offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            dynamicAnimator.addBehavior(cardAttachmentBehavior)
        case .changed:
            cardAttachmentBehavior.anchorPoint = panLocationInView
            if cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter) {
                if cards[0].center.y < (self.view.center.y - optionLength) {
                    cards[0].showOptionLabel(option: .like1)
                    emojiOptionsOverlay.showEmoji(for: .like1)
                    
                    if cards[0].center.y < (self.view.center.y - optionLength - optionLength) {
                        emojiOptionsOverlay.updateHeartEmoji(isFilled: true, isFocused: true)
                    } else {
                        emojiOptionsOverlay.updateHeartEmoji(isFilled: true, isFocused: false)
                    }
                }
                
            } else if cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter) {
                
                emojiOptionsOverlay.updateHeartEmoji(isFilled: false, isFocused: false)
                
                if cards[0].center.y < (self.view.center.y - optionLength) {
                    cards[0].showOptionLabel(option: .dislike1)
                    emojiOptionsOverlay.showEmoji(for: .dislike1)
                }
                
            } else {
                cards[0].hideOptionLabel()
                emojiOptionsOverlay.hideFaceEmojis()
            }
            
        case .ended:
            
            dynamicAnimator.removeAllBehaviors()
            
            if emojiOptionsOverlay.heartIsFocused {
                
                // animate card to get "swallowed" by heart
                
                let currentAngle = CGFloat(atan2(Double(cards[0].transform.b), Double(cards[0].transform.a)))
                
                let heartCenter = emojiOptionsOverlay.heartEmoji.center
                var newTransform = CGAffineTransform.identity
                newTransform = newTransform.scaledBy(x: 0.05, y: 0.05)
                newTransform = newTransform.rotated(by: currentAngle)
                
                UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.cards[0].center = heartCenter
                    self.cards[0].transform = newTransform
                    self.cards[0].alpha = 0.5
                }, completion: { (_) in
                    self.emojiOptionsOverlay.updateHeartEmoji(isFilled: false, isFocused: false)
                    self.removeOldFrontCard()
                })
                
                emojiOptionsOverlay.hideFaceEmojis()
                showNextCard()
                
            } else {
                
                emojiOptionsOverlay.hideFaceEmojis()
                emojiOptionsOverlay.updateHeartEmoji(isFilled: false, isFocused: false)
                
                if !(cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter) || cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter)) {
                    // snap to center
                    let snapBehavior = UISnapBehavior(item: cards[0], snapTo: self.view.center)
                    dynamicAnimator.addBehavior(snapBehavior)
                } else {
                    
                    let velocity = sender.velocity(in: self.view)
                    let pushBehavior = UIPushBehavior(items: [cards[0]], mode: .instantaneous)
                    pushBehavior.pushDirection = CGVector(dx: velocity.x/10, dy: velocity.y/10)
                    pushBehavior.magnitude = 175
                    dynamicAnimator.addBehavior(pushBehavior)
                    // spin after throwing
                    var angular = CGFloat.pi / 2 // angular velocity of spin
                    
                    let currentAngle: Double = atan2(Double(cards[0].transform.b), Double(cards[0].transform.a))
                    
                    if currentAngle > 0 {
                        angular = angular * 1
                    } else {
                        angular = angular * -1
                    }
                    let itemBehavior = UIDynamicItemBehavior(items: [cards[0]])
                    itemBehavior.friction = 0.2
                    itemBehavior.allowsRotation = true
                    itemBehavior.addAngularVelocity(CGFloat(angular), for: cards[0])
                    dynamicAnimator.addBehavior(itemBehavior)
                    
                    hideFrontCard()
                    showNextCard()
                }
            }
        default:
            break
        }
    }
    
    //MARK: - remove old card and like shot
    
    func removeOldFrontCard() {
        
        guard let shotId = cards[0].shot?.shotID else { return }
        let shotIdString = "\(shotId)"
        
        if cards[0].center.x > self.view.center.x {
            //Like shot and remove the card
            ApiController.like(shotId: shotIdString) { (success) in
                
                self.doNotShowShots.append(shotIdString)
                DispatchQueue.main.async {
                    
                    self.cards[0].removeFromSuperview()
                    self.cards.remove(at: 0)
                    self.shots.remove(at: 0)
                    self.layoutCards()
                    self.setNewShot()
                    
                }
            }
            
        } else {
            
            self.doNotShowShots.append(shotIdString)
            
            self.cards[0].removeFromSuperview()
            self.cards.remove(at: 0)
            self.shots.remove(at: 0)
            layoutCards()
            setNewShot()
            
        }
    }
    
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        // 1. animate each card to move forward one by one
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            let newDownscale = cardAttributes[i - 1].downscale
            let newAlpha = cardAttributes[i - 1].alpha
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i - 1) * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                if i == 1 {
                    card.center = self.view.center
                } else {
                    card.center.x = self.view.center.x
                    card.frame.origin.y = self.cards[1].frame.origin.y - (CGFloat(i - 1) * self.cardInteritemSpacing)
                }
            }, completion: { (_) in
                if i == 1 {
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
            
        }
        
        // 2. add a new card (now the 4th card in the deck) to the very back
        if 4 > (cards.count - 1) {
            if cards.count != 1 {
                self.view.bringSubview(toFront: cards[1])
            }
            return
        }
        let newCard = cards[4]
        newCard.layer.zPosition = CGFloat(cards.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        // initial state of new card
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = cards[1].frame.origin.y - (4 * cardInteritemSpacing)
        self.view.addSubview(newCard)
        
        // animate to end state of new card
        UIView.animate(withDuration: animationDuration, delay: (3 * (animationDuration / 2)), usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.cards[1].frame.origin.y - (3 * self.cardInteritemSpacing) + 1.5
        }, completion: nil)
        
        // first card needs to be in the front for proper interactivity
        self.view.bringSubview(toFront: cards[1])
    }
    
    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoveTimer: Timer? = nil
            cardRemoveTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] (_) in
                guard self != nil else { return }
                if !(self!.view.bounds.contains(self!.cards[0].center)) {
                    cardRemoveTimer!.invalidate()
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: { [weak self] in
                        guard self != nil else { return }
                        self!.cards[0].alpha = 0.0
                        }, completion: { [weak self] (_) in
                            self!.removeOldFrontCard()
                    })
                }
            })
        } else {
            
            // fallback for earlier versions
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.cards[0].alpha = 0.0
            }, completion: { (_) in
                self.removeOldFrontCard()
            })
        }
    }
}


//MARK: - Not related to cards logic
extension SwipeViewController {
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    
    // Blank UI
    
    func setUpUI() {
        
        view.backgroundColor = Colors.backgroundGray
        
        // likes button
        
        let emojiPadding: CGFloat = 20
        
        let likesButton: UIButton = UIButton(frame: CGRect(x: view.frame.width - emojiPadding - 36, y: 22, width: 32, height: 32))
        likesButton.setImage(UIImage(named: "likedCards"), for: .normal)
        likesButton.addTarget(self, action: #selector(likesButtonTapped), for: .touchUpInside)
        likesButton.tag = 1
        self.view.addSubview(likesButton)
        self.view.bringSubview(toFront: likesButton)
        
        //Profile button
        
        let profileButton: UIButton = UIButton(frame: CGRect(x: view.frame.minX + emojiPadding + 4, y: 28, width: 22, height: 24))
        profileButton.setImage(UIImage(named: "swishUser"), for: .normal)
        profileButton.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        profileButton.tag = 2
        self.view.addSubview(profileButton)
        self.view.bringSubview(toFront: profileButton)
        
        // logo
        let swishLogoView = UIImageView(image: UIImage(named: "swishMark10"))
        swishLogoView.contentMode = .scaleAspectFill
        swishLogoView.frame = CGRect(x: (self.view.frame.width / 2) - 17, y: 32, width: 40, height: 22)
        swishLogoView.isUserInteractionEnabled = false
        self.view.addSubview(swishLogoView)
        
        // pass button
        let noButton: UIButton = UIButton(frame: CGRect(x: (self.view.frame.width / 2) - 100, y: self.view.frame.height - 120, width: 75, height: 75))
        noButton.setImage(UIImage(named: "noActive"), for: .normal)
        noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
        noButton.tag = 3
        noButton.layer.masksToBounds = false
        noButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        noButton.layer.shadowRadius = 8
        noButton.layer.shadowOpacity = 0.08
        self.view.addSubview(noButton)
        self.view.bringSubview(toFront: noButton)
        
        
        // like button
        let likeButton: UIButton = UIButton(frame: CGRect(x: (self.view.frame.width / 2) + 20, y: self.view.frame.height - 120, width: 75, height: 75))
        likeButton.setImage(UIImage(named: "yesActive"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        likeButton.tag = 4
        likeButton.layer.masksToBounds = false
        likeButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        likeButton.layer.shadowRadius = 8
        likeButton.layer.shadowOpacity = 0.08
        self.view.addSubview(likeButton)
        self.view.bringSubview(toFront: likeButton)
        
    }
    
    //MARK: - Like / No buttons
    
    func noButtonTapped() {
        cards[0].showOptionLabel(option: .dislike1)
        emojiOptionsOverlay.showEmoji(for: .dislike1)
        dynamicAnimator.removeAllBehaviors()
        
        // animate card to slide off screen to the left
        
        let currentAngle = CGFloat(atan2(Double(cards[0].transform.b), Double(cards[0].transform.a)))
        
        let offScreenTargetCenter = CGPoint(x: -200, y: 400)
        var newTransform = CGAffineTransform.identity
        newTransform = newTransform.scaledBy(x: 0.95, y: 0.95)
        newTransform = newTransform.rotated(by: 270)
        
        UIView.animate(withDuration: 0.8, delay: 0.35, usingSpringWithDamping: 0.0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            
            self.cards[0].center = offScreenTargetCenter
            self.cards[0].transform = newTransform
            self.cards[0].alpha = 1.0
            
        }) { (_) in
            self.emojiOptionsOverlay.hideFaceEmojis()
            self.emojiOptionsOverlay.updateHeartEmoji(isFilled: false, isFocused: false)
            self.hideFrontCard()
            self.showNextCard()
        }
    }
    
    func likeButtonTapped() {
        cards[0].showOptionLabel(option: .like1)
        emojiOptionsOverlay.showEmoji(for: .like1)
        dynamicAnimator.removeAllBehaviors()
        
        let currentAngle = CGFloat(atan2(Double(cards[0].transform.b), Double(cards[0].transform.a)))
        
        let offScreenTargetCenter = CGPoint(x: 600, y: 400)
        var newTransform = CGAffineTransform.identity
        newTransform = newTransform.scaledBy(x: 0.95, y: 0.95)
        newTransform = newTransform.rotated(by: -270)
        
        UIView.animate(withDuration: 0/8, delay: 0.35, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.cards[0].center = offScreenTargetCenter
            self.cards[0].transform = newTransform
            self.cards[0].alpha = 0.5
        }) { (_) in
            self.emojiOptionsOverlay.hideFaceEmojis()
            self.emojiOptionsOverlay.updateHeartEmoji(isFilled: false, isFocused: false)
            self.hideFrontCard()
            self.showNextCard()
        }
        
    }
    
    
    
    //MARK: - Handle Segues
    
    func likesButtonTapped(sender: UIButton!) {
        let buttonSendTag: UIButton = sender
        
        if buttonSendTag.tag == 1 {
            guard let vc = UIStoryboard(name: "Likes", bundle: nil).instantiateViewController(withIdentifier: "likes") as? LikesViewController else {
                print("probelem instantiting view controller for likes")
                return
            }
            
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func profileButtonTapped(sender: UIButton) {
        let buttonSendTag: UIButton = sender
        if buttonSendTag.tag == 2 {
            
            //            self.performSegue(withIdentifier: "profile", sender: self)
            
            guard let vc = UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "user") as? UserCollectionViewController else { return }
            
            let userData = DribbleApi.currentUser
            vc.user = userData
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    func setInitialCardImages(completion: () -> Void) {
        
        // the next 3 cards in the deck
        DispatchQueue.main.async {
            for i in 0...3 {
                
                let shot = self.shots[i]
                
                if shot.hiDpiImageURL == nil {
                    ImageController.image(forURL: shot.normalImageURL, completion: { (image) in
                        shot.largeImage = image
                        
                        //call the shot's update properties ONLY if it also has an image
                        let card = self.cards[i]
                        card.shot = shot
                        
                    })
                } else {
                    guard let hiDpiImageURL = shot.hiDpiImageURL else { return }
                    ImageController.image(forURL: hiDpiImageURL, completion: { (image) in
                        shot.largeImage = image
                        
                        //update card's shot properties ONLY if it has an image
                        let card = self.cards[i]
                        card.shot = shot
                        
                    })
                }
            }
        }
        completion()
    }
}
