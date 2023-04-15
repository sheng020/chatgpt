import Cocoa
import FlutterMacOS

let MAIN_WINDOW_NAME = "ChatGPT_MAIN_WINDOW"

class MainFlutterWindow: NSWindow {
    var didInitialResize = false
    
    override func awakeFromNib() {
        let defaults = UserDefaults.standard
        if !didInitialResize && defaults.object(forKey: "NSWindow Frame \(frameAutosaveName)") == nil {
            didInitialResize = true
            
            let screenSize = NSScreen.main!.frame
            
            let percent = CGFloat(1.0)
            let offset: CGFloat = CGFloat((1.0 - percent) / 2.0)
            
            setFrame(NSMakeRect(
                screenSize.size.width * offset,
                screenSize.size.height * offset,
                screenSize.size.width * percent,
                screenSize.size.height * percent),
                     display: true)
        }
        let flutterViewController = FlutterViewController.init()
        let windowFrame = self.frame
        self.contentViewController = flutterViewController
        self.setFrame(windowFrame, display: true)
        setFrameAutosaveName(MAIN_WINDOW_NAME)
        RegisterGeneratedPlugins(registry: flutterViewController)
        
        super.awakeFromNib()
    }
}
