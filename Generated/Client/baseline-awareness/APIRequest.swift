import Foundation

public protocol APIRequest {
    associatedtype Response: Decodable
    var method: String { get }
    var path: String { get }
}
