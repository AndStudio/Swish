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
    
    var shots = [Shot]()
    
    //MARK: - Outlets 
    
    @IBOutlet weak var shotImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    //MARK: - View lifecycle 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiController.loadShots { (shots) in
            DispatchQueue.main.async {
                self.shots = shots
                self.updateViews()
            }
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
       
        shotImageView.image = shot.largeImage
        titleLabel.text = shot.title
    }
}
