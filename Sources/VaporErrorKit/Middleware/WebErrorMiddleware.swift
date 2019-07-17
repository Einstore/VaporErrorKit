import Vapor


/// Captures all errors and transforms them into an HTTP response.
public final class WebErrorMiddleware: Middleware {
    
    public static func `default`(environment: Environment) -> WebErrorMiddleware {
        return .init { req, error in
            // log the error
            req.logger.report(error: error, verbose: !environment.isRelease)
            
            // attempt to serialize the error to json response
            do {
                return try Response(error: error)
            } catch {
                return Response(
                    status: .internalServerError,
                    headers: ["Content-Type": "text/plain; charset=utf-8"],
                    body: .init(string: "Oops: \(error)")
                )
            }
        }
    }
    
    /// Error-handling closure.
    private let closure: (Request, Error) -> (Response)
    
    /// Create a new `WebErrorMiddleware`.
    ///
    /// - parameters:
    ///     - closure: Error-handling closure. Converts `Error` to `Response`.
    public init(_ closure: @escaping (Request, Error) -> (Response)) {
        self.closure = closure
    }
    
    /// See `Middleware`.
    public func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        return next.respond(to: request).flatMapErrorThrowing { error in
            return self.closure(request, error)
        }
    }
}
