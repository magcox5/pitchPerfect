//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Molly Cox on 12/3/15.
//  Copyright © 2015 Molly Cox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBOutlet weak var recording: UILabel!

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: Record the user's voice
        print("in recordAudio")
        recording.hidden = false
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        //TODO:  Stop Recording
        recording.hidden = true
        print("in stopRecording")
    }

}

