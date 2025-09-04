import XCTest
import SwiftUI
@testable import DesignSystem

final class BaseViewStaticTests: XCTestCase {
    @MainActor
    func testBaseViewStaticRenders() {
        let base = BaseViewStatic {
            Text("BaseViewStatic Content")
        }
        let host = UIHostingController(rootView: base)
        XCTAssertNotNil(host.view)
    }
}
