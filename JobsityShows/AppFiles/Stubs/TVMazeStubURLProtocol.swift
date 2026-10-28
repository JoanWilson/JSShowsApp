//
//  TVMazeStubURLProtocol.swift
//  JobsityShows
//
//  Created by Joan Wilson Oliveira on 27/10/26.
//

#if DEBUG
import Foundation

final class TVMazeStubURLProtocol: URLProtocol {

    override class func canInit(with request: URLRequest) -> Bool {
        request.url?.host == "api.tvmaze.com"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let url: URL = request.url else { return }

        let failingPath: String? = ProcessInfo.processInfo.environment["STUB_FAILING_PATH"]
        let isFailing: Bool = failingPath.map { url.path.hasPrefix($0) } ?? false
        let stub: (statusCode: Int, body: String) = isFailing ? (500, "") : TVMazeStubResponses.response(for: url)

        guard let response: HTTPURLResponse = HTTPURLResponse(
            url: url,
            statusCode: stub.statusCode,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        ) else { return }

        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Data(stub.body.utf8))
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
#endif
