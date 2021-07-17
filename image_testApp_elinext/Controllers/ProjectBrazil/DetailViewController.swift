//
//  DetailViewController.swift
//  image_testApp_elinext
//
//  Created by pavel on 17.07.21.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    
    var selectedImage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: selectedImage)
        detailImageView.sd_setImage(with: url, completed: nil)
    }
    


}
