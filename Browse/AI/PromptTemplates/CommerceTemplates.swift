import Foundation

extension PromptLibrary {
    static func shoppingComparisonPrompt(productContent: String) -> String {
        return "Analyze this product page and compare it with similar products, highlighting pros, cons, and price value:\n\n\(productContent)"
    }

    static func travelPlanningPrompt(destination: String, duration: String) -> String {
        return "Create a travel itinerary for \(destination) for \(duration), including top attractions, restaurants, and tips."
    }
}
