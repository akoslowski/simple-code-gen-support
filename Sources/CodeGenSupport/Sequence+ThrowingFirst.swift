import Foundation

enum PredicateError: Error {
    case elementNotFound
}

extension Sequence {
    public func firstElement(where predicate: (Self.Element) throws -> Bool) throws -> Self.Element {
        try first(where: predicate) ?? { throw PredicateError.elementNotFound }()
    }
}
