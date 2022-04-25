//
//  BlinkBoardKeypad.swift
//  
//
//  Created with love and passion by Bertan
//
// The core of the app that lets you type by blinking!
// The logic may or may not have gotten a bit too complex :}

import SwiftUI
import AVKit

struct BlinkBoardKeypad: View {
    @EnvironmentObject private var model: BKViewModel

    // VBState binding value taken from VisionBlinkDetector
    @Binding private var blinkState: VBDState
    // Text to speech engine object to read user typed text
    // See TextToSpeechEngine.swift for more
    @State private var ttsEngine = TextToSpeechEngine()
    // Error text displayed on the keyboard when there is something wrong with the keyboard.
    @State private var errorText: String?

    // State property to hold center stage state
    @State private var csToggleState = false

    // Items of the top level BKIterator
    @State private var mainIteratorItems: [AIItem]?

    init(blinkState: Binding<VBDState>) {
        self._blinkState = blinkState
    }

    var body: some View {
        VStack {
            // The text field and the word predictor places inside a capsule side by side
            HStack {
                TextField("Blink to type...", text: $model.text)
                    .roundedFont(.title3)
                    .disabled(true)
                    .padding(10)
                WordPredictor()
                    .environmentObject(model)
            }
            .frame(height: 45)
            .padding(.trailing)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundStyle(.thinMaterial)
            }

            // Warnings and instructions may take place of the keypad when needed
            // Keypad is shown only when it's activated
            ZStack {
                if let mainIteratorItems = mainIteratorItems {
                    if model.mainKeypadMode == .paused {
                        Label("BlinkBoard is paused, long blink to resume.", systemImage: "moon.zzz.fill")
                            .roundedFont(.title1)
                            .zIndex(1)
                    } else if model.mainKeypadMode == .speaking {
                        Label("Long blink to stop speaking.", systemImage: "text.bubble")
                            .roundedFont(.title1)
                            .zIndex(2)
                    } else {
                        // The keypad itself!
                        BKIterator(items: mainIteratorItems, iteratorID: .main, orientation: .vertical)
                            .environmentObject(model)
                            .zIndex(3)
                    }
                } else if let errorText = errorText {
                    Label(errorText, systemImage: "exclamationmark.triangle.fill")
                        .symbolRenderingMode(.multicolor)
                        .roundedFont(.title1)
                        .zIndex(0)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 280)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .foregroundStyle(.thinMaterial)
            )
            .transition(.opacity)
            .animation(.spring(), value: ttsEngine.isSpeaking)
            .animation(.spring(), value: model.mainKeypadMode)
            .onAppear(perform: keypadSetup)
            .onDisappear {
                model.setMainKeypadMode(.stopped)
            }
            // Look at the methods down below to learn more about what they do!
            .onChange(of: model.mainKeypadMode, perform: handleKeypadModeChange)
            .onChange(of: ttsEngine.isSpeaking, perform: handleSpeakingStateChange)
            .onChange(of: model.mainKeypadCurrentIterator, perform: handleIteratorChange)
            .onChange(of: csToggleState, perform: handleCSToggle)
            .onChange(of: AVCaptureDevice.isCenterStageEnabled, perform: handleCSActivation)
            // Capturing user input!
            .handleBlinks(blinkState: blinkState, onBlink: handleBlink, onLongBlink: handleLongBlink)
        }
        .ignoresSafeArea()
    }

    // Methods containing action button actions!
    private func space() {
        KeyboardSounds().playModifierClick()
        model.text.append(" ")
        model.setMainKeypadIterator(.main)
    }

    private func delete() {
        KeyboardSounds().playDeleteClick()
        if !model.text.isEmpty {
            model.text.removeLast()
        }
        model.setMainKeypadIterator(.main)
    }

    private func clear() {
        KeyboardSounds().playDeleteClick()
        model.text.removeAll()
        model.setMainKeypadIterator(.main)
    }

    private func speak() {
        KeyboardSounds().playDefaultClick()
        if !model.text.isEmpty {
            model.setMainKeypadMode(.speaking)
            ttsEngine.speak(model.text, language: model.language)
        } else {
            model.setMainKeypadIterator(.main)
        }
    }

    private func copy() {
        KeyboardSounds().playDefaultClick()
        UIPasteboard.general.string = model.text
        model.setMainKeypadIterator(.main)
    }

    private func goToWordPredictions() {
        if !model.textPredictions.isEmpty {
            KeyboardSounds().playModifierClick()
            model.setMainKeypadIterator(.wordPredictions)
        }
    }

    private func openMoreMenu() {
        KeyboardSounds().playModifierClick()
        model.setMainKeypadIterator(.moreMenu)
    }

    private func toggleCenterStage() {
        withAnimation {
            KeyboardSounds().playModifierClick()
            csToggleState.toggle()
            model.setMainKeypadIterator(.main)
        }
    }

    // Method to decode BlinkBoardDesign.json file in bundle
    // See BKDesign.swift for more info
    private func bkDesignFromJSON() throws -> BKDesign {
        guard let jsonURL = Bundle.main.url(forResource: "BlinkBoardDesign", withExtension: "json") else {
            throw BKDesignError.jsonMissing
        }
        do {
            let data = try Data(contentsOf: jsonURL)
            let decoder = JSONDecoder()
            let design = try decoder.decode(BKDesign.self, from: data)

            return design
        } catch {
            throw BKDesignError.invalidJSON
        }
    }

    // Setup method run at appear that assigns mainIteratorItems its final value
    private func keypadSetup() {
        do {
            // Read the design from json
            let design = try bkDesignFromJSON()

            // Get character row items from the design
            let charItems = design.getCharItems()

            // Break down all sub iterators to use in forEach
            let subRowIteratorIDs: [[BKIteratorID]] = [
                [.oneA, .oneB], [.twoA, .twoB], [.threeA, .threeB], [.fourA, .fourB]
            ]
            var subRowIterators = [[AIItem]]()

            // Create sub row iterators and assign each character button inside,
            // and then append them into the sub row iterators array
            subRowIteratorIDs.enumerated().forEach { (index, idArray) in
                idArray.enumerated().forEach { (subIndex, id) in
                    subRowIterators.append([])
                    subRowIterators[index].append(AIItem(itemView: AnyView(
                        BKIterator(items: charItems[subIndex + 2 * index], iteratorID: id)), action: {
                            // When the user selects a sub row iterator, it should start to iterate
                            model.setMainKeypadIterator(id)
                        }))
                }
            }

            // Create an array containing all of the action buttons
            var controlItems: [AIItem] = [
                AIItem(itemView: AnyView(BKButton(design.spaceKeyTitle, keySize: 2)), action: space),
                AIItem(itemView: AnyView(BKButton(design.backspaceKeyTitle, keySize: 3)), action: delete),
                AIItem(itemView: AnyView(BKButton(design.clearKeyTitle, keySize: 2)), action: clear),
                AIItem(itemView: AnyView(BKButton(design.speakKeyTitle, keySize: 2)), action: speak),
                AIItem(itemView: AnyView(BKButton(design.copyKeyTitle, keySize: 2)), action: copy),
                AIItem(itemView: AnyView(BKMoreMenu().environmentObject(model)), action: openMoreMenu)
            ]

            // If supported on device, add an additional action button to the last row to toggle Center Stage
            let deviceFormat = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video,
                                                       position: .front)?.activeFormat

            if deviceFormat?.isCenterStageSupported ?? false {
                let centerStageToggle = AIItem(itemView: AnyView(
                    BKCenterStageToggle(isOn: $csToggleState).environmentObject(model)),
                                               action: toggleCenterStage)

                controlItems.insert(centerStageToggle, at: charItems.indices.last! - 2)
            }

            // Place the control items at the last row by adding them to the sub iterator items array
            subRowIterators.append([])
            subRowIterators[4].append(contentsOf: controlItems)

            // Add predictive text menu button at the start of the second row
            subRowIterators[1].insert(AIItem(itemView: AnyView(
                WordPredictorButton().environmentObject(model)), action: goToWordPredictions), at: 0)

            // Break down all main iterator id's to use in forEach
            let rowIteratorIDs: [BKIteratorID] = [.oneM, .twoM, .threeM, .fourM, .control]

            // Create the top level iterator items array
            var mainIteratorItems = [AIItem]()

            // Create row iterators and assign each sub row iterator created above inside,
            // and then append each one of them to the main iterator items array
            rowIteratorIDs.enumerated().forEach { (index, id) in
                mainIteratorItems.append(AIItem(itemView: AnyView(
                    BKIterator(items: subRowIterators[index], iteratorID: id)), action: {
                        // When the user selects a row iterator, it should start to iterate
                        model.setMainKeypadIterator(id)
                    }))
            }

            // Set the language from the keypad design
            model.language = design.languageTag

            handleCSActivation(enabled: AVCaptureDevice.isCenterStageEnabled)
            handleKeypadModeChange(mode: model.mainKeypadMode)

            model.mainKeypadSelectedItemAttributes = nil

            // Finally, assign items to the main iterator at self
            self.mainIteratorItems = mainIteratorItems
        } catch {
            // Show error if there is something wrong with the JSON file
            errorText = error.localizedDescription
        }
    }

    // Starts and stops the keypad iteration accordingly to the newly set mode
    private func handleKeypadModeChange(mode: BKMode) {
        if mode == .active {
            model.setMainKeypadIterator(.main)
        } else {
            model.setMainKeypadIterator(nil)
            model.mainKeypadSelectedItemAttributes = nil
        }
    }

    // Plays a sound effect when the user selects another iterator
    // Ex: Switching to a sub row iterator from a row iterator
    private func handleIteratorChange(newIterator: BKIteratorID?) {
        if let newIterator = newIterator, newIterator != .main {
            KeyboardSounds().playModifierClick()
        }
    }

    // Clears text and shows cancel speaking option so the user on text to speech start
    private func handleSpeakingStateChange(speaking: Bool) {
        if !speaking {
            model.text.removeAll()
            model.setMainKeypadMode(.active)
        }
    }

    // Toggles Center Stage on supported devices
    private func handleCSToggle(isOn: Bool) {
        AVCaptureDevice.isCenterStageEnabled = isOn
    }

    // Updates app UI when the user toggle Center Stage from Control Center
    private func handleCSActivation(enabled: Bool) {
        if self.csToggleState != enabled {
            withAnimation {
                self.csToggleState = enabled
            }
        }
    }

    // Blink and long blink actions that lets the use interact with the keypad
    private func handleBlink() {
        // Do not respond the blinks if keypad is stopped or in the predictive text menu
        if model.mainKeypadMode == .stopped {
            return
        }
        if let selectedItemAttributes = model.mainKeypadSelectedItemAttributes, model.mainKeypadCurrentIterator != nil {
            // If the key has an action, execute it!
            if let action = model.mainKeypadSelectedItemAttributes?.action {
                action()
            }

            // If the key has a character, type it!
            if let keyChar = selectedItemAttributes.keyText {
                KeyboardSounds().playDefaultClick()
                model.text += keyChar
                // Update capitalization formatting
                model.text = model.text.sentenceCapitalized()

                model.setMainKeypadIterator(.main)
            }
        }
    }

    private func handleLongBlink() {
        // Do not respond to long blinks if the keypad is stopped
        if model.mainKeypadMode == .stopped {
            return
        }

        if ttsEngine.isSpeaking {
            // Stop speaking if speaking
            ttsEngine.stopSpeaking(at: .immediate)
            KeyboardSounds().playModifierClick()
        } else {
            if model.mainKeypadMode == .active {
                if model.mainKeypadCurrentIterator != .main {
                    // Go back to the top level iterator and...
                    KeyboardSounds().playModifierClick()
                    model.setMainKeypadIterator(.main)
                } else {
                    // Pause the keyboard if already at the top level iterator
                    KeyboardSounds().playActivationSound()
                    model.setMainKeypadMode(.paused)
                }
            } else {
                // If paused, resume on long blink!
                KeyboardSounds().playActivationSound()
                model.setMainKeypadMode(.active)
            }
        }
    }
}
