import SwiftSpy
import XCTest

private protocol Interface {
    var stringProperty: String { get }
    func intReturning() -> Int
    func voidReturning()
}

@Spy
private class Subject: Interface {
    var stringProperty: String {
        _returnAndRecord("string")
    }
    func intReturning() -> Int {
        _returnAndRecord(1)
    }
    func voidReturning() {
        _returnAndRecord_voidReturning()
    }
    func asynchronous() async -> [String] {
        await MainActor.run {
            _returnAndRecord(["string 1", "string 2"])
        }
    }
}

final class RecordingTest: XCTestCase {
    func testRecording() async throws {
        let subject = Subject()

        XCTAssertEqual(0, subject._timesCalled_intReturning)
        XCTAssertEqual(0, subject._timesCalled_stringProperty)
        XCTAssertEqual(0, subject._timesCalled_voidReturning)

        _ = subject.intReturning()
        _ = subject.stringProperty
        _ = subject.stringProperty
        subject.voidReturning()
        subject.voidReturning()
        subject.voidReturning()

        XCTAssertEqual(1, subject._timesCalled_intReturning)
        XCTAssertEqual(2, subject._timesCalled_stringProperty)
        XCTAssertEqual(3, subject._timesCalled_voidReturning)
        
        XCTAssertEqual(0, subject._timesCalled_asynchronous)
        _ = await subject.asynchronous()
        XCTAssertEqual(1, subject._timesCalled_asynchronous)
        
        XCTAssertEqual(1, subject._values_intReturning.last)
        XCTAssertEqual("string", subject._values_stringProperty.last)
        XCTAssertEqual(["string 1", "string 2"], subject._values_asynchronous.last)
    }
}
