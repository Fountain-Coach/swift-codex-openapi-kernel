import Foundation

public struct seedRoles: APIRequest {
    public typealias Response = Data
    public var method: String { "POST" }
    public var path: String { "/bootstrap/roles" }
}
