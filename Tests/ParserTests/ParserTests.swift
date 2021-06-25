import XCTest
@testable import Parser

final class OptimizerTests: XCTestCase {
    func test_removesFragments() throws {
        let document = """
        query {
          viewer {
            ...viewer_id
          }
        }

        fragment viewer_id on Viewer {
          id
          allUsers {
            ...user_login
          }
        }

        fragment user_login on User {
          login
        }
        """
        XCTAssertEqual(
            try Optimizer().optimize(document: document),
            """
            query {
              viewer {
                id allUsers { login }
              }
            }
            """
        )
    }
}
