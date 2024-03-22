import Foundation

// MARK: - Core

public protocol CodeRepresentable: CustomStringConvertible {
    @CodeBuilder var code: LinesOfCode { get }
}

extension CodeRepresentable {
    public var description: String { code.stringRepresentation() }
}

@resultBuilder public struct CodeBuilder {
    public static func buildBlock(_ components: LinesOfCode...) -> LinesOfCode {
        LinesOfCode(components)
    }

    public static func buildOptional(_ component: LinesOfCode?) -> LinesOfCode {
        component ?? LinesOfCode()
    }

    public static func buildEither(first component: LinesOfCode) -> LinesOfCode {
        component
    }

    public static func buildEither(second component: LinesOfCode) -> LinesOfCode {
        component
    }

    public static func buildExpression(_ expression: LinesOfCode) -> LinesOfCode {
        expression
    }

    public static func buildExpression(_ expression: SingleLineOfCode) -> LinesOfCode {
        LinesOfCode(rawValue: [expression])
    }

    public static func buildExpression(_ expression: some CodeRepresentable) -> LinesOfCode {
        expression.code
    }

    static public func buildArray(_ components: [LinesOfCode]) -> LinesOfCode {
        LinesOfCode(components)
    }
}

// MARK: - Extensions

public struct DocComment: CodeRepresentable {
    public var code: LinesOfCode

    public init(_ comment: LinesOfCode) {
        code =
            comment
            .wordWrapped()
            .commented()
    }

    public init(@CodeBuilder content: @escaping () -> LinesOfCode) {
        self.init(content())
    }

    public init(_ comment: String) {
        self.init(LinesOfCode(comment.trimmingCharacters(in: .whitespacesAndNewlines)))
    }

    public static var emptyLine: DocComment {
        DocComment(.emptyLine)
    }
}
