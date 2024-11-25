import Foundation
import Splash
import SwiftUI

import class AppKit.NSPasteboard

public struct CodePreview: View {

    struct IndexedLine: Hashable, Identifiable {
        var id: Self { self }
        let index: Int
        let value: String
        let displayIndex: String

        init(index: Int = 0, value: String) {
            self.index = index
            self.value = value
            self.displayIndex = "\(index)".leadingPadding(
                toLength: 5,
                withPad: " "
            )
        }

        static let loadingFailed = IndexedLine(value: "// loading failed")
    }

    struct IndexedLineView: View {
        let index: String
        let value: AttributedString

        var body: some View {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(verbatim: index)
                    .monospaced()
                    .font(.caption)
                    .foregroundColor(Color(.darkGray))

                Text(value)
                    .lineLimit(nil)
            }
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
    }

    @MainActor @Observable final class LineProvider {
        var lines: [IndexedLine] = []
        var selectedLines: Set<Int> = []

        let stringProvider: @Sendable () throws -> String

        init(stringProvider: @Sendable @escaping () throws -> String) {
            self.stringProvider = stringProvider
        }

        var string: String {
            do {
                return try stringProvider()
            } catch {
                return """
                    #error("String provider failed with error")
                    //
                    // Error:
                    // \(error.localizedDescription)
                    """
            }
        }

        func update() async {
            let t = Task(priority: .userInitiated) { [stringProvider] in
                try stringProvider()
                    .components(separatedBy: .newlines)
                    .enumerated()
                    .map {
                        IndexedLine(
                            index: $0.offset,
                            value: $0.element
                        )
                    }
            }

            lines = (try? await t.value) ?? [.loadingFailed]
        }

        func toggleSelection(_ line: IndexedLine) {
            if selectedLines.contains(line.index) {
                selectedLines.remove(line.index)
            } else {
                selectedLines.insert(line.index)
            }
        }

        func isSelected(_ line: IndexedLine) -> Bool {
            selectedLines.contains(line.index)
        }
    }

    let lineProvider: LineProvider
    let theme: Theme
    let highlighter: SyntaxHighlighter<AttributedStringOutputFormat>

    public init(
        theme: Theme = .default,
        code: @Sendable @escaping () throws -> String
    ) {
        self.lineProvider = .init(stringProvider: code)
        self.theme = theme
        self.highlighter = SyntaxHighlighter(
            format: AttributedStringOutputFormat(theme: theme)
        )
    }

    var colorForIndex: SwiftUI.Color {
        Color(theme.tokenColors[.comment] ?? .gray)
    }

    func copyToPasteboard(content: String) {
        NSPasteboard.general.declareTypes([.string], owner: self)
        NSPasteboard.general.setString(content, forType: .string)
    }

    func highlighted(_ code: String) -> AttributedString {
        .init(highlighter.highlight(code))
    }

    public var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible(minimum: 300))],
                alignment: .leading,
                spacing: 0
            ) {
                ForEach(lineProvider.lines) { line in
                    IndexedLineView(
                        index: line.displayIndex,
                        value: highlighted(line.value)
                    )
                    .background(
                        lineProvider.isSelected(line) ? colorForIndex.opacity(0.2) : Color.clear
                    )
                    .contextMenu {
                        Button("\(Image.copy) Copy all lines") {
                            copyToPasteboard(content: lineProvider.string)
                        }
                        if lineProvider.selectedLines.count <= 1 {
                            Button("\(Image.copy) Copy line \(line.index)") {
                                copyToPasteboard(content: line.value)
                            }
                        } else {
                            Button("\(Image.copy) Copy selected lines") {
                                copyToPasteboard(content: lineProvider.lines
                                    .filter { lineProvider.isSelected($0) }
                                    .map(\.value)
                                    .joined(separator: "\n")
                                )
                            }
                            Button("\(Image.trash) Clear selection") {
                                lineProvider.selectedLines.removeAll()
                            }
                        }
                    }
                    .onTapGesture {
                        lineProvider.toggleSelection(line)
                    }
                }
            }
            .padding(.vertical, 8)
        }
        .frame(maxWidth: .infinity)
        .background(Color(theme.backgroundColor))
        .task {
            await lineProvider.update()
        }
    }
}

extension Image {
    static var trash: Self { Image(systemName: "trash") }
    static var copy: Self { Image(systemName: "document.on.document") }
}

extension String {
    func leadingPadding(toLength newLength: UInt, withPad padString: String) -> String {
        guard count <= newLength else { return self }
        return String(repeating: padString, count: Int(newLength) - count) + self
    }
}

public extension Theme {
    static var `default`: Self {
        Theme.presentation(
            withFont: .menlo(size: 12)
        )
    }
}

public extension Splash.Font {
    static func monaco(size: Double) -> Self {
        .init(
            path: "/System/Library/Fonts/Monaco.ttf",
            size: size
        )
    }

    static func menlo(size: Double) -> Self {
        .init(
            path: "/System/Library/Fonts/Menlo.ttc",
            size: size
        )
    }

    static func firaCode(size: Double) -> Self {
        .init(
            path: "~/Library/Fonts/Fira Code Regular Nerd Font Complete Mono.ttf",
            size: size
        )
    }
}

// MARK: - Previews

#Preview {
    CodePreview(
        theme: .presentation(withFont: .menlo(size: 14))
    ) {
        """
        struct Foo<T> {
            // baz
            let baz: T
            /// bar
            /// - Parameter object: object
            func bar(object: T) -> String {
                \"\\(object)\"
            }
            /// bar with identifiable and more text to make it multiline comment to test the layout
            /// - Parameter object: identifiable object
            func bar(object: T) -> String where T: Identifiable {
                \"\\(object.id)\"
            }
        }
        """
    }
}

#Preview {
    CodePreview {
        throw URLError(.badURL)
    }
}

#Preview {
    CodePreview(
        theme: .wwdc17(withFont: .menlo(size: 12))
    ) {
        (0...1_000)
            .map { "struct Line\($0)<T: Hashable> { /* some \($0) */ }" }
            .joined(separator: "\n")
    }
}
