import GraphQLLanguage

public struct Optimizer {
    public init() {
    }

    public func optimize(document: String) throws -> String {
        return try optimize(source: Source(string: document))
    }

    public func optimize(source: Source) throws -> String {
        let document = try Document.parsing(source)
        let rewritten = try document.rewrite(with: FragmentReplacementRewriter(document: document))
        let rewrittenDocument = try Document.parsing(Source(string: rewritten))

        return try rewrittenDocument.rewrite(with: FragmentRemovalRewriter())
            .trimmingCharacters(in: .newlines)
    }

}
