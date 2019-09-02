//
//  AboutViewController.swift
//  ClickLock
//
//  Created by marcosmr on 8/15/19.
//  Copyright © 2019 marcosmr. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}

extension AboutViewController {
    // MARK: Storyboard instantiation
    static func freshController() -> AboutViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier("AboutViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? AboutViewController else {
            fatalError("Why cant i find AboutViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
    
    
}
