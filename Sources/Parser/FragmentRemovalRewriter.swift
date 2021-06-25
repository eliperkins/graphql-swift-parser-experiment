import GraphQLLanguage

/// Removes fragment definitions completely.
public struct FragmentRemovalRewriter: Rewriter {
    public func rewrite(_ rewritable: Rewritable) -> String? {
        switch rewritable {
        case is FragmentDefinition:
            return ""
        default:
            return nil
        }
    }
}
