//
//  Constants.swift
//  PitchPerfect
//
//  Created by Joshua Kelley on 3/29/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import Foundation

// All the magic strings

struct SegueIdentifier {
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

struct Alerts {
    static let DismissAlert = "Dismiss"
    static let RecordingDisabledTitle = "Recording Disabled"
    static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
    static let RecordingFailedTitle = "Recording Failed"
    static let RecordingFailedMessage = "Something went wrong with your recording."
    static let AudioRecorderError = "Audio Recorder Error"
    static let AudioSessionError = "Audio Session Error"
    static let AudioRecordingError = "Audio Recording Error"
    static let AudioFileError = "Audio File Error"
    static let AudioEngineError = "Audio Engine Error"
}
