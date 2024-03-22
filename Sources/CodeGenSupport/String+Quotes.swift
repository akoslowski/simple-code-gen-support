import Foundation

extension String {
    public func quoted() -> String {
        "\"\(self)\""
    }

    public func tickQuoted() -> String {
        "`\(self)`"
    }
}
