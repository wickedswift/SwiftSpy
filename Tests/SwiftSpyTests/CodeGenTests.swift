import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(SwiftSpyMacros)
import SwiftSpyMacros

let testMacros: [String: Macro.Type] = [
    "Spy": SpyMacro.self,
]

final class CodeGenTests: XCTestCase {
    func testStructError() throws {
        assertMacroExpansion(
            """
            @Spy
            struct SubjectStruct {
            }
            """,
            expandedSource: """
            struct SubjectStruct {
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "This macro only works on class types", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testCodeGen() throws {
        assertMacroExpansion(
            """
            protocol TestInterface {
                var stringConstantProperty: String { get }
                func intReturning() -> Int
                func anotherIntReturning() -> Int
            }
            struct CustomType {
                let boolProperty: Bool
            }
            @Spy
            class SubjectClass: TestInterface {
                let customProperty: CustomType
                let stringConstantProperty: String = "string constant property"

                init() {
                    customProperty = CustomType(boolProperty: true)
                }

                func intReturning() -> Int {
                    return 1
                }
            
                func anotherIntReturning() -> Int {
                    return 2
                }
            
                func voidReturning() {
                    // Do stuff
                }
            }
            """,
            expandedSource: """
            protocol TestInterface {
                var stringConstantProperty: String { get }
                func intReturning() -> Int
                func anotherIntReturning() -> Int
            }
            struct CustomType {
                let boolProperty: Bool
            }
            class SubjectClass: TestInterface {
                let customProperty: CustomType
                let stringConstantProperty: String = "string constant property"

                init() {
                    customProperty = CustomType(boolProperty: true)
                }
            
                func intReturning() -> Int {
                    return 1
                }
            
                func anotherIntReturning() -> Int {
                    return 2
                }

                func voidReturning() {
                    // Do stuff
                }

                func _returnAndRecord_customProperty(_ value: CustomType) -> CustomType {
                    _timesCalled_customProperty += 1
                    _values_customProperty.append(value)
                    return value
                }

                func _returnAndRecord_stringConstantProperty(_ value: String) -> String {
                    _timesCalled_stringConstantProperty += 1
                    _values_stringConstantProperty.append(value)
                    return value
                }
            
                func _returnAndRecord_intReturning(_ value: Int) -> Int {
                    _timesCalled_intReturning += 1
                    _values_intReturning.append(value)
                    return value
                }
            
                func _returnAndRecord_anotherIntReturning(_ value: Int) -> Int {
                    _timesCalled_anotherIntReturning += 1
                    _values_anotherIntReturning.append(value)
                    return value
                }
            
                func _returnAndRecord_voidReturning() {
                    _timesCalled_voidReturning += 1
                }

                private (set) var _timesCalled_customProperty = 0

                private (set) var _timesCalled_stringConstantProperty = 0

                private (set) var _timesCalled_intReturning = 0

                private (set) var _timesCalled_anotherIntReturning = 0

                private (set) var _timesCalled_voidReturning = 0
            
                private (set) var _values_customProperty: [CustomType] = []
            
                private (set) var _values_stringConstantProperty: [String] = []

                private (set) var _values_intReturning: [Int] = []

                private (set) var _values_anotherIntReturning: [Int] = []
            }
            """,
            macros: testMacros
        )
    }
}
#endif
