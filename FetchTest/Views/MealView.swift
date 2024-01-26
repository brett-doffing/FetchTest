// MealView.swift

import SwiftUI

struct MealView: View {
    @StateObject var viewModel = MealViewModel()
    let mealId: String

    var body: some View {
        mealView
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchMeal(with: mealId)
        }
        .overlay {
            if viewModel.isLoading { ProgressView().scaleEffect(1.5) }
        }
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel, action: {
                viewModel.error = nil
            })
        } message: {
            VStack {
                Text($viewModel.error.wrappedValue?.localizedDescription ?? "")
            }
        }
    }

    /// Creates a view for the meal
    private var mealView: some View {
        ScrollView {
            if let meal = viewModel.meal {
                banner(for: meal.strMealThumb)
                VStack(alignment: .leading) {
                    Text(meal.strMeal)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    instructions(text: meal.strInstructions)
                    ingredients(meal: meal)
                }
                .padding()
            }
        }
    }

    /// Creates a banner for a given image URL or returns an empty view
    private func banner(for imageURL: String) -> some View {
        AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 200)
                .clipped()
        } placeholder: {
            EmptyView()
        }
    }

    /// Creates a view for the instructions
    private func instructions(text: String) -> some View {
        VStack(alignment: .leading) {
            Text("Instructions:")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Text(text)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke()
                }
        }

    }

    /// Creates a view for the ingredients
    private func ingredients(meal: FullMeal) -> some View {
        VStack(alignment: .leading) {
            Text("Ingredients:")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .padding(.vertical)
            ForEach(0..<meal.ingredients.count, id: \.self) { i in
                HStack {
                    Text(meal.ingredients[i])
                    Spacer()
                    Text(meal.measurements[i])
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke()
            }
        }
    }
}
