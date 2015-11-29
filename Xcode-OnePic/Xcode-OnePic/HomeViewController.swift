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
    @IBOutlet var buttonFlash: UIButton!
    
    @IBOutlet var buttonPhoto: UIButton!
    @IBOutlet var buttonVideo: UIButton!
    @IBOutlet var buttonLibrary: UIButton!
    @IBOutlet var buttonTakePhoto: UIButton!
    @IBOutlet var buttonTakeVideo: UIButton!
    @IBOutlet var videoTimer: UILabel!
    
    
    var imagePicker: UIImagePickerController!
    let vision = PBJVision.sharedInstance()
    
    var capturedImage: UIImage!
    var capturedVideoPath: String!
    var isVideo = false
    
    var myTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let previewLayer = PBJVision.sharedInstance().previewLayer
        previewLayer.frame = cameraImageView.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        cameraImageView.layer.addSublayer(previewLayer)
        
        // Initial vision for taking photo
        setupVisionForPhoto(true)
        // Hide video timer
        videoTimer.hidden = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        vision.startPreview()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupVisionForPhoto(isPhoto: Bool) {
//        vision.cameraDevice = PBJCameraDevice.Back
        if isPhoto {
            vision.cameraMode = PBJCameraMode.Photo
        }else{
            vision.cameraMode = PBJCameraMode.Video
        }
        vision.cameraOrientation = PBJCameraOrientation.Portrait;
        vision.focusMode = PBJFocusMode.ContinuousAutoFocus;
        vision.outputFormat = PBJOutputFormat.Square;
        vision.videoRenderingEnabled = true
        vision.additionalCompressionProperties = [AVVideoProfileLevelKey : AVVideoProfileLevelH264Baseline30];
        vision.flashMode = PBJFlashMode.Off
        vision.captureSessionActive
        
        vision.delegate = self
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        vision.capturePhoto()
    }
    
    @IBAction func takeVideo(sender: UIButton) {
        if vision.recording == false{
            vision.startVideoCapture()
            myTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateVideoTimer", userInfo: nil, repeats: true)
        } else {
            vision.endVideoCapture()
            myTimer?.invalidate()
            myTimer = nil
           
        }
        
    }
    
    @IBAction func switchCamera(sender: AnyObject) {
        if vision.cameraDevice == PBJCameraDevice.Front {
            vision.cameraDevice = PBJCameraDevice.Back
        } else {
            vision.cameraDevice = PBJCameraDevice.Front
        }
    }
    
    @IBAction func flash(sender: UIButton) {
        if vision.flashMode == PBJFlashMode.Off {
            vision.flashMode = PBJFlashMode.Auto
            buttonFlash.setImage(UIImage(named: "icn-flash-auto"), forState: .Normal)
        } else if vision.flashMode == PBJFlashMode.Auto {
            vision.flashMode = PBJFlashMode.On
            buttonFlash.setImage(UIImage(named: "icn-flash-on"), forState: .Normal)
        } else {
            vision.flashMode = PBJFlashMode.Off
            buttonFlash.setImage(UIImage(named: "icn-flash-off"), forState: .Normal)
        }
    }
    
    func vision(vision: PBJVision, capturedPhoto photoDict: [NSObject : AnyObject]?, error: NSError?) {
        
        capturedImage = photoDict![PBJVisionPhotoImageKey] as! UIImage
        isVideo = false
        //        UIImageWriteToSavedPhotosAlbum(capturedImage, self, "image:didFinishSavingWithError:contextInfo:", nil)
        self.performSegueWithIdentifier("captureSegue", sender: nil)
    }
    
    func vision(vision: PBJVision, capturedVideo videoDict: [NSObject : AnyObject]?, error: NSError?) {
        
        capturedVideoPath = videoDict![PBJVisionVideoPathKey] as! String
        isVideo = true
        self.performSegueWithIdentifier("captureSegue", sender: nil)
        
        
    }
    
    //Timer
    func floatToString(f: Float64) -> String {
        let v = Int64(f)
        let m = v / 60
        let s = v % 60
        return (m < 10 ? "0" : "") + "\(m)" + ":" + (s < 10 ? "0" : "") + "\(s)"
    }
    
    func updateVideoTimer(){
        videoTimer.text = floatToString(vision.capturedVideoSeconds)
    }
    
    
 
    
    // tabs for switching mode
    @IBAction func switchToPhoto(sender: AnyObject) {
        setupVisionForPhoto(true)
//        buttonPhoto.titleLabel?.textColor = UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1)
//        buttonVideo.titleLabel?.textColor = UIColor.whiteColor()
        buttonVideo.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonPhoto.setTitleColor(UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1), forState: .Normal)
        buttonTakePhoto.hidden = false
        buttonTakeVideo.hidden = true
        videoTimer.hidden = true
    }
    
    @IBAction func switchToVideo(sender: AnyObject) {
        setupVisionForPhoto(false)
//        buttonPhoto.titleLabel?.textColor = UIColor.whiteColor()
        buttonPhoto.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        buttonVideo.setTitleColor(UIColor(red: 139/255, green: 195/255, blue: 74/255, alpha: 1), forState: .Normal)
        buttonTakePhoto.hidden = true
        buttonTakeVideo.hidden = false
        videoTimer.hidden = false

    
    }
    
    @IBAction func switchToLibrary(sender: AnyObject) {
    }
    
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let postImageViewController = segue.destinationViewController as! PostImageViewController
        
        if isVideo {
            postImageViewController.capturedImage2 = nil
            postImageViewController.capturedVideoPath2 = capturedVideoPath
        }else{
            postImageViewController.capturedImage2 = capturedImage
            postImageViewController.capturedVideoPath2 = nil
        }
        
        videoTimer.text = String("00:00")
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
