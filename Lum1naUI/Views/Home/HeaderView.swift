import SwiftUI

/// Top header: the "Lum1na" wordmark, tagline and a glass settings button.
struct HeaderView: View {
    var onSettings: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                WordmarkView(size: 36)
                Text("The guiding light")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 12)
            Button("Settings", systemImage: "gearshape", action: onSettings)
                .labelStyle(.iconOnly)
                .font(.title3)
                .frame(width: 44, height: 44)
                .buttonStyle(.glass)
                .tint(Palette.violet)
        }
    }
}

#Preview("Header – Dark") {
    HeaderView(onSettings: {})
        .padding()
        .background(.black)
        .preferredColorScheme(.dark)
}

#Preview("Header – Light") {
    HeaderView(onSettings: {})
        .padding()
        .preferredColorScheme(.light)
}
