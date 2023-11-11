import SwiftSyntax

struct SpyGenerator {
    private let mapper: SpyDeclarationMapper

    init(mapper: SpyDeclarationMapper) {
        self.mapper = mapper
    }
    
    func generate(members: MemberBlockItemListSyntax) -> [DeclSyntax] {
        let context = ProcessingContext()

        for member in members {
            if let variableDecl = member.decl.as(VariableDeclSyntax.self), let variableName = variableDecl.bindings.first?.pattern.trimmedDescription {
                processVariable(
                    name: variableName,
                    type: variableDecl.bindings.first?.typeAnnotation?.type.trimmedDescription,
                    into: context
                )
            }
            if let functionDecl = member.decl.as(FunctionDeclSyntax.self) {
                processFunction(
                    name: functionDecl.name.trimmedDescription,
                    returnType: functionDecl.signature.returnClause?.type.trimmedDescription,
                    into: context
                )
            }
        }
        return context.allDeclarations()
    }
    
    private func processVariable(name: String, type: String?, into context: ProcessingContext) {
        context.timesCalled.append(mapper.mapTimesCalledDecl(name: name))
        
        if let type {
            context.values.append(mapper.mapValuesDecl(name: name, type: type))
            context.returnAndRecord.append(mapper.mapReturnAndRecord(name: name, returnType: type))
        }
    }
    
    private func processFunction(name: String, returnType: String?, into context: ProcessingContext) {
        context.timesCalled.append(mapper.mapTimesCalledDecl(name: name))
        context.returnAndRecord.append(mapper.mapReturnAndRecord(name: name, returnType: returnType))
        
        if let returnType {
            context.values.append(mapper.mapValuesDecl(name: name, type: returnType))
        }
    }
}

private class ProcessingContext {
    var timesCalled = [DeclSyntax]()
    var returnAndRecord = [DeclSyntax]()
    var values = [DeclSyntax]()
    
    func allDeclarations() -> [DeclSyntax] {
        returnAndRecord + timesCalled + values
    }
}
