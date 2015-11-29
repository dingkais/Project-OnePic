//
//  PostImageViewController.swift
//  Xcode-OnePic
//
//  Created by Kai Ding on 11/19/15.
//  Copyright © 2015 Kai Ding. All rights reserved.
//

import UIKit
import Player

class PostImageViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, PlayerDelegate {
    
    let offset: CGFloat = -50

    var capturedImage2: UIImage?
    var capturedVideoPath2: String?
    var player: Player?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var underlineGroup: UIView!
    @IBOutlet var characterCount: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize(width: 320, height: 760)
        
        scrollView.delegate = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        textView.delegate = self
        textView.alpha = 0.5
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        textView.becomeFirstResponder()
        
        if let image = capturedImage2{
            imageView.image = image
        } else {
            addVideoPlayer()
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // If the scrollView has been scrolled down by 50px or more...
        if scrollView.contentOffset.y <= -50 {
            // Hide the keyboard
            view.endEditing(true)
        }
    }
    
    func keyboardWillShow(notification: NSNotification!) {
        // self.buttonParentView.frame.origin = CGPoint(x: self.buttonParentView.frame.origin.x, y: self.initialY + self.offset)

        // Calculate the maximum scrollview content Offset y
        let maxContentOffsetY = scrollView.contentSize.height - scrollView.frame.size.height
        // Scroll the scrollview up to the maximum contentOffset
        scrollView.contentOffset.y = maxContentOffsetY
        // Enable scrolling while keyboard is shown
        scrollView.scrollEnabled = true
    }
    
    func keyboardWillHide(notification: NSNotification!) {

        // Return the ScrollView to it's original position
        scrollView.contentOffset.y = 0
        // Disable scrolling when keyboard is hidden
        scrollView.scrollEnabled = false
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == "Add a caption..." {
            textView.text = ""
            textView.alpha = 1.0
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.characters.count == 0 {
            textView.text = "Add a caption..."
            textView.alpha = 0.5
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false;
        }
        if textView.text.characters.count > 140 {
            return false
        }
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: fixedWidth, height: newSize.height)
        textView.frame = newFrame;
        var newUnderlineFrame = underlineGroup.frame;
        newUnderlineFrame.origin.y = CGRectGetMaxY(newFrame) + 1;
        underlineGroup.frame = newUnderlineFrame;
        characterCount.text = "\(140 - textView.text.characters.count) characters left"
        return true
    }

    func addVideoPlayer (){
        player = Player()
        
        if let localPlayer = player {
            localPlayer.delegate = self
            localPlayer.view.frame = self.imageView.frame
            
            addChildViewController(localPlayer)
            scrollView.addSubview(localPlayer.view)
            localPlayer.didMoveToParentViewController(self)
            
            if let path = capturedVideoPath2 {
                let videoUrl = NSURL(fileURLWithPath: path)
                player?.setUrl(videoUrl)
                player?.playFromBeginning()
            }
            
            
        }
        
    }
    
    //Player delegate functions
    func playerReady(player: Player) {
        
    }
    func playerPlaybackStateDidChange(player: Player) {
        
    }
    func playerBufferingStateDidChange(player: Player) {
        
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {
        
    }
    func playerPlaybackDidEnd(player: Player) {
        player.playFromBeginning()
    }

    
    
    @IBAction func buttonRetake(sender: UIButton) {
        navigationController!.popViewControllerAnimated(true)
        
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
