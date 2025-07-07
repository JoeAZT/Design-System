import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignProgressBarTests: XCTestCase {
    @MainActor
    func testDesignProgressBarRenders() {
        let bar = DesignProgressBar(value: 0.5, title: "Progress")
        let host = UIHostingController(rootView: bar)
        XCTAssertNotNil(host.view)
    }
}
