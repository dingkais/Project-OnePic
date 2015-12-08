//
//  ReceivedViewController.swift
//  Xcode-OnePic
//
//  Created by Peiyu Liu on 12/7/15.
//  Copyright © 2015 Kai Ding. All rights reserved.
//

import UIKit
import Parse

class ReceivedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var messageField: UITextField!
    
    var comments: [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 375, height: 900)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        comments = []
        
        reloadComments()
        
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "reloadComments", userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
        
        let comment = comments[indexPath.row]
        
        cell.nameLabel.text = comment["user"] as? String
        cell.commentLabel.text = comment["text"] as? String
        
        
        
        return cell
    }
    
    func reloadComments(){
        let query = PFQuery(className: "Comment")
        query.orderByDescending("createdAt")  
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
          
            self.comments = objects

            self.tableView.reloadData()
            //print(self.comments)
        }
    }
    
    @IBAction func didPressSendButton(sender: AnyObject) {
        
        let comment = PFObject(className: "Comment")
        
        comment["text"]=messageField.text
        comment["user"]="Kai"
        
        comment.saveInBackgroundWithBlock { (status: Bool, error: NSError?) -> Void in
            print("save succeed")
        }
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
