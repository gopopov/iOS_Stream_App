//
//  ViewController.swift
//  stream test
//

import UIKit
import AudioToolbox
import VideoToolbox
import AVFoundation
import Foundation

class ViewController: UIViewController,LFLiveSessionDelegate {
    
    // adding UITextField and UISwitch to link to Main.storyboard
    @IBOutlet weak var streamKey: UITextField!
    @IBOutlet weak var streamEnabled: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        streamEnabled.setOn(false, animated: false)
        
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        
    }
    
    //MARK: - Getters and Setters
    //Using VideoQuality.high3
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.default()
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.high3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        
        return session!
    }()
    
    //MARK: - Event
    func startLive() -> Void {
        let stream = LFLiveStreamInfo()
        stream.url = "rtmp://live.twitch.tv/app/" + streamKey.text!;
        session.startLive(stream)
    }
    
    func stopLive() -> Void {
        session.stopLive()
    }
    
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        // The license dialog did not appear, initiate a license
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        
        // Authorization has been activated and can continue
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        
        // User explicitly denies authorization or camera device cannot access
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        
        // User explicitly denies authorization or camera device cannot access
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                
            })
            break;
        
        // Authorization has been activated and can continue
        case AVAuthorizationStatus.authorized:
            break;
        
        // User explicitly denies authorization or camera device cannot access
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callback
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?){}
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode){}
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState){}
    
    @IBAction func onStreamStart(_ sender: Any) {
        if (streamEnabled.isOn) {
            startLive();
        } else {
            stopLive();
        }
    }
}

