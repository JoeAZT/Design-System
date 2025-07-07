import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignButtonTests: XCTestCase {
    @MainActor
    func testDesignButtonRenders() {
        // This test simply ensures the view can be created and rendered.
        let button = DesignButton(title: "Test Button")
        let host = UIHostingController(rootView: button)
        XCTAssertNotNil(host.view)
    }
}
