import XCTest
import SwiftUI
@testable import DesignSystem

final class DesignTextFieldTests: XCTestCase {
    @MainActor
    func testDesignTextFieldRenders() {
        let textField = DesignTextField(placeholder: "Test", text: .constant(""))
        let host = UIHostingController(rootView: textField)
        XCTAssertNotNil(host.view)
    }
}
