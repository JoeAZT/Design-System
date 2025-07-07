import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignToggleTests: XCTestCase {
    func testDesignToggleRenders() {
        let toggle = DesignToggle(title: "Test Toggle", isOn: .constant(true))
        let host = UIHostingController(rootView: toggle)
        XCTAssertNotNil(host.view)
    }
}
