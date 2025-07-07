import Foundation
import Dispatch
#if os(Linux)
import Glibc
#else
import Darwin
#endif

final class SimpleHTTPRuntime {
    enum RuntimeError: Error { case socket, bind, listen }
    let kernel: HTTPKernel
    let port: Int32
    private var serverFD: Int32 = -1

    init(kernel: HTTPKernel, port: Int32 = 8080) {
        self.kernel = kernel
        self.port = port
    }

    func start() throws {
        serverFD = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
        guard serverFD >= 0 else { throw RuntimeError.socket }
        var opt: Int32 = 1
        setsockopt(serverFD, SOL_SOCKET, SO_REUSEADDR, &opt, socklen_t(MemoryLayout.size(ofValue: opt)))
        var addr = sockaddr_in()
        addr.sin_family = sa_family_t(AF_INET)
        addr.sin_port = in_port_t(UInt16(port).bigEndian)
        addr.sin_addr = in_addr(s_addr: in_addr_t(0))
        let bindResult = withUnsafePointer(to: &addr) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { ptr in
                bind(serverFD, ptr, socklen_t(MemoryLayout<sockaddr_in>.size))
            }
        }
        guard bindResult >= 0 else { throw RuntimeError.bind }
        guard listen(serverFD, 16) >= 0 else { throw RuntimeError.listen }
        DispatchQueue.global().async { [weak self] in self?.acceptLoop() }
    }

    private func acceptLoop() {
        while true {
            var addr = sockaddr()
            var len: socklen_t = socklen_t(MemoryLayout<sockaddr>.size)
            let fd = accept(serverFD, &addr, &len)
            if fd >= 0 {
                DispatchQueue.global().async {
                    self.handle(fd: fd)
                }
            }
        }
    }

    private func handle(fd: Int32) {
        var buffer = [UInt8](repeating: 0, count: 4096)
        let n = read(fd, &buffer, buffer.count)
        guard n > 0 else { close(fd); return }
        let data = Data(buffer[0..<n])
        guard let request = parseRequest(data) else { close(fd); return }
        Task {
            let resp = try await kernel.handle(request)
            let respData = serialize(resp)
            respData.withUnsafeBytes { _ = write(fd, $0.baseAddress!, respData.count) }
            close(fd)
        }
    }

    private func parseRequest(_ data: Data) -> HTTPRequest? {
        guard let string = String(data: data, encoding: .utf8) else { return nil }
        let parts = string.components(separatedBy: "\r\n\r\n")
        let headerLines = parts[0].split(separator: "\r\n")
        guard let requestLine = headerLines.first else { return nil }
        let tokens = requestLine.split(separator: " ")
        guard tokens.count >= 2 else { return nil }
        let method = String(tokens[0])
        let path = String(tokens[1])
        return HTTPRequest(method: method, path: path)
    }

    private func serialize(_ resp: HTTPResponse) -> Data {
        var text = "HTTP/1.1 \(resp.status) OK\r\n"
        text += "Content-Length: \(resp.body.count)\r\n"
        text += "\r\n"
        var data = Data(text.utf8)
        data.append(resp.body)
        return data
    }
}

let kernel = HTTPKernel()
do {
    let runtime = SimpleHTTPRuntime(kernel: kernel, port: 8080)
    try runtime.start()
    print("function-caller server listening on port 8080")
    dispatchMain()
} catch {
    print("Failed to start server: \(error)")
}
