import GraphQLLanguage

/// Replaces usages of GraphQL fragments inline with the fragment defintion.
public struct FragmentReplacementRewriter: Rewriter {
    enum FragmentReplacementError: Error {
        case unknownSelectionType
    }

    public let document: Document

    public init(document: Document) {
        self.document = document
    }

    // MARK: - Rewriter

    public func rewrite(_ rewritable: Rewritable) -> String? {
        switch rewritable {
        case let spread as FragmentSpread:
            return try? rewriteFragmentSpread(spread)
        default:
            return nil
        }
    }

    // MARK: - Private

    /// Finds the definition of a fragment within the document.
    /// - Parameter spread: The fragment that is being applied.
    /// - Returns: The definition of the fragment
    private func findFragmentDefinition(for spread: FragmentSpread) -> FragmentDefinition? {
        document.definitions.first(where: {
            guard let fragmentDefinition = $0 as? FragmentDefinition else { return false }
            return fragmentDefinition.fragmentName == spread.fragmentName
        }) as? FragmentDefinition
    }

    /// Rewrites a selection from a fragment.
    /// - Parameter selection: Selection to spread.
    /// - Returns: Rewritten string for the selection
    private func rewrite(_ selection: Selection) throws -> String? {
        switch selection {
        case let field as Field:
            if let selectionSet = field.selectionSet {
                return "\(field.name) { \(try selectionSet.compactMap(rewrite).joined(separator: " ")) }"
            }

            return field.name
        case let inline as InlineFragment:
            return try inline.selectionSet.compactMap(rewrite).joined(separator: " ")
        case let spread as FragmentSpread:
            return try rewriteFragmentSpread(spread)
        default:
            throw FragmentReplacementError.unknownSelectionType
        }
    }

    /// Rewrites a fragment spread with the definition.
    /// - Parameter spread: Fragment that is being spread.
    /// - Returns: Rewritten string for the fragment spread, containing the fragment defintion itself.
    private func rewriteFragmentSpread(_ spread: FragmentSpread) throws -> String? {
        let fragmentDefinition = findFragmentDefinition(for: spread)
        return try fragmentDefinition?
            .selectionSet
            .compactMap(rewrite)
            .joined(separator: " ")
    }
}
