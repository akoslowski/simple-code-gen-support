import XCTest

final class WordWrapTests: XCTestCase {

    func testWrappingAtLength() throws {
        XCTAssertEqual(
            "Hello World, how are you doing?".wordWrapped(lineLength: 12),
            [
                "Hello World,",
                "how are you",
                "doing?"
            ]
        )
    }
}
