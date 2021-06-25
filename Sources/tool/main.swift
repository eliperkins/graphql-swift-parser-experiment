import ArgumentParser
import struct GraphQLLanguage.Source
import Parser

struct OptimizeCommand: ParsableCommand {
    enum OptimizeCommandError: Error {
        case missingInput
    }

    @Argument(help: "Document to optimize")
    var inputFile: String?

    func run() throws {
        let source: Source
        if let input = inputFile {
            source = try Source(atPath: input)
        } else if let input = readStdin() {
            source = Source(string: input)
        } else {
            OptimizeCommand.exit(withError: OptimizeCommandError.missingInput)
        }
        print("Optimizing...")
        let optimized = try Optimizer().optimize(source: source)
        print(optimized)
    }

    private func readStdin() -> String? {
        var input: String?

        while let line = readLine() {
            if input == nil {
                input = line
            } else {
                input! += "\n" + line
            }
        }

        return input
    }
}

OptimizeCommand.main()
