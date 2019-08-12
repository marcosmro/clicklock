//
//  LockViewController.swift
//  Quick Screen Locker
//
//  Created by marcosmr on 8/7/19.
//  Copyright © 2019 marcosmr. All rights reserved.
//

import Cocoa

class LockViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension LockViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> LockViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("LockViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? LockViewController else {
            fatalError("Why cant i find LockViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}
