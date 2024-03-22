import XCTest

final class CaseTransformerTests: XCTestCase {
    func testCamelCased() throws {
        XCTAssertEqual("helloWorld".camelCased(), "helloWorld")
        XCTAssertEqual("HELLO_WORLD".camelCased(), "helloWorld")
        XCTAssertEqual("HELLO-WORLD".camelCased(), "helloWorld")
    }

    func testLowerCamelCased() throws {
        XCTAssertEqual("helloWorld".lowerCamelCased(), "helloWorld")
        XCTAssertEqual("HELLO_WORLD".lowerCamelCased(), "helloWorld")
        XCTAssertEqual("HELLO-WORLD".lowerCamelCased(), "helloWorld")

        XCTAssertEqual("HELLOWORLD".lowerCamelCased(), "hELLOWORLD")
        XCTAssertEqual("helloworld".lowerCamelCased(), "helloworld")
    }

    func testUpperCamelCased() throws {
        XCTAssertEqual("helloWorld".upperCamelCased(), "HelloWorld")
        XCTAssertEqual("HELLO_WORLD".upperCamelCased(), "HelloWorld")
        XCTAssertEqual("HELLO-WORLD".upperCamelCased(), "HelloWorld")

        XCTAssertEqual("HELLOWORLD".upperCamelCased(), "HELLOWORLD")
        XCTAssertEqual("helloworld".upperCamelCased(), "Helloworld")
    }

    func testUppercasedFirst() throws {
        XCTAssertEqual("hello".uppercasedFirst(), "Hello")
        XCTAssertEqual("HELLO".uppercasedFirst(), "HELLO")
    }

    func testLowercasedFirst() throws {
        XCTAssertEqual("hello".lowercasedFirst(), "hello")
        XCTAssertEqual("HELLO".lowercasedFirst(), "hELLO")
    }

    func testSnakeCased() throws {
        XCTAssertEqual("helloWorld".snakeCased(), "hello_world")
        XCTAssertEqual("hello_world".snakeCased(), "hello_world")

        XCTAssertEqual("HELLO_WORLD".snakeCased(), "h_ello_world")
        XCTAssertEqual("HELLO-WORLD".snakeCased(), "h_ello-world")
    }

    func testPluralizedLastComponent() throws {
        XCTAssertEqual("helloWorld".pluralizedLastComponent(), "helloWorlds")
        XCTAssertEqual("smartGoose".pluralizedLastComponent(), "smartGeese")
    }

    func testSingularizedLastComponent() throws {
        XCTAssertEqual("helloWorlds".singularizedLastComponent(), "helloWorld")
        XCTAssertEqual("smartGeese".singularizedLastComponent(), "smartGoose")
    }
}
