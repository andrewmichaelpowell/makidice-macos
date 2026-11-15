//  Maki Dice (macOS)
//  github.com/andrewmichaelpowell

import SwiftUI

struct RootView: View {
	@AppStorage("SelectedTab") private var selectedTab = RootTab.dice

	enum RootTab: String {
		case dice, d10
	}

	var body: some View {
		ZStack {
			page(MainView(), for: .dice)
			page(D10View(), for: .d10)
		}
		.safeAreaInset(edge: .bottom) {
			PageChooser(selection: $selectedTab)
				.padding(.bottom, 12)
		}
		.toolbar(removing: .title)
		.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
	}

	private func page<Content: View>(_ content: Content, for tab: RootTab)
		-> some View
	{
		let isSelected = selectedTab == tab
		return
			content
			.opacity(isSelected ? 1 : 0)
			.allowsHitTesting(isSelected)
			.accessibilityHidden(!isSelected)
	}
}

private struct PageChooser: View {
	@Binding var selection: RootView.RootTab

	@Namespace private var namespace

	private static let itemWidth: CGFloat = 80
	private static let itemHeight: CGFloat = 44
	private static let inset: CGFloat = 4

	var body: some View {
		HStack(spacing: 0) {
			item(.dice, label: Text("Calculator")) {
				Image("DiceTabIcon")
					.renderingMode(.template)
			}
			item(.d10, label: Text("D10")) {
				Text("D10")
					.font(.system(size: 19, weight: .semibold))
			}
		}
		.padding(Self.inset)
		.chooserBackground()
		.animation(.snappy, value: selection)
	}

	private func item<Icon: View>(
		_ tab: RootView.RootTab,
		label: Text,
		@ViewBuilder icon: () -> Icon
	) -> some View {
		let isSelected = selection == tab
		return Button {
			selection = tab
		} label: {
			icon()
				.foregroundStyle(Color.primary)
				.frame(width: Self.itemWidth, height: Self.itemHeight)
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
		.accessibilityLabel(label)
		.accessibilityAddTraits(isSelected ? .isSelected : [])
	}
}
