// PartialMeal.swift

import Foundation


struct PartialMealsResponse: Decodable {
    var meals: [PartialMeal]
}

struct PartialMeal: Decodable, Hashable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}
