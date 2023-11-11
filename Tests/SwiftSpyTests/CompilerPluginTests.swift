import XCTest
@testable import SwiftSpyMacros

final class CompilerPluginTests: XCTestCase {

    func testPluginDeclaration() throws {
        let providedMacros = SwiftSpyCompilerPlugin().providingMacros.map(String.init(describing:))
        XCTAssertEqual(["SpyMacro"], providedMacros)
    }
}
