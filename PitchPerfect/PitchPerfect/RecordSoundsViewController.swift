//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Joshua Kelley on 3/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    /// The UI state of this view controller. Note: Setting this value will 
    /// update the UI to reflect the state.
    var isRecording = RecordingState.NotRecording {
        didSet {
            updateUIForRecordingState(isRecording)
        }
    }
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        print("Record Button Was Pressed")
        isRecording = RecordingState.Recording // Update UI State
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
            
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording button pressed")
        isRecording = RecordingState.NotRecording // Update UI State
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        isRecording = RecordingState.NotRecording // Update UI State
    }
    
    // MARK: - View Methods
    
    /**
     UI State for the initial view of Pitch Perfect.
     
     Possible States:
      - `Recording`
      - `NotRecording` 
     
     Available Methods:
     
      - `toString` : This method returns the text for the recording label.
      - `toggle` : This method returns a RecordingState instance that is opposite of `self`.
      - `value` : This is a computed property that returns if `self` is .Recording.
     */
    enum RecordingState {
        case Recording
        case NotRecording
        
        /// This method returns the text for the recording label.
        func toString() -> String {
            switch self {
            case .Recording:
                return Label.RecordingLabelString
            case .NotRecording:
                return Label.NotRecordingLabelString
            }
        }
        
        /// This method returns a RecordingState instance that is opposite of `self`.
        func toggle() -> RecordingState {
            switch self {
            case .Recording:
                return .NotRecording
            case .NotRecording:
                return .Recording
            }
        }
        
        /// Returns if `self` is .Recording.
        var value: Bool {
            get {
                return (self == .Recording)
            }
        }
    }
    
    /**
     Based on the `RecordingState` passed to this function, this function updates 
     the UI to match the current recording state.
     - parameter state: A `RecordingState` instance off of which to set the view.
     */
    func updateUIForRecordingState(state: RecordingState) {
        recordingLabel.text = state.toString()
        recordButton.enabled = !state.value
        stopRecordingButton.enabled = state.value
    }
    
    /// A struct (value type) to hold the "magic strings" in PitchPerfect. So I 
    /// only have to update them in one place and I get autocomplete.
    struct Label {
        /// Holds Value: `"Recording in Progress"`
        static let RecordingLabelString = "Recording in Progress"
        /// Holds Value: `"Tap to Record"`
        static let NotRecordingLabelString = "Tap to Record"
    }
    
}

