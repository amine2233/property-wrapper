import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(property_wrapperTests.allTests),
    ]
}
#endif
