import Foundation

public func safeSymbolName(_ name: String) -> String {
    let newName = name.replacingOccurrences(of: ".", with: "_")
    let reservedWords = [
        "actor",
        "associatedtype",
        "class",
        "deinit",
        "enum",
        "extension",
        "fileprivate",
        "func",
        "import",
        "init",
        "inout",
        "internal",
        "let",
        "open",
        "operator",
        "private",
        "precedencegroup",
        "protocol",
        "public",
        "rethrows",
        "static",
        "struct",
        "subscript",
        "typealias",
        "var"
    ]
    if reservedWords.contains(newName) {
        return newName.tickQuoted()
    }
    return newName
}
