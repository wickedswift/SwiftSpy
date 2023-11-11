import SwiftSyntax
import SwiftSyntaxMacros

public struct SpyMacro: MemberMacro {
    private static let gen = SpyGenerator(mapper: SpyDeclarationMapper())

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw SpyMacroError.OnlyWorksOnClasses()
        }
        return gen.generate(members: classDecl.memberBlock.members)
    }
}

