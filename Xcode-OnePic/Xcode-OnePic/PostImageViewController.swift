//
//  PostImageViewController.swift
//  Xcode-OnePic
//
//  Created by Kai Ding on 11/19/15.
//  Copyright © 2015 Kai Ding. All rights reserved.
//

import UIKit

class PostImageViewController: UIViewController {

    var capturedImage: UIImage!
    
    @IBOutlet var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = capturedImage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
