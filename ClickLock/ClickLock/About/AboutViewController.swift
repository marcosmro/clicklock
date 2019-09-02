//
//  ViewController.swift
//  Quick Screen Locker
//
//  Created by marcosmr on 8/7/19.
//  Copyright © 2019 marcosmr. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {

    @IBOutlet weak var appName: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

extension AboutViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> AboutViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("About"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("AboutViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? AboutViewController else {
            fatalError("Why cant i find AboutViewController? - Check About.storyboard")
        }
        return viewcontroller
    }
}

