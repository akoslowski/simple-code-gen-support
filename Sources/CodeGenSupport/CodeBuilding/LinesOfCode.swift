import Foundation

/// A single line of code
public struct SingleLineOfCode: RawRepresentable, Equatable {
    public typealias StringLiteralType = String


    /// A single line of code
    public var rawValue: String

    public init?(rawValue: String) {
        // a single line of code must not contain new lines.
        if rawValue.contains("\n") {
            return nil
        }

        self.rawValue = rawValue
    }

    public static var emptyLine: SingleLineOfCode {
        .init(rawValue: "")!
    }

    public func commented(using prefix: String = "/// ") -> SingleLineOfCode {
        .init(rawValue: "\(prefix)\(rawValue)".trimmingCharacters(in: .whitespacesAndNewlines))!
    }
}

/// Multiple lines of code
public struct LinesOfCode:
    RawRepresentable,
    ExpressibleByStringInterpolation,
    Equatable,
    CustomStringConvertible,
    CodeRepresentable
{
    /// Multiple lines of code
    public var rawValue: [SingleLineOfCode]

    // MARK: -

    public init(rawValue: [SingleLineOfCode]) {
        self.rawValue = rawValue
    }

    public init(stringLiteral value: StringLiteralType) {
        rawValue =
            value
            .components(separatedBy: .newlines)
            .compactMap(SingleLineOfCode.init)
    }

    // MARK: -

    public init() {
        self.init(rawValue: [])
    }

    public init(_ optionalString: String?) {
        if let string = optionalString {
            self.init(stringLiteral: string)
        } else {
            self.init()
        }
    }

    public init(_ linesOfCode: [LinesOfCode]) {
        self.init(rawValue: linesOfCode.flatMap(\.rawValue))
    }

    public static var emptyLine: Self {
        self.init(rawValue: [.emptyLine])
    }

    // MARK: -

    public mutating func append(line: SingleLineOfCode) {
        rawValue.append(line)
    }

    public func appending(line: SingleLineOfCode) -> LinesOfCode {
        var lines = rawValue
        lines.append(line)
        return .init(rawValue: lines)
    }

    public mutating func append(lines: LinesOfCode) {
        rawValue.append(contentsOf: lines.rawValue)
    }

    public func appending(lines: LinesOfCode) -> LinesOfCode {
        var _lines = rawValue
        _lines.append(contentsOf: lines.rawValue)
        return .init(rawValue: _lines)
    }

    // MARK: -

    public var code: LinesOfCode {
        self
    }

    public func stringRepresentation() -> String {
        rawValue
            .map(\.rawValue)
            .joined(separator: .newLine)
    }

    public var description: String {
        stringRepresentation()
    }

    // MARK: -

    public mutating func wordWrap(at length: UInt = 80) {
        rawValue = wordWrapped(at: length).rawValue
    }

    public func wordWrapped(at length: UInt = 80) -> LinesOfCode {
        let lines =
            rawValue
            .map { CodeGenSupport.wordWrap($0.rawValue, lineLength: length) }
            .flatMap { $0 }
            .compactMap(SingleLineOfCode.init)

        return .init(rawValue: lines)
    }

    public mutating func comment(using prefix: String = "/// ") {
        rawValue = commented(using: prefix).rawValue
    }

    public func commented(using prefix: String = "/// ") -> LinesOfCode {
        .init(rawValue: rawValue.map { $0.commented(using: prefix) })
    }
}
