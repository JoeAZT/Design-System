import XCTest
import SwiftUI
@testable import DesignSystem

@MainActor
final class DesignProgressBarTests: XCTestCase {

    func testDesignProgressBarRenders() {
        let bar = DesignProgressBar(value: 0.5, title: "Progress")
        let host = UIHostingController(rootView: bar)
        XCTAssertNotNil(host.view)
    }
    
    func testDesignProgressBarWithLowerBound() {
        let bar = DesignProgressBar(value: 0.5, lowerBound: "0", title: "Progress")
        let host = UIHostingController(rootView: bar)
        XCTAssertNotNil(host.view)
    }
    
    func testDesignProgressBarWithUpperBound() {
        let bar = DesignProgressBar(value: 0.5, upperBound: "100", title: "Progress")
        let host = UIHostingController(rootView: bar)
        XCTAssertNotNil(host.view)
    }
    
    func testDesignProgressBarWithBothBounds() {
        let bar = DesignProgressBar(value: 0.5, lowerBound: "0", upperBound: "100", title: "Progress")
        let host = UIHostingController(rootView: bar)
        XCTAssertNotNil(host.view)
    }
}
