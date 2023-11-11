import SwiftSyntax

struct SpyDeclarationMapper {
    func mapTimesCalledDecl(name: String) -> DeclSyntax {
        """
        private (set) var _timesCalled_\(raw: name) = 0
        """
    }
    
    func mapValuesDecl(name: String, type: String) -> DeclSyntax {
        """
        private (set) var _values_\(raw: name): [\(raw: type)] = []
        """
    }
    
    func mapReturnAndRecord(name: String, returnType: String?) -> DeclSyntax {
        if let returnType {
            return """
            func _returnAndRecord(_ \(raw: name)Value: \(raw: returnType)) -> \(raw: returnType) {
                _timesCalled_\(raw: name) += 1
                _values_\(raw: name).append(\(raw: name)Value)
                return \(raw: name)Value
            }
            """
        } else {
            return """
            func _returnAndRecord_\(raw: name)() {
                _timesCalled_\(raw: name) += 1
            }
            """
        }
    }
}
