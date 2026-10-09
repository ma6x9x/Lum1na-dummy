import SwiftUI

/// Applies a stock iOS 26 Liquid Glass surface to content, falling back to an
/// opaque tinted fill when Reduce Transparency is on (per the glass study and
/// the accessibility skill).
struct GlassSurface<S: Shape>: ViewModifier {
    var shape: S
    var tint: Color?
    var interactive: Bool

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @Environment(\.colorScheme) private var scheme

    func body(content: Content) -> some View {
        if reduceTransparency {
            content.background(solidFill, in: shape)
        } else {
            content.glassEffect(glass, in: shape)
        }
    }

    private var glass: Glass {
        var value = Glass.regular
        if let tint { value = value.tint(tint) }
        if interactive { value = value.interactive() }
        return value
    }

    private var solidFill: Color {
        let base = scheme == .dark ? Color(white: 0.12) : Color(white: 0.96)
        guard let tint else { return base }
        return base.mix(with: tint, by: 0.22)
    }
}

extension View {
    /// Convenience for a glass surface clipped to `shape`.
    func glassSurface(
        _ shape: some Shape,
        tint: Color? = nil,
        interactive: Bool = false
    ) -> some View {
        modifier(GlassSurface(shape: shape, tint: tint, interactive: interactive))
    }
}
