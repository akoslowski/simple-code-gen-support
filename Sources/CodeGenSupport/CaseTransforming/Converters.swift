import Foundation

public func _convertToCamelCase(_ stringKey: String) -> String {
    if stringKey.contains("_") {
        return _convertFromSnakeCase(stringKey)
    } else {
        return _convertFromKebabCase(stringKey)
    }
}

// https://github.com/apple/swift-corelibs-foundation/blob/0ac1a34ab76f6db3196a279c2626a0e4554ff592/Sources/Foundation/JSONDecoder.swift#L103
public func _convertFromSnakeCase(_ stringKey: String) -> String {
    guard !stringKey.isEmpty else { return stringKey }

    // Find the first non-underscore character
    guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "_" }) else {
        // Reached the end without finding an _
        return stringKey
    }

    // Find the last non-underscore character
    var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
    while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "_" {
        stringKey.formIndex(before: &lastNonUnderscore)
    }

    let keyRange = firstNonUnderscore...lastNonUnderscore
    let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
    let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex

    let components = stringKey[keyRange].split(separator: "_")
    let joinedString: String
    if components.count == 1 {
        // No underscores in key, leave the word as is - maybe already camel cased
        joinedString = String(stringKey[keyRange])
    } else {
        joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
    }

    // Do a cheap isEmpty check before creating and appending potentially empty strings
    let result: String
    if leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty {
        result = joinedString
    } else if !leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty {
        // Both leading and trailing underscores
        result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
    } else if !leadingUnderscoreRange.isEmpty {
        // Just leading
        result = String(stringKey[leadingUnderscoreRange]) + joinedString
    } else {
        // Just trailing
        result = joinedString + String(stringKey[trailingUnderscoreRange])
    }
    return result
}

public func _convertFromKebabCase(_ stringKey: String) -> String {
    guard !stringKey.isEmpty else { return stringKey }

    // Find the first non-underscore character
    guard let firstNonUnderscore = stringKey.firstIndex(where: { $0 != "-" }) else {
        // Reached the end without finding an -
        return stringKey
    }

    // Find the last non-underscore character
    var lastNonUnderscore = stringKey.index(before: stringKey.endIndex)
    while lastNonUnderscore > firstNonUnderscore && stringKey[lastNonUnderscore] == "-" {
        stringKey.formIndex(before: &lastNonUnderscore)
    }

    let keyRange = firstNonUnderscore...lastNonUnderscore
    let leadingUnderscoreRange = stringKey.startIndex..<firstNonUnderscore
    let trailingUnderscoreRange = stringKey.index(after: lastNonUnderscore)..<stringKey.endIndex

    let components = stringKey[keyRange].split(separator: "-")
    let joinedString: String
    if components.count == 1 {
        // No underscores in key, leave the word as is - maybe already camel cased
        joinedString = String(stringKey[keyRange])
    } else {
        joinedString = ([components[0].lowercased()] + components[1...].map { $0.capitalized }).joined()
    }

    // Do a cheap isEmpty check before creating and appending potentially empty strings
    let result: String
    if leadingUnderscoreRange.isEmpty && trailingUnderscoreRange.isEmpty {
        result = joinedString
    } else if !leadingUnderscoreRange.isEmpty && !trailingUnderscoreRange.isEmpty {
        // Both leading and trailing underscores
        result = String(stringKey[leadingUnderscoreRange]) + joinedString + String(stringKey[trailingUnderscoreRange])
    } else if !leadingUnderscoreRange.isEmpty {
        // Just leading
        result = String(stringKey[leadingUnderscoreRange]) + joinedString
    } else {
        // Just trailing
        result = joinedString + String(stringKey[trailingUnderscoreRange])
    }
    return result
}

// https://github.com/apple/swift-corelibs-foundation/blob/0ac1a34ab76f6db3196a279c2626a0e4554ff592/Sources/Foundation/JSONEncoder.swift#L127
public func _convertToSnakeCase(_ stringKey: String) -> String {
    guard !stringKey.isEmpty else { return stringKey }

    var words: [Range<String.Index>] = []
    // The general idea of this algorithm is to split words on transition from lower to upper case, then on transition of >1 upper case characters to lowercase
    //
    // myProperty -> my_property
    // myURLProperty -> my_url_property
    //
    // We assume, per Swift naming conventions, that the first character of the key is lowercase.
    var wordStart = stringKey.startIndex
    var searchRange = stringKey.index(after: wordStart)..<stringKey.endIndex

    // Find next uppercase character
    while let upperCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.uppercaseLetters, options: [], range: searchRange) {
        let untilUpperCase = wordStart..<upperCaseRange.lowerBound
        words.append(untilUpperCase)

        // Find next lowercase character
        searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
        guard
            let lowerCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange)
        else {
            // There are no more lower case letters. Just end here.
            wordStart = searchRange.lowerBound
            break
        }

        // Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase letters that we should treat as its own word
        let nextCharacterAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
        if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
            // The next character after capital is a lower case character and therefore not a word boundary.
            // Continue searching for the next upper case for the boundary.
            wordStart = upperCaseRange.lowerBound
        } else {
            // There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
            let beforeLowerIndex = stringKey.index(before: lowerCaseRange.lowerBound)
            words.append(upperCaseRange.lowerBound..<beforeLowerIndex)

            // Next word starts at the capital before the lowercase we just found
            wordStart = beforeLowerIndex
        }
        searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
    }
    words.append(wordStart..<searchRange.upperBound)
    let result = words.map({ (range) in
        return stringKey[range].lowercased()
    }).joined(separator: "_")
    return result
}

public func _convertToCamelCasedComponents(_ stringKey: String) -> [String] {
    guard !stringKey.isEmpty else { return [] }

    var words: [Range<String.Index>] = []
    // The general idea of this algorithm is to split words on transition from lower to upper case, then on transition of >1 upper case characters to lowercase
    //
    // myProperty -> my_property
    // myURLProperty -> my_url_property
    //
    // We assume, per Swift naming conventions, that the first character of the key is lowercase.
    var wordStart = stringKey.startIndex
    var searchRange = stringKey.index(after: wordStart)..<stringKey.endIndex

    // Find next uppercase character
    while let upperCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.uppercaseLetters, options: [], range: searchRange) {
        let untilUpperCase = wordStart..<upperCaseRange.lowerBound
        words.append(untilUpperCase)

        // Find next lowercase character
        searchRange = upperCaseRange.lowerBound..<searchRange.upperBound
        guard
            let lowerCaseRange = stringKey.rangeOfCharacter(from: CharacterSet.lowercaseLetters, options: [], range: searchRange)
        else {
            // There are no more lower case letters. Just end here.
            wordStart = searchRange.lowerBound
            break
        }

        // Is the next lowercase letter more than 1 after the uppercase? If so, we encountered a group of uppercase letters that we should treat as its own word
        let nextCharacterAfterCapital = stringKey.index(after: upperCaseRange.lowerBound)
        if lowerCaseRange.lowerBound == nextCharacterAfterCapital {
            // The next character after capital is a lower case character and therefore not a word boundary.
            // Continue searching for the next upper case for the boundary.
            wordStart = upperCaseRange.lowerBound
        } else {
            // There was a range of >1 capital letters. Turn those into a word, stopping at the capital before the lower case character.
            let beforeLowerIndex = stringKey.index(before: lowerCaseRange.lowerBound)
            words.append(upperCaseRange.lowerBound..<beforeLowerIndex)

            // Next word starts at the capital before the lowercase we just found
            wordStart = beforeLowerIndex
        }
        searchRange = lowerCaseRange.upperBound..<searchRange.upperBound
    }
    words.append(wordStart..<searchRange.upperBound)
    let result = words.map({ (range) in
        return stringKey[range]
    })
    return result.map(String.init)
}
