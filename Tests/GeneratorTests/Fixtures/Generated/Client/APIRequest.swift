import Foundation

/// Empty body type used for requests without a payload.
public struct NoBody: Codable {}

public protocol APIRequest {
    associatedtype Body: Encodable = NoBody
    associatedtype Response: Decodable
    var method: String { get }
    var path: String { get }
    var body: Body? { get }
}
