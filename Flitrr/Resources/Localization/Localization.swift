//
//  Localization.swift
//  Flitrr
//
//  Created by VladyslavMac on 01.05.2022.
//

import Foundation

enum LocalizationKey: String {
	case settingsTitle = "settings_title"
	case settingsLang = "settings_lang"
	case settingsRestore = "settings_restore"
	case settingsPrivacy = "settings_privacy"
	case settingsRate = "settings_rate"
	case settingsCardCaption = "settings_card_caption"

	case settingsYearTitle = "paywall_year_title"
	case settingsYearCaption = "paywall_year_caption"
	case settingsSubscribNow = "paywall_subscribe_now"
	case settingsYearPriceFull = "paywall_year_price_full"
	case settings6MonthTitle = "paywall_6month_title"
	case settings6MonthCapion = "paywall_6month_caption"
	case settingsMonthTitle = "paywall_month_title"
	case settingsMonthCaption = "paywall_month_caption"
}

final class LocalizationManager {
	
	var locale: String = "en" {
		didSet {
			UserDefaults.standard.set(locale, forKey: "com.filtrr.localizationid")
		}
	}
	
	static let shared = LocalizationManager()
	
	private init() {
		locale = UserDefaults.standard.value(forKey: "com.filtrr.localizationid") as? String ?? "en"
	}
	
	func localizedString(for key: LocalizationKey) -> String {
		NSLocalizedString(key.rawValue, tableName: "Localizable", bundle: .main, value: locale, comment: "")
	}
	
}
