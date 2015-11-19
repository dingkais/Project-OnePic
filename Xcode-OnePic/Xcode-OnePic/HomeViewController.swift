//
//  HomeViewController.swift
//  Xcode-OnePic
//
//  Created by Kai Ding on 11/19/15.
//  Copyright © 2015 Kai Ding. All rights reserved.
//

import UIKit
import AFNetworking
import PBJVision

class HomeViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, PBJVisionDelegate {
   
    @IBOutlet var cameraImageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    let vision = PBJVision.sharedInstance()
    
    var capturedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = cameraImageView.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        cameraImageView.layer.addSublayer(previewLayer)
        
        
        vision.cameraDevice = PBJCameraDevice.Back;
        vision.cameraMode = PBJCameraMode.Photo;
        vision.cameraOrientation = PBJCameraOrientation.Portrait;
        vision.focusMode = PBJFocusMode.ContinuousAutoFocus;
        vision.outputFormat = PBJOutputFormat.Square;
        vision.videoRenderingEnabled = true
        vision.additionalCompressionProperties = [AVVideoProfileLevelKey : AVVideoProfileLevelH264Baseline30];
        vision.startPreview()
        vision.captureSessionActive
        
        vision.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        vision.capturePhoto()
    }
    
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        
        capturedImage = photoDict![PBJVisionPhotoImageKey] as! UIImage
        //        UIImageWriteToSavedPhotosAlbum(capturedImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
        self.performSegueWithIdentifier("captureSegue", sender: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let postImageViewController = segue.destinationViewController as! PostImageViewController
        
        postImageViewController.capturedImage = capturedImage
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
