import UIKit

// Standard way

struct Typewriter: AsyncSequence {
    typealias Element = String
    
    let phrase: String
    
    func makeAsyncIterator() -> TypewriterIterator {
        return TypewriterIterator(phrase)
    }
}

struct TypewriterIterator: AsyncIteratorProtocol {
    typealias Element = String
    let phrase: String
    var index: String.Index
    
    init(_ phrase: String) {
        self.phrase = phrase
        self.index = phrase.startIndex
    }
    
    mutating func next() async throws -> String? {
        guard index < phrase.endIndex else { return nil }
        try await Task.sleep(nanoseconds: 1_000_000_000)
        defer { index = phrase.index(after: index) }
        return String(phrase[phrase.startIndex...index])
    }
}

Task {
    for try await item in Typewriter(phrase: "Hello, world!") {
        print(item)
    }
}

// AsyncStream adoption

var phrase = "AsyncStream!"
var index = phrase.startIndex
// making asyncstream with unfolding closure
let stream = AsyncStream<String> {
    guard index < phrase.endIndex else { return nil }
    do {
        try await Task.sleep(nanoseconds: 1_000_000_000)
    } catch { return nil }
    defer { index = phrase.index(after: index) }
    return String(phrase[phrase.startIndex...index])
}

Task {
    for try await item in stream {
        print(item)
    }
}
