// CategoryMeal.swift

import Foundation


struct CategoryMealsResponse: Decodable {
    var meals: [CategoryMeal]
}

struct CategoryMeal: Decodable, Hashable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}
