import SwiftUI

/// App entry point for the purely cosmetic Lum1na demo.
///
/// Everything in this app is simulated: there is no system modification or
/// privileged behaviour of any kind. Stages, logs and progress are driven by
/// timers only.
@main
struct Lum1naUIApp: App {
    init() {
        TerminalFont.registerIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
