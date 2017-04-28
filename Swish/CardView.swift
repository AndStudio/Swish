//
//  CardView.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/15/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

public enum CardOption: String {
    case like1 = "SWISH"
    case like2 = "I do like it"
    case like3 = "It's fine"
    
    case dislike1 = "NOPE"
    case dislike2 = "I do not"
    case dislike3 = "Not enough"
}

class CardView: UIView {
    
    var greenLabel: CardViewLabel!
    var redLabel: CardViewLabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // card style
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        // labels on top left and right
        
        let padding: CGFloat = 20
        
        greenLabel = CardViewLabel(origin: CGPoint(x: padding, y: padding), color: Colors.primaryPink, rotation: 270)
        greenLabel.isHidden = true
        self.addSubview(greenLabel)
        
        redLabel = CardViewLabel(origin: CGPoint(x: frame.width - CardViewLabel.size.width - padding, y: padding), color: Colors.highlightBlue, rotation: -270)
        redLabel.isHidden = true
        self.addSubview(redLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showOptionLabel(option: CardOption) {
        if option == .like1 || option == .like2 || option == .like3 {
            
            greenLabel.text = option.rawValue
            
            // fade out redLabel
            if !redLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.redLabel.alpha = 0
                }, completion: { (_) in
                    self.redLabel.isHidden = true
                })
            }
            
            // fade in greenLabel
            if greenLabel.isHidden {
                greenLabel.alpha = 0
                greenLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.greenLabel.alpha = 1
                })
            }
            
        } else {
            
            redLabel.text = option.rawValue
            
            
            // fade out greenLabel
            if !greenLabel.isHidden {
                UIView.animate(withDuration: 0.15, animations: {
                    self.greenLabel.alpha = 0
                }, completion: { (_) in
                    self.greenLabel.isHidden = true
                })
            }
            
            // fade in redLabel
            if redLabel.isHidden {
                redLabel.alpha = 0
                redLabel.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {
                    self.redLabel.alpha = 1
                })
            }
        }
    }
    
    var isHidingOptionLabel = false
    
    func hideOptionLabel() {
        // fade out greenLabel
        if !greenLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.greenLabel.alpha = 0
            }, completion: { (_) in
                self.greenLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
        // fade out redLabel
        if !redLabel.isHidden {
            if isHidingOptionLabel { return }
            isHidingOptionLabel = true
            UIView.animate(withDuration: 0.15, animations: {
                self.redLabel.alpha = 0
            }, completion: { (_) in
                self.redLabel.isHidden = true
                self.isHidingOptionLabel = false
            })
        }
    }
}


class CardViewLabel: UILabel {
    fileprivate static let size = CGSize(width: 150, height: 58)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = UIFont(name: "ArialRoundedMTBold", size: 36)
        self.textAlignment = .center
        
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        

    }
    
    convenience init(origin: CGPoint, color: UIColor, rotation: Int) {
        
        self.init(frame: CGRect(x: origin.x, y: origin.y, width: CardViewLabel.size.width, height: CardViewLabel.size.height))
        self.textColor = color
        self.backgroundColor = .clear
        self.layer.borderWidth = 4
        self.layer.borderColor = color.cgColor
        self.transform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
