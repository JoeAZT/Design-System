import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignListItemTests: XCTestCase {
    func testDesignListItemRenders() {
        let item = DesignListItem(title: "Test Item", subtitle: "Subtitle")
        let host = UIHostingController(rootView: item)
        XCTAssertNotNil(host.view)
    }
}
