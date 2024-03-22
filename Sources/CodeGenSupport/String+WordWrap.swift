import Foundation

public func wordWrap(_ text: String, lineLength: UInt = 80) -> [String] {
    text.components(separatedBy: .whitespaces)
        .reduce(into: []) { lines, word in
            if let lastLine = lines.last, lastLine.count + word.count + 1 <= lineLength {
                lines.removeLast()
                lines.append("\(lastLine) \(word)")
            } else {
                lines.append("\(word)")
            }
        }
}

extension String {
    public func wordWrapped(lineLength: UInt = 80) -> [String] {
        wordWrap(self, lineLength: lineLength)
    }
}
