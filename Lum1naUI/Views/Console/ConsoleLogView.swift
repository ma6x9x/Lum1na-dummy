import SwiftUI

/// The stream of console rows shared by the card and the full sheet. The card
/// (`compact`) shows only the latest entries and hides settled hex blocks.
struct ConsoleLogView: View {
    var compact: Bool

    @Environment(LuminaRunModel.self) private var model
    @Environment(AppSettings.self) private var settings

    var body: some View {
        let style = settings.consoleStyle
        VStack(alignment: .leading, spacing: compact ? 1 : 2) {
            if model.logs.isEmpty {
                prompt(text: "awaiting ignition")
            }
            ForEach(entries) { entry in
                ConsoleRowView(
                    entry: entry,
                    style: style,
                    showTimestamp: settings.console.showsTimestamps,
                    artCell: compact ? 6.4 : 7.2
                )
            }
            if !model.logs.isEmpty && model.phase != .idle {
                prompt(text: "")
            }
        }
        .font(TerminalFont.font(style, size: compact ? 15 : 17))
        .foregroundStyle(Palette.phosphor)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var entries: [LogEntry] {
        guard compact else { return model.logs }
        let visible = model.logs.filter { entry in
            if case .hexDump = entry.kind { return !entry.isSettled }
            return true
        }
        return Array(visible.suffix(12))
    }

    private func prompt(text: String) -> some View {
        HStack(spacing: 6) {
            Text("lum1na:~$ \(text)")
                .foregroundStyle(Palette.phosphorViolet)
            BlinkingCursor()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(text.isEmpty ? "Prompt" : "Awaiting ignition")
    }
}
