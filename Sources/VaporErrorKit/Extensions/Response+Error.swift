import Vapor
import WebErrorKit


extension Response {
    
    /// Initializer
    /// - Parameter defaultStatus: `HTTPResponseStatus` to use. This defaults to `HTTPResponseStatus.internalServerError`
    /// - Parameter version: `HTTPVersion` of this response, should usually be (and defaults to) 1.1.
    /// - Parameter headers: `HTTPHeaders` to include with this response.
    ///                         Defaults to empty headers.
    ///                         The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically.
    /// - Parameter error: Error or WebError
    /// - Parameter outputFormatting: JSON formatting, default `.prettyPrinted`)
    public convenience init(
        defaultStatus: HTTPResponseStatus = .internalServerError,
        version: HTTPVersion = .init(major: 1, minor: 1),
        headers: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"],
        error: Error,
        outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted
        ) throws {
        if let error = error as? WebError {
            let body = try error.asJsonContentBody()
            self.init(
                status: error.status,
                version: version,
                headers: headers,
                body: body
            )
        } else if let error = error as? AbortError {
            let body = try error.asJsonContentBody()
            self.init(
                status: error.status,
                version: version,
                headers: headers,
                body: body
            )
        } else {
            let encoder = JSONEncoder()
            encoder.outputFormatting = outputFormatting
            let data = try encoder.encode(
                WebErrorContent(
                    code: "internal_server_error",
                    reason: error.localizedDescription
                )
            )
            let body = Response.Body(data: data)
            self.init(
                status: defaultStatus,
                version: version,
                headers: headers,
                body: body
            )
        }
        
    }
    
}
