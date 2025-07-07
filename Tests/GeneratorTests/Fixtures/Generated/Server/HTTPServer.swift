import Foundation

public class HTTPServer: URLProtocol {
    static var kernel: HTTPKernel?

    public static func register(kernel: HTTPKernel) {
        self.kernel = kernel
        URLProtocol.registerClass(HTTPServer.self)
    }

    public override class func canInit(with request: URLRequest) -> Bool {
        request.url?.host == "localhost"
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override public func startLoading() {
        guard let kernel = HTTPServer.kernel, let url = request.url else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }
        let req = HTTPRequest(method: request.httpMethod ?? "GET", path: url.path, headers: request.allHTTPHeaderFields ?? [:], body: request.httpBody ?? Data())
        Task {
            do {
                let resp = try await kernel.handle(req)
                let httpResponse = HTTPURLResponse(url: url, statusCode: resp.status, httpVersion: "HTTP/1.1", headerFields: resp.headers)!
                client?.urlProtocol(self, didReceive: httpResponse, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: resp.body)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }

    override public func stopLoading() {}
}
