//  Maki Dice (macOS)
//  github.com/andrewmichaelpowell

import SwiftUI

extension Color {
	static let makiOrange = Color(
		red: 240 / 255,
		green: 92 / 255,
		blue: 34 / 255
	)
}

extension View {
	@ViewBuilder
	func glassButton(tint: Color? = nil) -> some View {
		if #available(macOS 26.0, *) {
			if let tint {
				buttonStyle(.glassProminent)
					.buttonBorderShape(.capsule)
					.tint(tint)
			} else {
				buttonStyle(.glass)
					.buttonBorderShape(.capsule)
			}
		} else {
			buttonStyle(.borderedProminent)
				.cornerRadius(20)
				.tint(tint ?? Color(nsColor: .quaternaryLabelColor))
		}
	}

	@ViewBuilder
	func chooserBackground() -> some View {
		if #available(macOS 26.0, *) {
			background {
				Color.clear.glassEffect(.regular.interactive(), in: Capsule())
			}
		} else {
			background(Color(nsColor: .quaternaryLabelColor), in: Capsule())
		}
	}
}

extension Capsule {
	@ViewBuilder
	func selectionFill() -> some View {
		if #available(macOS 26.0, *) {
			fill(Color.clear)
				.glassEffect(.regular.tint(.makiOrange), in: Capsule())
		} else {
			fill(Color.makiOrange)
		}
	}
}

struct SegmentChooser<Value: Hashable>: View {
	@Binding var selection: Value
	let options: [(value: Value, label: LocalizedStringKey)]

	@Namespace private var namespace

	private static var height: CGFloat { 48 }
	private static var inset: CGFloat { 4 }

	var body: some View {
		HStack(spacing: 0) {
			ForEach(options.indices, id: \.self) { index in
				segment(options[index].value, label: options[index].label)
			}
		}
		.padding(Self.inset)
		.frame(height: Self.height)
		.chooserBackground()
		.animation(.snappy, value: selection)
	}

	private func segment(_ value: Value, label: LocalizedStringKey) -> some View
	{
		let isSelected = selection == value
		return Button {
			selection = value
		} label: {
			Text(label)
				.font(.title)
				.foregroundStyle(isSelected ? Color.primary : Color.secondary)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
				.padding(.horizontal, 8)
				.frame(maxWidth: .infinity, maxHeight: .infinity)
				.contentShape(Capsule())
		}
		.buttonStyle(.plain)
		.background {
			if isSelected {
				Capsule()
					.selectionFill()
					.matchedGeometryEffect(id: "selection", in: namespace)
			}
		}
		.accessibilityAddTraits(isSelected ? .isSelected : [])
	}
}
