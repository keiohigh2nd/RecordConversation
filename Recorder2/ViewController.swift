//
//  ViewController.swift
//  Recorder
//
//  Created by keivard on 2016/08/30.
//  Copyright © 2016年 keivard. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet var PlayBTN: UIButton!
    @IBOutlet var RecordBTN: UIButton!
    
    
    var soundRecorder : AVAudioRecorder!
    var SoundPlayer : AVAudioPlayer!
    
    var fileName = "audioFile.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupRecorder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRecorder(){
        
        
        var recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
            AVFormatIDKey : NSNumber(int: Int32(kAudioFormatAppleLossless)),
            AVNumberOfChannelsKey : NSNumber(int: 1),
            AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue)),
            AVEncoderBitRateKey : NSNumber(int: Int32(320000))]
        
        var error : NSError?
        
        do {
            soundRecorder = try AVAudioRecorder(URL: getFileURL(), settings: recordSettings)
        } catch var error as NSError {
            soundRecorder = nil
        }
        
        if let err = error{
            
            NSLog("SOmething Wrong")
        }
            
        else {
            
            soundRecorder.delegate = self
            soundRecorder.prepareToRecord()
            
        }
        
    }
    
    
    
    
    func getCacheDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        
        return paths[0]
        
    }
    
    func getFileURL() -> NSURL{
        let path  = (getCacheDirectory() as NSString).stringByAppendingPathComponent(fileName)
        
        let filePath = NSURL(fileURLWithPath: path)
        
        return filePath
    }
    
    
    @IBAction func Record(sender: UIButton) {
        
        if sender.titleLabel?.text == "Record"{
            
            soundRecorder.record()
            sender.setTitle("Stop", forState: .Normal)
            PlayBTN.enabled = false
            
        }
        else{
            
            soundRecorder.stop()
            sender.setTitle("Record", forState: .Normal)
            PlayBTN.enabled = false
        }
        
    }
    
    @IBAction func PlaySound(sender: UIButton) {
        
        if sender.titleLabel?.text == "Play" {
            
            RecordBTN.enabled == false
            sender.setTitle("Stop", forState: .Normal)
            
            preparePlayer()
            SoundPlayer.play()
            
        }
        else{
            
            SoundPlayer.stop()
            sender.setTitle("Play", forState: .Normal)
            
        }
        
    }
    
    func preparePlayer(){
        
        var error : NSError?
        do {
            SoundPlayer = try AVAudioPlayer(contentsOfURL: getFileURL())
        } catch let error1 as NSError {
            error = error1
            SoundPlayer = nil
        }
        
        if let err = error{
            
            NSLog("sjkaldfhjakds")
        }
        else{
            
            SoundPlayer.delegate = self
            SoundPlayer.prepareToPlay()
            SoundPlayer.volume = 1.0
        }
        
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        PlayBTN.enabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        RecordBTN.enabled = true
        PlayBTN.setTitle("Play", forState: .Normal)
    }
    
}

