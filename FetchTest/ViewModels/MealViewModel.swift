// MealViewModel.swift

import Foundation

@MainActor class MealViewModel: ObservableObject {
    /// The meal to display
    @Published var meal: FullMeal?

    /// Whether or not the view is loading
    @Published var isLoading = false

    /// An error that occurs during the request
    @Published var error: Error?

    /// Whether or not to show the alert for the error
    @Published var showAlert: Bool = false
    
    /// The meals service
    private let service: MealsServiceable
    
    init(service: MealsServiceable = MealsService()) {
        self.service = service
    }
    
    /// Fetches a meal for a given id and either sets the meal or the error
    /// - Parameter id: The id of the meal to fetch
    func fetchMeal(with id: String) async {
        isLoading = true
        do {
            let meal = try await service.fetchMeal(with: id)
            self.meal = meal
        } catch {
            self.error = error
            self.showAlert = true
        }
        isLoading = false
    }
}
