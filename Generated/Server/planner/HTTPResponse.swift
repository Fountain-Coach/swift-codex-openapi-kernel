import Foundation

public struct HTTPResponse {
    public var status: Int
    public var body: Data

    public init(status: Int = 200, body: Data = Data()) {
        self.status = status
        self.body = body
    }
}
