// CategoryView.swift

import SwiftUI
import CachedAsyncImage

struct CategoryView: View {
    @StateObject var viewModel = CategoryViewModel()
    var category: MealCategory

    var body: some View {
        NavigationView {
            meals
            .navigationTitle(category.strCategory)
            .task {
                await viewModel.fetchMeals(for: category)
            }
        }
        .overlay {
            if viewModel.isLoading { ProgressView().scaleEffect(2) }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("ok", role: .cancel, action: {
                viewModel.error = nil
            })
        } message: {
            Text("Apologies, but it looks like something went wrong.")
            Text(viewModel.error?.localizedDescription ?? "")
        }
    }

    /// Creates a list of navigation links for the meals
    private var meals: some View {
        List(viewModel.meals, id: \.self) { meal in
            NavigationLink(destination: MealView(mealId: meal.idMeal)) {
                HStack {
                    thumbnail(for: meal.strMealThumb)
                    Text(meal.strMeal)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
        }
    }

    /// Creates a thumbnail for a given image URL
    private func thumbnail(for imageURL: String) -> some View {
        URLImage(url: URL(string: imageURL))
            .scaledToFill()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 75, height: 75)
    }
}

