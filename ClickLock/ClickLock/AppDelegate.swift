//
//  AppDelegate.swift
//  Quick Screen Locker
//
//  Created by marcosmr on 8/7/19.
//  Copyright © 2019 marcosmr. All rights reserved.
//

import Cocoa
import ServiceManagement

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let menu = NSMenu();
    let aboutPopover = NSPopover()

    let helperBundleName = "com.marcosmr.AutoLaunchHelper"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.lockLockedTemplateName)
            button.action = #selector(statusBarButtonClicked(_:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            button.toolTip = "ClickLock v1.0"
        }
        buildMenu()
        aboutPopover.contentViewController = AboutViewController.freshController()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func buildMenu() {
        let itemLaunch = NSMenuItem(title: "Launch on system startup", action: #selector(toggleItemState(_:)), keyEquivalent: "")
        // Enable or disable the auto launch check depending on the system configuration
        let foundHelper = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == helperBundleName
        }
        if (foundHelper) {
            itemLaunch.state = NSControl.StateValue.on
        }
        else {
            itemLaunch.state = NSControl.StateValue.off
        }
        menu.addItem(itemLaunch)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "About ClickLock", action: #selector(showAboutPopover(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "Quit ClickLock", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
    }

    @objc func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.leftMouseUp { // Left click
            lockScreen()
        }
        else { // Right click
            showMenu(sender: self)
        }
    }
    
    // From: https://github.com/ftiff/MenuLock/blob/master/MenuLock/AppDelegate.swift#L126
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
    
    @objc func toggleItemState(_ sender: NSMenuItem) {
        if (sender.state == NSControl.StateValue.on) {
            sender.state = NSControl.StateValue.off
            SMLoginItemSetEnabled(helperBundleName as CFString, false)
        }
        else {
            sender.state = NSControl.StateValue.on
            SMLoginItemSetEnabled(helperBundleName as CFString, true)
        }
    }

    @objc func showAboutPopover(_ sender: Any?) {
        if let button = statusItem.button {
            aboutPopover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            // Activate the app to be able to detect when it will resign active later (see func applicationWillResignActive below)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func applicationWillResignActive(_ notification: Notification) {
        closeAboutPopover(sender: self)
    }
    
    func closeAboutPopover(sender: Any?) {
        aboutPopover.performClose(sender)
    }
}
