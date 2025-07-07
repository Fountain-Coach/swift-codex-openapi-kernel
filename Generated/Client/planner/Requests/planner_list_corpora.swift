import Foundation

public struct planner_list_corpora: APIRequest {
    public typealias Response = Data
    public var method: String { "GET" }
    public var path: String { "/planner/corpora" }
}
