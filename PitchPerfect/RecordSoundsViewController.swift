//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Molly Cox on 12/3/15.
//  Copyright © 2015 Molly Cox. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recording: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    let tapRecordMessage = "Tap Microphone to Record..."
    let recordMessage = "Recording..."
    let pauseMessage = "Push Pause to resume Recording"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.hidden = true
        playPauseButton.hidden = true
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: Record the user's voice
        
        recordButton.enabled = false
        stopButton.hidden = false
        playPauseButton.hidden = false
        recording.text = recordMessage
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
//       print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            // Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent!)
        
            // Move to the next scene - perform the seque
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            print("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
            playPauseButton.hidden = true
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController

            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    @IBAction func playPauseRecording(sender: UIButton) {
        // If recording, pause the recording
        // If paused, start recording again
        
        if recording.text == recordMessage {
            audioRecorder.pause()
            recording.text = pauseMessage
        }
        else {
            recording.text = recordMessage
            audioRecorder.record()
        }

    }
    @IBAction func stopRecording(sender: UIButton) {
        //Stop Recording
        audioRecorder.stop()

        //Reset buttons and text to original settings
        recording.text = tapRecordMessage

        recordButton.enabled = true
        stopButton.hidden = true
        playPauseButton.hidden = true
        
        let audioSession = AVAudioSession.sharedInstance();
        try! audioSession.setActive(false)
        
    }

}

