//
//  DSFDockTile+ConstantImage.swift
//  DSFDockTile
//
//  Created by Darren Ford on 17/7/21
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

import AppKit

extension DSFDockTile {

	/// A docktile object which displays a constant image
	public class ConstantImage: Core {

		// Image settings
		private let image: NSImage

		// A lazy imageview to use when displaying images
		private let _imageDisplayView: NSImageView = {
			let v = NSImageView()
			v.wantsLayer = true
			v.imageScaling = .scaleProportionallyUpOrDown
			return v
		}()

		/// Create an instance which displays an image as a docktile
		/// - Parameters:
		///   - image: The image to initially display when creating this instance
		///   - dockTile: The docktile to update. By default, updates the application docktile.
		public init(_ image: NSImage,	dockTile: NSDockTile = NSApp.dockTile) {
			self.image = image
			super.init(dockTile: dockTile)

			// Set the image
			self._imageDisplayView.image = image
		}

		// Present the stored image
		public func display() {
			precondition(Thread.isMainThread)

			guard let tile = self.dockTile else {
				return
			}

			let imageView = self._imageDisplayView

			// If we aren't already being displayed, then make sure to update the content view
			if tile.contentView !== imageView {
				tile.contentView = imageView
			}

			// And update the docktile display
			tile.display()
		}
	}
}
