// CategoryView.swift

import SwiftUI
import CachedAsyncImage

struct CategoryView: View {
    @StateObject var viewModel = CategoryViewModel()
    var category: Category

    var body: some View {
        NavigationView {
            List(viewModel.meals, id: \.self) { meal in
                NavigationLink(destination: MealView(mealId: meal.idMeal)) {
                    HStack {
                        thumbnail(for: meal.strMealThumb)
                        Text(meal.strMeal)
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
            }
            .navigationTitle(category.strCategory)
            .task {
                await viewModel.fetchMeals(for: category)
            }
        }
    }

    private func thumbnail(for imageURL: String) -> some View {
        URLImage(url: URL(string: imageURL))
            .scaledToFill()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 75, height: 75)
    }
}

