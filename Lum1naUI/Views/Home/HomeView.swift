import SwiftUI

/// The main screen: a full-screen animated circuit board with the star-on-chip
/// hero (~top half), then progress, the CRT console and the actions. The hero
/// reports its global frame so the board's buses line up with the chip/nodes.
struct HomeView: View {
    @Environment(LuminaRunModel.self) private var model
    @Environment(AppSettings.self) private var settings
    @Environment(\.luminaMotion) private var motion

    @State private var showSettings = false
    @State private var showConsole = false
    @State private var heroFrame: CGRect = .zero

    var body: some View {
        ZStack {
            CircuitBoardView(heroFrame: heroFrame, snapshot: model.boardSnapshot)
            ScrollView {
                VStack(spacing: 8) {
                    VStack(spacing: 8) {
                        HeaderView(onSettings: openSettings)
                        StatusChipsView()
                    }
                    .padding(.horizontal, 18)
                    CircuitHeroView()
                        .containerRelativeFrame(.vertical) { length, _ in
                            min(max(length * 0.45, 300), 380)
                        }
                        .onGeometryChange(for: CGRect.self) { proxy in
                            proxy.frame(in: .global)
                        } action: { frame in
                            heroFrame = frame
                        }
                    VStack(spacing: 8) {
                        ProgressCapsuleView()
                        ConsoleCardView(onExpand: openConsole)
                        ActionButtonsView(onViewLogs: openConsole)
                    }
                    .padding(.horizontal, 18)
                }
                .padding(.top, 4)
                .padding(.bottom, 16)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
        .sheet(isPresented: $showSettings) {
            SettingsSheetView()
                .environment(settings)
                .environment(model)
                .environment(\.luminaMotion, motion)
        }
        .sheet(isPresented: $showConsole) {
            ConsoleSheetView()
                .environment(model)
                .environment(settings)
                .environment(\.luminaMotion, motion)
        }
    }

    private func openSettings() { showSettings = true }
    private func openConsole() { showConsole = true }
}

#Preview("Home – Dark") {
    HomeView()
        .environment(LuminaRunModel())
        .environment(AppSettings())
        .environment(\.luminaMotion, MotionLevel.full)
        .preferredColorScheme(.dark)
}

#Preview("Home – Light") {
    HomeView()
        .environment(LuminaRunModel())
        .environment(AppSettings())
        .environment(\.luminaMotion, MotionLevel.full)
        .preferredColorScheme(.light)
}
