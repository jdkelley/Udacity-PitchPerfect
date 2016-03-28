//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Joshua Kelley on 3/22/16.
//  Copyright © 2016 Joshua Kelley. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidAppear")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: AnyObject) {
        
        print("Record Button Was Pressed")
        recordingLabel.text = "Recording in Progress"
        
    }

    @IBAction func stopRecording(sender: AnyObject) {
        print("stop recording button pressed")
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        stopRecordingButton.enabled = false
    }
    
    // View Methods
    
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
    }
    
    func updateUIForRecordingState(state: RecordingState) { //-> RecordingState {
        recordingLabel.text = state.toString()
        let isRecording = (state == .Recording)
        recordButton.enabled = isRecording
        stopRecordingButton.enabled = !isRecording
        //return state.toggle()
    }
    
    struct Label {
        static let RecordingLabelString = ""
        
        static let NotRecordingLabelString = ""
    }
    
}

