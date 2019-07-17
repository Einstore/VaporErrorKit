import Foundation
import WebErrorKit
import Vapor


extension WebError {
    
    /// Content (`WebErrorContent)`
    public var asContent: WebErrorContent {
        return WebErrorContent(
            code: code,
            reason: reason
        )
    }
    
    /// Convert to JSON `Response.Body`
    /// - Parameter outputFormatting: JSON formatting, default `.prettyPrinted`)
    public func asJsonContentBody(_ outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted) throws -> Response.Body {
        let encoder = JSONEncoder()
        encoder.outputFormatting = outputFormatting
        let data = try encoder.encode(asContent)
        return Response.Body(data: data)
    }
    
    
    /// Convert to JSON `Response`
    /// - Parameter headers: HTTP headers
    /// - Parameter outputFormatting: JSON formatting, default `.prettyPrinted`)
    public func asJsonResponse(
        headers: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"],
        outputFormatting: JSONEncoder.OutputFormatting = .prettyPrinted
        ) throws -> Response {
        return try Response(
            status: status,
            headers: headers,
            body: asJsonContentBody(outputFormatting)
        )
    }
    
}
