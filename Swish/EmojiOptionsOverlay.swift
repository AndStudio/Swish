//
//  EmojiOptionsOverlay.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/15/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class EmojiOptionsOverlay: UIView {
    
    let emojiPadding: CGFloat = 20
    let emojiSize = CGSize(width: 64, height: 64)
    let emojiInitialOffset: CGFloat = 90
    let emojiInitialAlpha: CGFloat = 0.45
    
    let like1Emoji = UIImageView(image: UIImage(named: "like1"))
    
    let dislike1Emoji = UIImageView(image: UIImage(named: "dislike1"))
    
    let heartEmoji = UIImageView(image: UIImage(named: "heartSwish"))
    let darkHeartEmoji = UIImageView(image: UIImage(named: "likedCards"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = false
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        like1Emoji.frame = CGRect(x: frame.width - emojiPadding - emojiSize.width, y: (frame.height/2) - (emojiSize.height * 1.5) - emojiPadding, width: emojiSize.width, height: emojiSize.height)
        self.addSubview(like1Emoji)
        
        dislike1Emoji.frame = CGRect(x: emojiPadding, y: (frame.height/2) - (emojiSize.height * 1.5) - emojiPadding, width: emojiSize.width, height: emojiSize.height)
        self.addSubview(dislike1Emoji)
        
        heartEmoji.frame = CGRect(x: frame.width - emojiPadding - 50, y: 30, width: 35, height: 35)
        heartEmoji.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        self.addSubview(heartEmoji)
        
        darkHeartEmoji.frame = heartEmoji.frame
        darkHeartEmoji.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        // initial state
        like1Emoji.alpha = emojiInitialAlpha
        like1Emoji.frame.origin.x += emojiInitialOffset
        
        dislike1Emoji.alpha = emojiInitialAlpha
        dislike1Emoji.frame.origin.x -= emojiInitialOffset
        
        heartEmoji.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Smiley Emojis
    
    var isLikeEmojisVisible = false
    var isDislikeEmojisVisible = false
    
    public func showEmoji(for option: CardOption) {
        if option == .like1 || option == .like2 || option == .like3 {
            
            if isDislikeEmojisVisible {
                hideDislikeEmojis()
            }
            
            if !isLikeEmojisVisible {
                showLikeEmojis()
            }
            
            like1Emoji.alpha = emojiInitialAlpha
            switch option {
            case .like1:
                like1Emoji.alpha = 1
            default:
                break
            }
            
        } else {
            if isLikeEmojisVisible {
                hideLikeEmojis()
            }
            
            if !isDislikeEmojisVisible {
                showDislikeEmojis()
            }
            
            dislike1Emoji.alpha = emojiInitialAlpha
            switch option {
            case .dislike1:
                dislike1Emoji.alpha = 1
            default:
                break
            }
        }
    }
    
    public func hideFaceEmojis() {
        if isLikeEmojisVisible {
            hideLikeEmojis()
        }
        if isDislikeEmojisVisible {
            hideDislikeEmojis()
        }
    }
    
    var isHidingLikeEmojis = false
    private func hideLikeEmojis() {
        if isHidingLikeEmojis { return }
        isHidingLikeEmojis = true
        UIView.animate(withDuration: 0.2, delay: 0.0,  options: [], animations: {
            self.like1Emoji.frame.origin.x += self.emojiInitialOffset
        }) { (_) in
            self.isHidingLikeEmojis = false
        }
        isLikeEmojisVisible = false
    }
    
    var isShowingLikeEmojis = false
    private func showLikeEmojis() {
        if isShowingLikeEmojis { return }
        isShowingLikeEmojis = true
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.like1Emoji.frame.origin.x -= self.emojiInitialOffset
        }) { (_) in
            self.isShowingLikeEmojis = false
        }
        isLikeEmojisVisible = true
    }
    
    var isHidingDislikeEmojis = false
    private func hideDislikeEmojis() {
        if isHidingDislikeEmojis { return }
        isHidingDislikeEmojis = true
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [], animations: {
            self.dislike1Emoji.frame.origin.x -= self.emojiInitialOffset
        }) { (_) in
            self.isHidingDislikeEmojis = false
        }
        isDislikeEmojisVisible = false
    }
    
    var isShowingDislikeEmojis = false
    private func showDislikeEmojis() {
        if isShowingDislikeEmojis { return }
        isShowingDislikeEmojis = true
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.dislike1Emoji.frame.origin.x += self.emojiInitialOffset
        }) { (_) in
            self.isShowingDislikeEmojis = false
        }
        isDislikeEmojisVisible = true
    }
    
    // MARK: Heart Emoji
    
    public func updateHeartEmoji(isFilled: Bool, isFocused: Bool) {
        if isFilled {
            heartEmoji.isHidden = false
            darkHeartEmoji.isHidden = true
            
            if isFocused {
                focusHeartEmoji()
            } else {
                unfocusHeartEmoji()
            }
        } else {
            unfocusHeartEmoji()
            heartEmoji.isHidden = true
            darkHeartEmoji.isHidden = false
            
        }
    }
    
    var heartIsFocused = false
    var isAnimatingHeart = false
    
    private func focusHeartEmoji() {
        if heartIsFocused || isAnimatingHeart { return }
        heartIsFocused = true
        isAnimatingHeart = true
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: [], animations: {
            self.heartEmoji.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
            self.darkHeartEmoji.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }) { (_) in
            self.isAnimatingHeart = false
        }
    }
    
    private func unfocusHeartEmoji() {
        if !heartIsFocused || isAnimatingHeart { return }
        heartIsFocused = false
        isAnimatingHeart = true
        UIView.animate(withDuration: 0.25, delay: 0.0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: [], animations: {
            self.heartEmoji.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.darkHeartEmoji.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }) { (_) in
            self.isAnimatingHeart = false
        }
    }
}
