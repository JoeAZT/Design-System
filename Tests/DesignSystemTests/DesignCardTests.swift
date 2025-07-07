import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignCardTests: XCTestCase {
    func testDesignCardRenders() {
        let card = DesignCard {
            Text("Card Content")
        }
        let host = UIHostingController(rootView: card)
        XCTAssertNotNil(host.view)
    }
}
