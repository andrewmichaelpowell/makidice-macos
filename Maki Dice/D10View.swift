//  Maki Dice (macOS)
//  github.com/andrewmichaelpowell

import SwiftUI

struct D10View: View {
	@State private var diceString: String = ""
	@State private var diceValue: Int = 0
	@State private var difficultyString: String = ""
	@State private var difficultyValue: Int = 0
	@State private var selected: Int = 1
	@State private var successesString: String = ""
	@State private var successesValue: Int = 0

	var body: some View {
		VStack {
			Spacer()
			HStack {
				label("Dice")
				Text(diceString)
					.font(.largeTitle)
					.foregroundColor(.primary)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.lineLimit(1)
					.minimumScaleFactor(0.2)
			}
			.padding(.horizontal)
			HStack {
				label("Difficulty")
				Text(difficultyString)
					.font(.largeTitle)
					.foregroundColor(.primary)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.lineLimit(1)
					.minimumScaleFactor(0.2)
			}
			.padding(.horizontal)
			HStack {
				Text("Successes")
					.font(.largeTitle)
					.foregroundColor(.primary)
					.frame(maxWidth: .infinity, alignment: .leading)
					.lineLimit(1)
					.minimumScaleFactor(0.2)
				Text(successesString)
					.font(.largeTitle)
					.foregroundColor(.primary)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.lineLimit(1)
					.minimumScaleFactor(0.2)
			}
			.padding(.horizontal)
			SegmentChooser(
				selection: $selected,
				options: [(1, "Dice"), (2, "Difficulty")]
			)
			.padding()
			VStack {
			}
			.padding(.vertical, 4)
			HStack {
				numberButton(1)
				numberButton(2)
				numberButton(3)
			}
			.padding(.horizontal)
			HStack {
				numberButton(4)
				numberButton(5)
				numberButton(6)
			}
			.padding(.horizontal)
			HStack {
				numberButton(7)
				numberButton(8)
				numberButton(9)
			}
			.padding(.horizontal)
			HStack {
				clearButton
				numberButton(10)
				rollButton
			}
			.padding(.horizontal)
			VStack {
			}
			.padding(.vertical)
		}
	}

	private func label(_ text: LocalizedStringKey) -> some View {
		Text(text)
			.font(.largeTitle)
			.foregroundColor(.primary)
			.frame(maxWidth: .infinity, alignment: .leading)
			.lineLimit(1)
			.minimumScaleFactor(0.2)
	}

	private var clearButton: some View {
		Button(action: clear) {
			Text("Clear")
				.font(.title)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, maxHeight: 40)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
		}
		.glassButton(tint: .makiOrange)
	}

	private func clear() {
		diceValue = 0
		difficultyValue = 0
		successesValue = 0
		diceString = ""
		difficultyString = ""
		successesString = ""
	}

	private func addValueToSide(buttonValue: Int) {
		if selected == 1 {
			diceValue = buttonValue
			diceString = (String(diceValue))
		}
		if selected == 2 {
			difficultyValue = buttonValue
			difficultyString = (String(difficultyValue))
		}
	}

	private func numberButton(_ digit: Int) -> some View {
		Button(action: { addValueToSide(buttonValue: digit) }) {
			Text(String(digit))
				.font(.title)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, maxHeight: 40)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
		}
		.glassButton()
	}

	private var rollButton: some View {
		Button(action: roll) {
			Text("Roll")
				.font(.title)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, maxHeight: 40)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
		}
		.glassButton(tint: .makiOrange)
	}

	private func roll() {
		if (diceValue != 0) && (difficultyValue != 0) {
			successesValue = 0
			for _ in 1...diceValue {
				let roll = Int.random(in: 1...10)
				if roll == 1 {
					successesValue = successesValue - 1
				} else if roll == 10 {
					successesValue = successesValue + 2
				} else if roll >= difficultyValue {
					successesValue = successesValue + 1
				}
			}
			successesString = ""
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
				successesString = String(successesValue)
			}
		}
	}
}
