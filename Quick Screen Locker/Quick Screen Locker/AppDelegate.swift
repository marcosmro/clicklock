//
//  AppDelegate.swift
//  Quick Screen Locker
//
//  Created by marcosmr on 8/7/19.
//  Copyright © 2019 marcosmr. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu();
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("LockImage"))
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.toolTip = "Left click to lock the screen"
        }
        
        // Construct menu
        menu.addItem(NSMenuItem(title: "Launch on system startup", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About ClickLock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit ClickLock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.leftMouseUp { // Left click
            print("left click")
            lockScreen()
        }
        else { // Right click
            showMenu(sender: self)
        }
    }
    
    // Locks the screen
    // https://github.com/ftiff/MenuLock/blob/master/MenuLock/AppDelegate.swift#L126
    @objc func lockScreen() {
        let libHandle = dlopen("/System/Library/PrivateFrameworks/login.framework/Versions/Current/login", RTLD_LAZY)
        let sym = dlsym(libHandle, "SACLockScreenImmediate")
        typealias myFunction = @convention(c) () -> Void
        let SACLockScreenImmediate = unsafeBitCast(sym, to: myFunction.self)
        SACLockScreenImmediate()
    }
    
    func showMenu(sender: Any?) {
        if let button = statusItem.button {
            let rectangle = (button.window?.frame as NSRect?)
            let posX = CGFloat(integerLiteral: Int(rectangle?.minX ?? 0) - 1)
            let posY = CGFloat(integerLiteral: Int(rectangle?.minY ?? 0) - 5)
            let point = NSPoint(x: posX, y:posY)
            menu.popUp(positioning: nil, at: point, in: nil)
        }
    }
}
