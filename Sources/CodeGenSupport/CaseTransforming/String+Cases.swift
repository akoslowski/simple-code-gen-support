import Foundation

extension String {
    public func upperCamelCased() -> String {
        camelCased().uppercasedFirst()
    }

    public func lowerCamelCased() -> String {
        camelCased().lowercasedFirst()
    }

    public func uppercasedFirst() -> String {
        let head = first!.uppercased()
        let tail = dropFirst()
        return "\(head)\(tail)"
    }

    public func lowercasedFirst() -> String {
        let head = first!.lowercased()
        let tail = dropFirst()
        return "\(head)\(tail)"
    }

    public func camelCased() -> String {
        _convertToCamelCase(self)
    }

    public func snakeCased() -> String {
        _convertToSnakeCase(self)
    }

    public func pluralizedLastComponent() -> String {
        transformLastComponentOfCamelCasedString(self) { $0.pluralized() }.joined()
    }

    public func singularizedLastComponent() -> String {
        transformLastComponentOfCamelCasedString(self) { $0.singularized() }.joined()
    }

    // MARK: -
    
    private func transformLastComponentOfCamelCasedString(
        _ string: String,
        transform: @escaping (String) -> String
    ) -> [String] {
        var components = _convertToCamelCasedComponents(string)
        guard let lastComponent = components.last else { return [] }
        let newLastComponent = transform(lastComponent)
        components = components.dropLast()
        components.append(newLastComponent)
        return components
    }

    private func pluralized() -> String {
        var string = AttributedString(self)
        var morphology = Morphology()
        morphology.number = .plural
        string.inflect = InflectionRule(morphology: morphology)
        let result = string.inflected()
        return String(result.characters)
    }

    private func singularized() -> String {
        var string = AttributedString(self)
        var morphology = Morphology()
        morphology.number = .singular
        string.inflect = InflectionRule(morphology: morphology)
        let result = string.inflected()
        return String(result.characters)
    }
}
