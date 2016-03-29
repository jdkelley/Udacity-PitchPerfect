//
//  Constants.swift
//  PitchPerfect
//
//  Created by Joshua Kelley on 3/29/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

struct ViewControllerIdentifiers {
    
    static let PlaySoundsViewController: String = "PlaySoundsViewController"
    static let RecordSoundsViewController: String = "RecordSoundsViewController"
    
}

struct Segue {
    static let StopRecording = "stopRecording"
}

struct Storyboard {
    
    static let Main: String = "Main"
    
}

/// A struct (value type) to hold the UI "magic strings" in PitchPerfect. So I
/// only have to update them in one place and I get autocomplete.
struct Label {
    /// Holds Value: `"Recording in Progress"`
    static let RecordingLabelString = "Recording in Progress"
    /// Holds Value: `"Tap to Record"`
    static let NotRecordingLabelString = "Tap to Record"
}