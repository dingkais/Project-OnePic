//
//  LibraryViewController.swift
//  Xcode-OnePic
//
//  Created by Kai Ding on 12/3/15.
//  Copyright © 2015 Kai Ding. All rights reserved.
//

import UIKit
import Parse
import SDWebImage

class LibraryViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var allObjects: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
        
        
        allObjects = [PFObject]()
        
        queryDataFromParse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set the number of items in your collection view.
        if let objects = allObjects {
            return objects.count
        }
        return 0
    }
    
    func queryDataFromParse() {
        var query = PFQuery(className:"Message")
        query.whereKey("Key", equalTo:"key2015")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            let Message = PFObject(className:"Message")
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) objects.")
                // Do something with the found objects
                if let objects = objects {
                    
                    // Need to remove all the data when updating
                    self.allObjects?.removeAll()
                    
                    for object in objects {
                        
                        print(object.objectId)
                        print(object["text"])
                        if object["imageFile"] != nil {
                            if let imageFile: PFFile = object["imageFile"] as! PFFile {
                                print("image: \(imageFile.url)")
                                
                                self.allObjects?.append(object)
                            }
                        }
                        if object["videoFile"] != nil {
                            if let videoFile: PFFile = object["videoFile"] as! PFFile {
                                print("video: \(videoFile.url)")
                            }
                        }
                        
                       
                    }
                    
                    self.collectionView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
         // Access
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath)as! PhotoCell
        let object = allObjects![indexPath.row]
        if object["imageFile"] != nil {
            if let imageFile: PFFile = object["imageFile"] as! PFFile {
                print("image: \(imageFile.url)")
                if let url = NSURL(string: imageFile.url!) {
                    cell.photoImageView.sd_setImageWithURL(url)
                }
            }
        }
        
        
        
        
        // Do any custom modifications you your cell, referencing the outlets you defined in the Custom cell file.
        
        
        cell.backgroundColor = UIColor.blackColor()
        
        return cell
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
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
