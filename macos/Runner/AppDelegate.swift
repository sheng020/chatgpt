import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            for window: AnyObject in sender.windows {
                if window.frameAutosaveName == MAIN_WINDOW_NAME {
                    window.makeKeyAndOrderFront(self)
                }
            }
            return true
        }
        return true
    }
    
}

extension AppDelegate : NSWindowDelegate {
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(self)
        return false
    }
    
}
