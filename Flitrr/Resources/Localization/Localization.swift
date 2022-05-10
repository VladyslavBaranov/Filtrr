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
    
    case creatingTabImage = "creating_tab_image"
    case creatingTabText = "creating_tab_text"
    case creatingTabGraphic = "creating_tab_graphic"
    case creatingTabShape = "creating_tab_shape"
    case creatingTabBG = "creating_tab_bg"
    case creatingTabFilters = "creating_tab_filters"
    case creatingTabAdjust = "creating_tab_adjust"
    case creatingTabCrop = "creating_tab_crop"
    case creatingTabShadow = "creating_tab_shadow"
    case creatingTabOpacity = "creating_tab_opacity"
    
    case textTitle = "text_title"
    case textColor = "text_color"
    case textFonts = "text_fonts"
    case textStyle = "text_style"
    case textFontsFeatured = "text_fonts_featured"
    case textFontsBasic = "text_fonts_basic"
    case textFontsFancy = "text_fonts_fancy"
    case textFontsClassic = "text_fonts_classic"
    case textFontsTechno = "text_fonts_techno"
    case textFontsMisc = "text_fonts_misc"
    case textFontsAlignment = "text_style_alignment"
    case textFontsLeft = "text_style_left"
    case textFontsCenter = "text_style_center"
    case textFontsRight = "text_style_right"
    case textFontsSize = "text_style_fontsize"
    case textFontsLetterSpacing = "text_style_letterspacing"
    case textFontsLineSpacing = "text_style_linespacing"

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
    func localizedString(for key: String) -> String {
        NSLocalizedString(key, tableName: "Localizable", bundle: .main, value: locale, comment: "")
    }
}
