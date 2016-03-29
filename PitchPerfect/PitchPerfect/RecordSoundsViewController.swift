//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Joshua Kelley on 3/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController : UIViewController {
    
    /// The UI state of this view controller. Note: Setting this value will 
    /// update the UI to reflect the state.
    var isRecording = RecordingState.NotRecording {
        didSet {
            updateUIForRecordingState(isRecording)
        }
    }
    
    // Our recorder
    var audioRecorder: AVAudioRecorder!
    
    // reference to shared instance
    let audioSessionSingleton = AVAudioSession.sharedInstance()

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: - View Controller Life Cycle Methods
    
    override func viewWillAppear(animated: Bool) {
        isRecording = RecordingState.NotRecording // Update UI State
    }

    // MARK: - Recording
    
    @IBAction func recordAudio(sender: AnyObject) {
        isRecording = RecordingState.Recording // Update UI State
        startRecording()
    }

    @IBAction func stopRecording(sender: AnyObject) {
        isRecording = RecordingState.NotRecording // Update UI State
        
        stopAudioSession()
    }
    
    /// A convenience method to improve readability of the Actions
    func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) [0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath,recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        do {
            try audioSessionSingleton.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
            
            audioRecorder.meteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print("Something went wrong! in method: \(#function)")
        }
    }
    
    /// A convenience method to improve readability of the Actions
    func stopAudioSession() {
        audioRecorder.stop()
        
        do {
            try audioSessionSingleton.setActive(false)
        } catch {
            print("Something went wrong! Could not turn off audio session in method: \(#function)")
        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueIdentifier.StopRecording {
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

// MARK: - AVAudioRecorderDelegate

extension RecordSoundsViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.performSegueWithIdentifier(SegueIdentifier.StopRecording, sender: audioRecorder.url)
        } else {
            print("Saving of recording failed - method: \(#function)")
        }
    }
}