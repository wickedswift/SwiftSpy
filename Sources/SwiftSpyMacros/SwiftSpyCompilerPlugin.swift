import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct SwiftSpyCompilerPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        SpyMacro.self,
    ]
}
