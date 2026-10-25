//  Maki Dice (macOS)
//  github.com/andrewmichaelpowell

import SwiftUI


private let buttonHeight: CGFloat = 48
private let buttonCornerRadius: CGFloat = 20

extension View {
	@ViewBuilder
	func diceButtonStyle(tint: Color? = nil, circle: Bool = false) -> some View {
		if #available(macOS 26.0, *) {
			buttonStyle(GlassTileButtonStyle(tint: tint, circle: circle))
		} else if circle {
			buttonStyle(.borderedProminent)
				.buttonBorderShape(.circle)
				.tint(tint ?? Color(nsColor: .quaternaryLabelColor))
		} else {
			buttonStyle(.borderedProminent)
				.cornerRadius(buttonCornerRadius)
				.tint(tint ?? Color(nsColor: .quaternaryLabelColor))
		}
	}
}

@available(macOS 26.0, *)
private struct GlassTileButtonStyle: ButtonStyle {
	let tint: Color?
	let circle: Bool

	func makeBody(configuration: Configuration) -> some View {
		let glass = Glass.regular.tint(tint?.opacity(1.0)).interactive()
		if circle {
			configuration.label
				.frame(width: 40, height: 40)
				.contentShape(Circle())
				.glassEffect(glass, in: Circle())
		} else {
			configuration.label
				.frame(maxWidth: .infinity)
				.frame(height: buttonHeight)
				.contentShape(RoundedRectangle(cornerRadius: buttonCornerRadius))
				.glassEffect(
					glass,
					in: RoundedRectangle(cornerRadius: buttonCornerRadius)
				)
		}
	}
}
