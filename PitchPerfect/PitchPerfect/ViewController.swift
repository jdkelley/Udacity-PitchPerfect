//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Joshua Kelley on 3/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var isRecording = RecordingState.NotRecording {
        didSet {
            updateUIForRecordingState(isRecording)
        }
    }

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
     Description
     */
    enum RecordingState {
        case Recording
        case NotRecording
        
        func toString() -> String {
            switch self {
            case .Recording:
                return Label.RecordingLabelString
            case .NotRecording:
                return Label.NotRecordingLabelString
            }
        }
        
        func toggle() -> RecordingState {
            switch self {
            case .Recording:
                return .NotRecording
            case .NotRecording:
                return .Recording
            }
        }
        
        var value: Bool {
            get {
                return (self == .Recording)
            }
        }
    }
    
    func updateUIForRecordingState(state: RecordingState) { //-> RecordingState {
        recordingLabel.text = state.toString()
        recordButton.enabled = !state.value
        stopRecordingButton.enabled = state.value
    }
    
    struct Label {
        static let RecordingLabelString = "Recording in Progress"
        
        static let NotRecordingLabelString = "Tap to Record"
    }
    
}

