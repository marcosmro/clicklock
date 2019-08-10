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
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("LockImage"))
            //button.action = #selector(lockScreen(_:))
        }
        
        popover.contentViewController = LockViewController.freshController()
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
        
        constructMenu()
        
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func constructMenu() {
        let menu = NSMenu()
   
        // Separator
       
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        menu.addItem(NSMenuItem(title: "Lock screen", action: #selector(lockScreen(_:)), keyEquivalent: "l"))
        
        
        statusItem.menu = menu
    }
    
    // Locks the screen
    // https://github.com/ftiff/MenuLock/blob/master/MenuLock/AppDelegate.swift#L126
    @objc func lockScreen(_ sender: NSMenuItem) {
        let libHandle = dlopen("/System/Library/PrivateFrameworks/login.framework/Versions/Current/login", RTLD_LAZY)
        let sym = dlsym(libHandle, "SACLockScreenImmediate")
        typealias myFunction = @convention(c) () -> Void
        let SACLockScreenImmediate = unsafeBitCast(sym, to: myFunction.self)
        SACLockScreenImmediate()
    }
    
    @objc func togglePopover(_ sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

}

