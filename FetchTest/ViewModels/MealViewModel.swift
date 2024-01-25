// MealViewModel.swift

import Foundation

@MainActor class MealViewModel: ObservableObject {
    @Published var meal: FullMeal?
    @Published var isLoading = false
    @Published var error: Error?
    
    private let service: MealsServiceable
    
    init(service: MealsServiceable = MealsService()) {
        self.service = service
    }
    
    func fetchMeal(with id: String) async {
        isLoading = true
        do {
            let meal = try await service.fetchMeal(with: id)
            self.meal = meal
        } catch {
            self.error = error
        }
        isLoading = false
    }
}
