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
    
    case settingsAppearance = "settings_appearance"
    case settingsIcon = "settings_icon"
    case settingsLight = "settings_light"
    case settingsDark = "settings_dark"
    case settingsSystem = "settings_system"
    
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
    case settings6MonthFull = "paywall_6month_price_full"
	case settingsMonthTitle = "paywall_month_title"
	case settingsMonthCaption = "paywall_month_caption"
    case paywallM = "paywall_m"
    
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
    
    case projectsTitle = "projects_title"
    case projectsFolders = "projects_folders"
    case projectsSelect = "projects_select"
    case projectsFavorites = "projects_favorites"
    case projectsNewFolder = "projects_new_folder"
    case projectsSelectedStr = "projects_selected_str"
    
    case ipickerAspect = "ipicker_aspect"
    case ipickerSquare = "ipicker_square"

    case graphicsTitle = "graphics_title"
    case graphicsLatest = "graphics_latest"

    case backgroundTitle = "background_title"
    case backgroundImage = "background_image"
    case backgroundTrans = "background_trans"
    case backgroundGradient = "background_gradient"
    case backgroundPastel = "background_pastel"

    case filtersTitle = "filters_title"

    case shadowTitle = "shadow_title"
    case shadowSize = "shadow_size"
    case shadowAngle = "shadow_angle"
    case shadowBlur = "shadow_blur"
    case shadowOpacity = "shadow_opacity"
    
    case adjustNoBg = "adjust_no_bg"
    case adjustContrast = "adjust_contrast"
    case adjustSaturation = "adjust_saturation"
    case adjustBrightness = "adjust_brightness"
    case adjustWarmth = "adjust_warmth"

    case layersHide = "layers_hide"
    case layersLock = "layers_lock"
    case layersUnlock = "layers_unlock"
    case layersUnhide = "layers_unhide"
    case layersDelete = "layers_delete"
    case layersUL = "layer_ul"

    case cropTitle = "crop_title"
    case cropOriginal = "crop_original"
    case cropSquare = "crop_square"
    case cropCircle = "crop_circle"
    
    case discoverTitle = "discover_title"
    case discoverSearch = "discover_search"
    case discoverCat = "discover_cat"
    
    case shapesTitle = "shapes_title"
    case shapesSearch = "shapes_search"
    case shapesBasic = "shapes_basic"
    case shapesOutline = "shapes_outline"
    
    case alertTitle = "alert_title"
    case alertDesc = "alert_description"
    case alertA1 = "alert_a1"
    case alertA2 = "alert_a2"
    case alertA3 = "alert_a3"
    
    case folderViewAddProj = "folder_view_add_proj"
    case folderViewRename = "folder_view_rename"
    
    case fileInfoCreated = "file_info_created"
    case fileInfoName = "file_info_name"
    case fileInfoExt = "file_info_ext"
    case fileInfoRes = "file_info_res"
    case fileInfoSize = "file_info_size"
}

final class LocalizationManager {
	
    private var bundle: Bundle!
    
	var locale: String = "en" {
		didSet {
			UserDefaults.standard.set(locale, forKey: "com.filtrr.localizationid")
            guard let path = Bundle.main.path(forResource: locale, ofType: "lproj") else { return }
            bundle = Bundle(path: path)
		}
	}
	
	static let shared = LocalizationManager()
	
	private init() {
		locale = UserDefaults.standard.value(forKey: "com.filtrr.localizationid") as? String ?? "en"
        guard let path = Bundle.main.path(forResource: locale, ofType: "lproj") else { return }
        bundle = Bundle(path: path)
	}
	
	func localizedString(for key: LocalizationKey) -> String {
        bundle?.localizedString(forKey: key.rawValue, value: nil, table: nil) ?? ""
	}
    func localizedString(for key: String) -> String {
        bundle?.localizedString(forKey: key, value: nil, table: nil) ?? ""
    }
}
