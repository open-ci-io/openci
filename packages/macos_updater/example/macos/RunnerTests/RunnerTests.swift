import XCTest
@testable import macos_updater

class RunnerTests: XCTestCase {
  func testSetFeedUrlValidatesTheUrl() {
    let plugin = MacosUpdaterPlugin()
    XCTAssertNoThrow(try plugin.setFeedUrl(url: "https://example.com/appcast.xml"))
    XCTAssertThrowsError(try plugin.setFeedUrl(url: "http://["))
  }
}
