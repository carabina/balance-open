import Cocoa

// In the storyboard, ensure the view controller's transition checkboxes are all off, and the NSTabView's delegate is set to this controller object

class PreferencesViewController: NSTabViewController {
    
    var originalSizes = [String : NSSize]()
    
    // MARK: - NSTabViewDelegate -
    
    override func tabView(_ tabView: NSTabView, willSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, willSelect: tabViewItem)
        
        if let tabViewItem = tabViewItem {
            // For each tabViewItem, save the original, as-laid-out-in-IB view size, so it can be used to resize the window with the selected tab changes
            let originalSize = originalSizes[tabViewItem.label]
            if originalSize == nil, let size = tabViewItem.view?.frame.size {
                self.originalSizes[tabViewItem.label] = size
            }
        }
    }
    
    override func tabView(_ tabView: NSTabView, didSelect tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelect: tabViewItem)
        
        if let window = self.view.window, let tabViewItem = tabViewItem {
            window.title = tabViewItem.label
            let size = originalSizes[tabViewItem.label] ?? NSSize(width: 500, height: 500)
            let contentFrame = window.frameRect(forContentRect: NSMakeRect(0.0, 0.0, size.width, size.height))
            var frame = window.frame
            frame.origin.y = frame.origin.y + (frame.size.height - contentFrame.size.height)
            frame.size.height = contentFrame.size.height
            frame.size.width = contentFrame.size.width
            window.setFrame(frame, display: false, animate: true)
        }
    }
}
