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
    var isRecording = RecordingState.notRecording {
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
    
    override func viewWillAppear(_ animated: Bool) {
        isRecording = RecordingState.notRecording // Update UI State
    }

    // MARK: - Recording
    
    @IBAction func recordAudio(_ sender: AnyObject) {
        isRecording = RecordingState.recording // Update UI State
        startRecording()
    }

    @IBAction func stopRecording(_ sender: AnyObject) {
        isRecording = RecordingState.notRecording // Update UI State
        
        stopAudioSession()
    }
    
    /// A convenience method to improve readability of the Actions
    func startRecording() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let recordingName = "recordedVoice.wav"
        let filePath = URL(fileURLWithPath: dirPath, isDirectory: true).appendingPathComponent(recordingName)
        
        do {
            try audioSessionSingleton.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            try audioRecorder = AVAudioRecorder(url: filePath, settings: [:])
            
            audioRecorder.isMeteringEnabled = true
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
        case recording
        case notRecording
        
        /// This method returns the text for the recording label.
        func toString() -> String {
            switch self {
            case .recording:
                return Label.RecordingLabelString
            case .notRecording:
                return Label.NotRecordingLabelString
            }
        }
        
        /// This method returns a RecordingState instance that is opposite of `self`.
        func toggle() -> RecordingState {
            switch self {
            case .recording:
                return .notRecording
            case .notRecording:
                return .recording
            }
        }
        
        /// Returns if `self` is .Recording.
        var value: Bool {
            get {
                return (self == .recording)
            }
        }
    }
    
    /**
     Based on the `RecordingState` passed to this function, this function updates 
     the UI to match the current recording state.
     - parameter state: A `RecordingState` instance off of which to set the view.
     */
    func updateUIForRecordingState(_ state: RecordingState) {
        recordingLabel.text = state.toString()
        recordButton.isEnabled = !state.value
        stopRecordingButton.isEnabled = state.value
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.StopRecording {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

// MARK: - AVAudioRecorderDelegate

extension RecordSoundsViewController : AVAudioRecorderDelegate {
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: SegueIdentifier.StopRecording, sender: audioRecorder.url)
        } else {
            print("Saving of recording failed - method: \(#function)")
        }
    }
}
