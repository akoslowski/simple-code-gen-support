import Foundation

public func safeSymbolName(_ name: String) -> String {
    let newName = name.replacingOccurrences(of: ".", with: "_")
    if keywords.contains(newName) {
        return newName.tickQuoted()
    }
    return newName
}

// https://docs.swift.org/swift-book/documentation/the-swift-programming-language/lexicalstructure/#Keywords-and-Punctuation

let keywords = keywordsUsedInDeclarations
    .union(keywordsUsedInStatements)
    .union(keywordsUsedInExpressionsAndTypes)

let keywordsUsedInDeclarations: Set<String> = [
    "actor",
    "associatedtype",
    "borrowing",
    "class",
    "consuming",
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
    "nonisolated",
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
    "var",
]

let keywordsUsedInStatements: Set<String> = [
    "break",
    "case",
    "catch",
    "continue",
    "default",
    "defer",
    "do",
    "else",
    "fallthrough",
    "for",
    "guard",
    "if",
    "in",
    "repeat",
    "return",
    "throw",
    "switch",
    "where",
    "while",
]

let keywordsUsedInExpressionsAndTypes: Set<String> = [
    "Any",
    "as",
    "await",
    "catch",
    "false",
    "is",
    "nil",
    "rethrows",
    "self",
    "Self",
    "super",
    "throw",
    "throws",
    "true",
    "try"
]
