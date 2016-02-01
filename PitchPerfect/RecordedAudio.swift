//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Molly Cox on 12/27/15.
//  Copyright © 2015 Molly Cox. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    //  Properties
    var filePathUrl: NSURL!
    var title: String!
    
    // Initialization
    init(filePathUrl: NSURL, title: String){
        // Initialize stored properties
        self.filePathUrl = filePathUrl
        self.title = title
        
        if (filePathUrl.absoluteString.isEmpty || title.isEmpty) {
            // no file to play back:  report an error
            print("No file to play back")
        }
        
    }

}
