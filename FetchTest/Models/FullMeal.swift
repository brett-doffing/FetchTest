// FullMeal.swift

import Foundation

struct FullMealsResponse: Decodable {
    let meals: [FullMeal]
}

struct FullMeal: Decodable, Hashable {
    var idMeal: String
    var strMeal: String
    var strDrinkAlternate: String?
    var strCategory: String
    var strArea: String?
    var strTags: String?
    var strInstructions: String
    var strMealThumb: String
    var ingredients: [String]
    var measurements: [String]

    /// Creates a new instance by decoding from the given decoder.
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if reading from the decoder fails, or if the data read is corrupted or otherwise invalid.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.idMeal = try container.decode(String.self, forKey: .id)
        self.strMeal = try container.decode(String.self, forKey: .dessertMealName)
        self.strDrinkAlternate = try container.decodeIfPresent(String.self, forKey: .drinkAlternate)
        self.strCategory = try container.decode(String.self, forKey: .category)
        self.strArea = try container.decodeIfPresent(String.self, forKey: .area)
        self.strTags = try container.decodeIfPresent(String.self, forKey: .tags)
        self.strInstructions = try container.decode(String.self, forKey: .instructions)
        self.strMealThumb = try container.decode(String.self, forKey: .imageURLString)

        self.ingredients = []
        self.measurements = []

        for index in 1...20 {
            let ingredientKeyIndex = "strIngredient\(index)"
            let measurementKeyIndex = "strMeasure\(index)"

            guard let ingredientKey = CodingKeys(rawValue: ingredientKeyIndex) else { return }
            guard let measurementKey = CodingKeys(rawValue: measurementKeyIndex) else { return }

            let ingredient = try container.decode(String.self, forKey: ingredientKey)
            let measurement = try container.decode(String.self, forKey: measurementKey)

            guard !ingredient.isEmpty, !measurement.isEmpty else { return }

            self.ingredients.append(ingredient)
            self.measurements.append(measurement)
        }
    }

   enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case dessertMealName = "strMeal"
        case drinkAlternate = "strDrinkAlternate"
        case category = "strCategory"
        case area = "strArea"
        case tags = "strTags"
        case instructions = "strInstructions"
        case imageURLString = "strMealThumb"

        case ingredient1 = "strIngredient1"
        case ingredient2 = "strIngredient2"
        case ingredient3 = "strIngredient3"
        case ingredient4 = "strIngredient4"
        case ingredient5 = "strIngredient5"
        case ingredient6 = "strIngredient6"
        case ingredient7 = "strIngredient7"
        case ingredient8 = "strIngredient8"
        case ingredient9 = "strIngredient9"
        case ingredient10 = "strIngredient10"
        case ingredient11 = "strIngredient11"
        case ingredient12 = "strIngredient12"
        case ingredient13 = "strIngredient13"
        case ingredient14 = "strIngredient14"
        case ingredient15 = "strIngredient15"
        case ingredient16 = "strIngredient16"
        case ingredient17 = "strIngredient17"
        case ingredient18 = "strIngredient18"
        case ingredient19 = "strIngredient19"
        case ingredient20 = "strIngredient20"

        case measurement1 = "strMeasure1"
        case measurement2 = "strMeasure2"
        case measurement3 = "strMeasure3"
        case measurement4 = "strMeasure4"
        case measurement5 = "strMeasure5"
        case measurement6 = "strMeasure6"
        case measurement7 = "strMeasure7"
        case measurement8 = "strMeasure8"
        case measurement9 = "strMeasure9"
        case measurement10 = "strMeasure10"
        case measurement11 = "strMeasure11"
        case measurement12 = "strMeasure12"
        case measurement13 = "strMeasure13"
        case measurement14 = "strMeasure14"
        case measurement15 = "strMeasure15"
        case measurement16 = "strMeasure16"
        case measurement17 = "strMeasure17"
        case measurement18 = "strMeasure18"
        case measurement19 = "strMeasure19"
        case measurement20 = "strMeasure20"
    }
}
