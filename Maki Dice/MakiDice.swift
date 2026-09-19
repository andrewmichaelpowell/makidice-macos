//  Maki Dice
//  github.com/andrewmichaelpowell

import SwiftUI

@main

struct MakiDice: App {
	@NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

	var body: some Scene {
		Window("Maki Dice", id: "main") {
			MainView()
				.frame(minWidth: 384, minHeight: 612)
				.focusEffectDisabled()
		}
		.defaultSize(width: 384, height: 612)
		.windowResizability(.contentMinSize)
	}
}

final class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
		true
	}
}
