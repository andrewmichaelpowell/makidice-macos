//  Maki Dice
//  github.com/andrewmichaelpowell

import SwiftUI

struct MainView: View {
	@State private var diceNumber: String = ""
	@State private var diceType: String = ""
	@State private var editSide: Int = 1
	@State private var resetInput: Int = 1
	@State private var resultString: String = ""
	@State private var resultValue: Int = 0

	var body: some View {
		NavigationStack {
			VStack {
				Spacer()
				Text(resultString)
					.font(.largeTitle)
					.foregroundColor(.primary)
					.frame(maxWidth: .infinity, alignment: .trailing)
					.lineLimit(1)
					.minimumScaleFactor(0.2)
				VStack {
					HStack {
						quickButton(4)
						quickButton(6)
						quickButton(8)
					}
					HStack {
						quickButton(10)
						quickButton(12)
						quickButton(20)
					}
					HStack {
						clearButton
						quickButton(100)
						NavigationLink(destination: D10View()) {
							Text("D10")
								.font(.title)
								.foregroundColor(.primary)
								.frame(maxWidth: .infinity, maxHeight: 40)
								.lineLimit(1)
								.minimumScaleFactor(0.2)
						}
						.buttonStyle(.borderedProminent)
						.cornerRadius(20)
						.tint(Color(.teal))
					}
				}
				.padding(.vertical)
				VStack {
				}
				.padding(.vertical, 4)
				VStack {
					HStack {
						numberButton(1)
						numberButton(2)
						numberButton(3)
					}
					HStack {
						numberButton(4)
						numberButton(5)
						numberButton(6)
					}
					HStack {
						numberButton(7)
						numberButton(8)
						numberButton(9)
					}
					HStack {
						dButton
						zeroButton
						rollButton
					}
				}
				VStack {
				}
				.padding(.vertical)
			}
			.padding(.horizontal)
			.toolbar {
				BackButtonSpacer()
			}
		}
	}

	private func quickButton(_ digit: Int) -> some View {
		Button(action: { quickRoll(quickDiceType: digit) }) {
			Text("1d" + String(digit))
				.font(.title)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, maxHeight: 40)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
		}
		.buttonStyle(.borderedProminent)
		.cornerRadius(20)
		.tint(Color(nsColor: .quaternaryLabelColor))
	}

	private func quickRoll(quickDiceType: Int) {
		resultValue = Int.random(in: 1...quickDiceType)
		editSide = 1
		resetInput = 1
		diceNumber = "1"
		diceType = String(quickDiceType)
		resultString = ""
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
			resultString = String(resultValue)
		}
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
		.buttonStyle(.borderedProminent)
		.cornerRadius(20)
		.tint(Color(.orange))
	}

	private func clear() {
		editSide = 1
		diceNumber = ""
		diceType = ""
		resultString = ""
	}

	private func setRight(buttonValue: Int) {
		if diceType == "" {
			diceType = diceType + String(buttonValue)
			resultString = diceNumber + "d" + diceType
		} else if diceType.count < 3 {
			diceType = diceType + String(buttonValue)
			resultString = diceNumber + "d" + diceType
		}
	}

	private func setLeft(buttonValue: Int) {
		if resetInput == 1 {
			diceNumber = ""
			diceType = ""
			resetInput = 0
		}
		if diceNumber == "" {
			diceNumber = diceNumber + String(buttonValue)
			resultString = diceNumber
		} else if diceNumber.count < 3 {
			diceNumber = diceNumber + String(buttonValue)
			resultString = diceNumber
		}
	}

	private func appendDigit(buttonValue: Int) {
		if editSide == 1 {
			setLeft(buttonValue: buttonValue)
		}
		if editSide == 2 {
			setRight(buttonValue: buttonValue)
		}
	}

	private func numberButton(_ digit: Int) -> some View {
		Button(action: { appendDigit(buttonValue: digit) }) {
			Text(String(digit))
				.font(.title)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, maxHeight: 40)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
		}
		.buttonStyle(.borderedProminent)
		.cornerRadius(20)
		.tint(Color(nsColor: .quaternaryLabelColor))
	}

	private var zeroButton: some View {
		Button(action: zero) {
			Text("0")
				.font(.title)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, maxHeight: 40)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
		}
		.buttonStyle(.borderedProminent)
		.cornerRadius(20)
		.tint(Color(nsColor: .quaternaryLabelColor))
	}

	private func zero() {
		if editSide == 1 {
			if (diceNumber != "") && (resetInput == 0) {
				appendDigit(buttonValue: 0)
			}
		}
		if editSide == 2 {
			if (diceType != "") && (resetInput == 0) {
				appendDigit(buttonValue: 0)
			}
		}
	}

	private var dButton: some View {
		Button(action: d) {
			Text("d")
				.font(.title)
				.foregroundColor(.primary)
				.frame(maxWidth: .infinity, maxHeight: 40)
				.lineLimit(1)
				.minimumScaleFactor(0.2)
		}
		.buttonStyle(.borderedProminent)
		.cornerRadius(20)
		.tint(Color(.orange))
	}

	private func d() {
		if (editSide == 1) && (resetInput == 0) {
			editSide = 2
			resultString = diceNumber + "d"
		}
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
		.buttonStyle(.borderedProminent)
		.cornerRadius(20)
		.tint(Color(.orange))
	}

	private func roll() {
		if (diceNumber != "") && (diceType != "") {
			resultValue = 0
			for _ in 1...Int(diceNumber)! {
				resultValue = resultValue + Int.random(in: 1...Int(diceType)!)
			}
			resultString = ""
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
				resultString = String(resultValue)
			}
			editSide = 1
			resetInput = 1
		}
	}
}

// Reserves the toolbar height that D10View's back button needs, so the title bar and window don't resize when navigating
private struct BackButtonSpacer: ToolbarContent {
	@ToolbarContentBuilder
	var body: some ToolbarContent {
		if #available(macOS 26.0, *) {
			ToolbarItem(placement: .navigation) {
				Image(systemName: "chevron.left")
					.hidden()
			}
			.sharedBackgroundVisibility(.hidden)
		} else {
			ToolbarItem(placement: .navigation) {
				Image(systemName: "chevron.left")
					.hidden()
			}
		}
	}
}
