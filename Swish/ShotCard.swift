//
//  ShotCard.swift
//  Swish
//
//  Created by Andrew Ervin Gierke on 4/15/17.
//  Copyright © 2017 And. All rights reserved.
//

import UIKit

class ShotCard: CardView {
    
    //MARK: - Properties 
    
    var shots = [Shot]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // get the shot info
        
        ApiController.loadShots { (shots) in
            DispatchQueue.main.async {
                self.shots = shots
                updateViews()
            }
        }
        
        func updateViews() {
            guard let shot = shots.first,
                let shotPictureURL = URL(string: "\(shot.normalImageURL)") else { return }
            
            let session = URLSession(configuration: .default)
            
            let downloadPicTask = session.dataTask(with: shotPictureURL) { (data, response, error) in
                if let error = error {
                    print("Error downloading shot pic \(error)")
                } else {
                    if let response = response as? HTTPURLResponse {
                        print("Downloaded shot pic with code \(response.statusCode)")
                        if let imageData = data {
                            
                            let image = UIImage(data: imageData)
                            shot.largeImage = image
                            
                        } else {
                            print("Couldnt get image")
                        }
                    } else {
                        print("Couldnt get response code for some reason")
                    }
                }
            }
            
            downloadPicTask.resume()
            
            // set stuff
            
            let imageView = UIImageView(image: UIImage(named: "\(shot.largeImage ?? #imageLiteral(resourceName: "default_image"))"))
            imageView.contentMode = .scaleAspectFill
            imageView.backgroundColor = UIColor(red: 67/255, green: 79/255, blue: 182/255, alpha: 1.0)
            imageView.layer.cornerRadius = 5
            imageView.layer.masksToBounds = true
            
            imageView.frame = CGRect(x: 12, y: 12, width: self.frame.width - 24, height: self.frame.height - 103)
            self.addSubview(imageView)
            
            // text labels
            
            // title
            let title = shots.first?.title ?? "title"
            let username = shots.first?.user?.userName ?? "username"
            
            let titleLabel = UILabel()
            titleLabel.text = "\(title)"
            titleLabel.font = UIFont(name: "AvenirNext-Bold", size: 24)
            titleLabel.textColor = Colors.highlightBlue
            titleLabel.textAlignment = .left
            titleLabel.frame = CGRect(x: 12, y: imageView.frame.maxY + 15, width: 200, height: 24)
            self.addSubview(titleLabel)
            
            let usernameLabel = UILabel()
            usernameLabel.text = "\(username)"
            usernameLabel.font = UIFont(name: "AvenirNext", size: 14)
            usernameLabel.textColor = UIColor.lightGray
            usernameLabel.textAlignment = .left
            usernameLabel.frame = CGRect(x: 12, y: titleLabel.frame.maxY + 10, width: 120, height: 24)
            self.addSubview(usernameLabel)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
