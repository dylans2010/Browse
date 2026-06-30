import Foundation

final class AIErrorHandler {
    func handle(_ error: Error) -> Error {
        LoggingService.shared.error("AI Error occurred", error: error)
        return error
    }
}
