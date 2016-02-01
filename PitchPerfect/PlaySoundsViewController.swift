//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Molly Cox on 12/17/15.
//  Copyright © 2015 Molly Cox. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class PlaySoundsViewController: UIViewController {

//  create 2 audioplayers to make the echo effect
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()

        audioPlayer = try!
            AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer.enableRate = true
        
        audioPlayer2 = try!
            AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        audioPlayer2.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlow(sender: UIButton) {
        pauseAudioRecording()
        playAudioAtRate(audioPlayer, rate: 0.5)
    }

    @IBAction func playFast(sender: UIButton) {
        pauseAudioRecording()
        playAudioAtRate(audioPlayer, rate: 2.0)
    }
    
    @IBAction func playEchoAudio(sender: AnyObject) {
        // Stop all audio to play Echo correctly
        stopAudioRecording()
        playAudioAtRate(audioPlayer, rate: 1.0)
        
        let delay:NSTimeInterval = 0.1//100ms
        var playtime:NSTimeInterval
        playtime = audioPlayer2.deviceCurrentTime + delay
        audioPlayer2.volume = 0.8
//      playAudioAtRate(audioPlayer2, rate: 1.0)
//      audioPlayer2.rate = 1.0
        audioPlayer2.playAtTime(playtime)
        
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func stopAudio(sender: UIBarButtonItem) {
        stopAudioRecording()
    }
    
    @IBAction func playAudio(sender: UIBarButtonItem) {
        pauseAudioRecording()
        playAudioAtRate(audioPlayer, rate: 1.0)
    }
    
    
    @IBAction func pauseAudio(sender: UIBarButtonItem) {
        pauseAudioRecording()
    }
    
    private func playAudioWithVariablePitch(pitch: Float){
        pauseAudioRecording()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
        
    }
    
    private func pauseAudioRecording() {
        // stop playing recording but remain at current spot in recording
        audioPlayer.stop()
        audioPlayer2.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    private func stopAudioRecording() {
        // stop playing audio and reset to beginning of recording
        pauseAudioRecording()
        audioPlayer.currentTime = 0.0
        audioPlayer2.currentTime = 0.0
    }
    
    private func playAudioAtRate(audioPlayerX: AVAudioPlayer, rate: Float) {
        audioPlayerX.rate = rate
        audioPlayerX.play()
    }

}
