import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignRowTests: XCTestCase {
    @MainActor
    func testDesignRowRenders() {
        let row = DesignRow(title: "Test Row") {
            Text("Content")
        }
        let host = UIHostingController(rootView: row)
        XCTAssertNotNil(host.view)
    }
}
