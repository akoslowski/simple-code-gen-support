import XCTest
@testable import CodeGenSupport

final class CodeBuilderTests: XCTestCase {
    func testBuildingWithStringLiterals() throws {
        @CodeBuilder var code: LinesOfCode {
            "Hello"
            "World"
        }

        XCTAssertEqual(
            code.rawValue,
            [
                SingleLineOfCode(rawValue: "Hello"),
                SingleLineOfCode(rawValue: "World")
            ]
        )
    }

    func testBuildingWithMultilineStringLiteral() throws {
        @CodeBuilder var code: LinesOfCode {
            """
            Hello
            World
            """
        }

        XCTAssertEqual(
            code.rawValue,
            [
                SingleLineOfCode(rawValue: "Hello"),
                SingleLineOfCode(rawValue: "World")
            ]
        )
    }

    func testBuildingWithInterpolationInMultilineStringLiteral() throws {
        @CodeBuilder var code: LinesOfCode {
            for element in ["a", "b", "c"] {
            """
            func \(element)() {}

            """
            }
        }

        XCTAssertEqual(
            code.rawValue,
            [
                SingleLineOfCode(rawValue: "func a() {}"),
                .emptyLine,
                SingleLineOfCode(rawValue: "func b() {}"),
                .emptyLine,
                SingleLineOfCode(rawValue: "func c() {}"),
                .emptyLine
            ]
        )
    }
}
