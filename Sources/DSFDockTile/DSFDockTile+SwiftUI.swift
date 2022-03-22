//
//  SwiftUIView.swift
//  DSFDockTile
//
//  Created by Darren Ford on 22/3/2022.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#if canImport(SwiftUI)

import SwiftUI

/// The doctile to modify
public enum DocTileLocation {
	/// The application's docktile
	case application
	/// The docktile for the window containing the `DockTile` view
	case window
}

/// A SwiftUI view for setting the content of a dock tile.
///
/// To set the content of the dock tile, use the `DockView` view and provide the view content/label to the initializer.
/// You can set the docktile content from anywhere in your code, but it would be prudent to centralise access to a single location.
///
/// ```swift
/// @State var dockText: String = ""
/// var body: some Scene {
///    WindowGroup {
///       ZStack {
///          ContentView()
///          DockTile(
///             .window,
///             label: "3",
///             content: ZStack {
///                Color.white
///                Text(dockText)
///             }
///          )
///       }
///    }
/// }
/// ```
@available(macOS 10.15, *)
public struct DockTile: NSViewRepresentable {
	private let location: DocTileLocation
	private let label: String
	private let content: AnyView?

	/// Create a docktile container
	/// - Parameters:
	///   - location: Which docktile to update (.application for the application docktile, .window for the docktile for the window containing the View)
	///   - label: The label to apply to the docktile
	public init(_ location: DocTileLocation = .application, label: String) {
		self.content = nil
		self.location = location
		self.label = label
	}

	/// Create a docktile container
	/// - Parameters:
	///   - location: Which docktile to update (.application for the application docktile, .window for the docktile for the window containing the View)
	///   - label: The label to apply to the docktile
	///   - content: The content View to display in the docktile, or nil to restore the default doctile view
	public init<ViewContentType: View>(_ which: DocTileLocation = .application, label: String = "", content: ViewContentType?) {
		self.content = AnyView(content)
		self.location = which
		self.label = label
	}

	public func makeNSView(context: Context) -> DockTileView {
		let c = DockTileView()
		c.translatesAutoresizingMaskIntoConstraints = false
		c.widthAnchor.constraint(equalToConstant: 0).isActive = true
		c.heightAnchor.constraint(equalToConstant: 0).isActive = true
		return c
	}

	public func updateNSView(_ nsView: DockTileView, context: Context) {
		let which = (location == .window) ? nsView.window?.dockTile : NSApp?.dockTile

		if let which = which {
			if let content = content {
				let dockViewController = NSHostingController(rootView: content)
				let dt = DSFDockTile.View(dockViewController, dockTile: which)
				dt.display()
			}
			else {
				which.contentView = nil
			}
		}

		which?.badgeLabel = self.label
	}

	public final class DockTileView: NSView {
		override public var intrinsicContentSize: NSSize { .zero }
		override public func viewDidMoveToWindow() {
			super.viewDidMoveToWindow()
		}
	}

	public typealias NSViewType = DockTileView
}

#endif
