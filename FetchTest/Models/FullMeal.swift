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
        let customContainer = try decoder.container(keyedBy: CustomCodingKey.self)
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

        for index in 1..<container.allKeys.count {
            let ingredientKeyIndex = "strIngredient\(index)"
            let measurementKeyIndex = "strMeasure\(index)"

            guard let ingredientKey = CustomCodingKey(stringValue: ingredientKeyIndex) else { return }
            guard let measurementKey = CustomCodingKey(stringValue: measurementKeyIndex) else { return }

            let ingredient = try customContainer.decode(String.self, forKey: ingredientKey)
            let measurement = try customContainer.decode(String.self, forKey: measurementKey)

            guard !ingredient.isEmpty, !measurement.isEmpty else { return }

            self.ingredients.append(ingredient)
            self.measurements.append(measurement)
        }
    }

    private struct CustomCodingKey: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        var intValue: Int?
        init?(intValue: Int) {
            return nil
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
    }
}
