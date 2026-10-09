import SwiftUI

/// Primary glass-prominent action (Illuminate → Cancel → Reset depending on
/// phase) and a secondary "View logs" glass button.
struct ActionButtonsView: View {
    var onViewLogs: () -> Void

    @Environment(LuminaRunModel.self) private var model
    @Environment(\.luminaMotion) private var motion

    var body: some View {
        VStack(spacing: 10) {
            Button(action: primaryAction) {
                Label(primaryTitle, systemImage: primarySymbol)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
            }
            .buttonStyle(.glassProminent)
            .controlSize(.large)
            .tint(primaryTint)
            .animation(Motion.adaptive(Motion.smooth, motion: motion), value: model.phase)

            Button(action: onViewLogs) {
                Label("View logs", systemImage: "terminal")
                    .font(.subheadline.weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.glass)
            .controlSize(.large)
        }
        .sensoryFeedback(.selection, trigger: model.phase)
    }

    private func primaryAction() {
        switch model.phase {
        case .idle, .cancelled:
            model.illuminate()
        case .running:
            model.cancel()
        case .success:
            model.reset()
        }
    }

    private var primaryTitle: String {
        switch model.phase {
        case .idle, .cancelled: "Illuminate"
        case .running: "Cancel"
        case .success: "Reset"
        }
    }

    private var primarySymbol: String {
        switch model.phase {
        case .idle, .cancelled: "sparkles"
        case .running: "stop.fill"
        case .success: "arrow.counterclockwise"
        }
    }

    private var primaryTint: Color {
        switch model.phase {
        case .running: Color(red: 1.0, green: 0.42, blue: 0.42)
        default: Palette.violet
        }
    }
}

#Preview("Buttons – Dark") {
    ActionButtonsView(onViewLogs: {})
        .environment(LuminaRunModel())
        .environment(\.luminaMotion, MotionLevel.full)
        .padding()
        .background(.black)
        .preferredColorScheme(.dark)
}
