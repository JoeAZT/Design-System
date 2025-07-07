import XCTest
import SwiftUI
@testable import DesignSystem

final class BaseViewTests: XCTestCase {
    func testBaseViewRenders() {
        let base = BaseView {
            Text("BaseView Content")
        }
        let host = UIHostingController(rootView: base)
        XCTAssertNotNil(host.view)
    }
}
