import Foundation

extension String {
    public static var newLine: String { "\n" }
}

extension Collection where Element == String {
    public func joinedWithNewLine() -> String {
        self.joined(separator: .newLine)
    }
}
