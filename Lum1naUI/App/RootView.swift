import SwiftUI

/// Hosts shared app state and applies the user's appearance / motion choices
/// to the whole UI, including presented sheets.
struct RootView: View {
    @State private var settings = AppSettings()
    @State private var model = LuminaRunModel()

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HomeView()
            .environment(settings)
            .environment(model)
            .environment(\.luminaMotion, effectiveMotion)
            .preferredColorScheme(settings.appearance.preferredColorScheme)
            .tint(Palette.violet)
    }

    private var effectiveMotion: MotionLevel {
        if reduceMotion { return .off }
        return settings.motion.level
    }
}

#Preview("Root – Dark") {
    RootView()
        .preferredColorScheme(.dark)
}

#Preview("Root – Light") {
    RootView()
        .preferredColorScheme(.light)
}
