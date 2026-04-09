import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var settingsArray: [UserSettings]
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @State private var showClearConfirmation = false

    private var settings: UserSettings? { settingsArray.first }

    var body: some View {
        List {
            if let settings {
                @Bindable var s = settings

                Section {
                    Picker("기본 난이도", selection: $s.defaultDifficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { d in
                            Text(d.displayName).tag(d)
                        }
                    }
                    Stepper("카운트다운 \(s.countdownSeconds)초",
                            value: $s.countdownSeconds, in: 1...5)
                    Toggle("결과 자동저장", isOn: $s.autoSaveResult)
                } header: {
                    Text("훈련 설정")
                        .font(.appSectionLabel)
                        .foregroundStyle(Color.appTextSecondary)
                        .textCase(nil)
                }

                Section {
                    Toggle("효과음", isOn: $s.soundEffectOn)
                    Toggle("진동",   isOn: $s.hapticOn)
                    Toggle("BGM",    isOn: $s.bgmOn)
                } header: {
                    Text("소리 · 진동")
                        .font(.appSectionLabel)
                        .foregroundStyle(Color.appTextSecondary)
                        .textCase(nil)
                }

                Section {
                    Button(role: .destructive) {
                        showClearConfirmation = true
                    } label: {
                        HStack {
                            Text("훈련 기록 초기화")
                            Spacer()
                            Image(systemName: "trash")
                        }
                            .foregroundStyle(Color(hex: "#DC2626"))
                    }
                    LabeledContent("앱 버전") {
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0")
                            .foregroundStyle(Color.appTextSecondary)
                    }
                } header: {
                    Text("데이터")
                        .font(.appSectionLabel)
                        .foregroundStyle(Color.appTextSecondary)
                        .textCase(nil)
                }
            } else {
                ProgressView()
            }
        }
        .environment(\.font, .appBody)
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.large)
        .confirmationDialog(
            "훈련 기록을 모두 삭제할까요?",
            isPresented: $showClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("삭제", role: .destructive) { clearAllSessions() }
            Button("취소", role: .cancel) {}
        } message: {
            Text("이 작업은 되돌릴 수 없어요.")
        }
    }

    private func clearAllSessions() {
        do {
            try context.delete(model: GameSession.self)
            appState.refresh(using: context)
        } catch {
            assertionFailure("Failed to clear sessions: \(error)")
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: GameSession.self, UserSettings.self, configurations: config)
    let settings = UserSettings()
    container.mainContext.insert(settings)
    return NavigationStack {
        SettingsView()
            .environment(AppState())
            .modelContainer(container)
    }
}
