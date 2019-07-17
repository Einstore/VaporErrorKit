import Foundation
import WebErrorKit
import Vapor


extension AbortError {
    
    /// Content (`WebErrorContent)`
    public var asContent: WebErrorContent {
        let name = String(describing: type(of: self))
        return WebErrorContent(
            code: name.snake_cased() ?? name,
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
