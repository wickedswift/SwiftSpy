import Foundation
import SwiftDiagnostics

public enum SpyMacroError {
    struct OnlyWorksOnClasses: Error, DiagnosticMessage {
        let message = "This macro only works on class types"
        let diagnosticID = makeDiagnosticMessageId(for: OnlyWorksOnClasses.self)
        let severity = DiagnosticSeverity.error
    }
}

private func makeDiagnosticMessageId<Class>(for type: Class.Type) -> MessageID {
    MessageID(domain: String(describing: SpyMacro.self), id: String(describing: type))
}
