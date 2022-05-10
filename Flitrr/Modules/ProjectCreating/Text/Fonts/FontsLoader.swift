//
//  FontsLoader.swift
//  Flitrr
//
//  Created by VladyslavMac on 28.04.2022.
//

import Foundation

struct FontSystem: Codable {
	struct Font: Codable {
		var name: String
		var fontname: String
	}
	var featured: [Font]
	var basic: [Font]
	var fancy: [Font]
	var classic: [Font]
	var techno: [Font]
	var miscellaneous: [Font]
}

class FontsLoader {
	
	var fontSystem: FontSystem!
	
	init() {
		guard let url = Bundle.main.url(forResource: "FontSystem", withExtension: "json") else { return }
		guard let data = try? Data(contentsOf: url) else { return }
		guard let obj = try? JSONDecoder().decode(FontSystem.self, from: data) else { return }
		self.fontSystem = obj
	}
	
	func getFontCategories() -> [String] {
		[
            LocalizationManager.shared.localizedString(for: .textFontsFeatured),
            LocalizationManager.shared.localizedString(for: .textFontsBasic),
            LocalizationManager.shared.localizedString(for: .textFontsFancy),
            LocalizationManager.shared.localizedString(for: .textFontsClassic),
            LocalizationManager.shared.localizedString(for: .textFontsTechno),
            LocalizationManager.shared.localizedString(for: .textFontsMisc),
        ]
	}
	
	func fonts(for index: Int) -> [FontSystem.Font] {
		switch index {
		case 0:
			return fontSystem.featured
		case 1:
			return fontSystem.basic
		case 2:
			return fontSystem.fancy
		case 3:
			return fontSystem.classic
		case 4:
			return fontSystem.techno
		case 5:
			return fontSystem.miscellaneous
		default:
			return []
		}
	}
}
