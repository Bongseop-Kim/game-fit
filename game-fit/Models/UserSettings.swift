import Foundation
import SwiftData

@Model
final class UserSettings {
    var defaultDifficulty: Difficulty
    var countdownSeconds: Int
    var autoSaveResult: Bool
    var soundEffectOn: Bool
    var hapticOn: Bool
    var bgmOn: Bool
    var isOnboardingComplete: Bool

    init(
        defaultDifficulty: Difficulty = .normal,
        countdownSeconds: Int = 3,
        autoSaveResult: Bool = true,
        soundEffectOn: Bool = true,
        hapticOn: Bool = true,
        bgmOn: Bool = false,
        isOnboardingComplete: Bool = false
    ) {
        self.defaultDifficulty = defaultDifficulty
        self.countdownSeconds = countdownSeconds
        self.autoSaveResult = autoSaveResult
        self.soundEffectOn = soundEffectOn
        self.hapticOn = hapticOn
        self.bgmOn = bgmOn
        self.isOnboardingComplete = isOnboardingComplete
    }
}
