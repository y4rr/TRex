import Cocoa
import Combine
import SwiftUI

class Preferences: ObservableObject {
    static let shared = Preferences()
    enum PreferencesKeys: String {
        case CaptureSound
        case ShowMenuBarIcon
        case IgnoreLineBreaks
        case RecongitionLanguage
        case NeedsOnboarding
        case MenuBarIcon
        case AutoOpenCapturedURL
        case AutoOpenQRCodeURL
        case AutoOpenProvidedURL
        case AutoOpenProvidedURLAddNewLine
    }

    enum MenuBarIcon: String, CaseIterable {
        case Option1
        case Option2
        case Option3
        case Option4
        case Option5
        case Option6

        func image() -> Image {
            Image(nsImage: nsImage())
        }

        func nsImage() -> NSImage {
            var image: NSImage?
            switch self {
            case .Option1:
                image = NSImage(named: "trex")!
            case .Option2:
                image = NSImage(named: "perspective")
            case .Option3:
                image = NSImage(named: "crop")
            case .Option4:
                image = NSImage(named: "textbox")
            case .Option5:
                image = NSImage(named: "doc.text.fill.viewfinder")
            case .Option6:
                image = NSImage(named: "text.cursor")
            }
            image?.isTemplate = true
            return image!
        }
    }

    enum RecongitionLanguage: String, CaseIterable {
        case English = "🇺🇸 English"
        case French = "🇫🇷 French"
        case Italian = "🇮🇹 Italian"
        case German = "🇩🇪 German"

        func languageCode() -> String {
            switch self {
            case .English:
                return "en_US"
            case .French:
                return "fr"
            case .Italian:
                return "it"
            case .German:
                return "de"
            }
        }
    }

    @Published var needsOnboarding: Bool {
        didSet {
            Preferences.setValue(value: needsOnboarding, key: .NeedsOnboarding)
        }
    }

    @Published var captureSound: Bool {
        didSet {
            Preferences.setValue(value: captureSound, key: .CaptureSound)
        }
    }

    @Published var showMenuBarIcon: Bool {
        didSet {
            Preferences.setValue(value: showMenuBarIcon, key: .ShowMenuBarIcon)
        }
    }
    
    @Published var ignoreLineBreaks: Bool {
        didSet {
            Preferences.setValue(value: ignoreLineBreaks, key: .IgnoreLineBreaks)
        }
    }

    @Published var autoOpenCapturedURL: Bool {
        didSet {
            Preferences.setValue(value: autoOpenCapturedURL, key: .AutoOpenCapturedURL)
        }
    }

    @Published var autoOpenQRCodeURL: Bool {
        didSet {
            Preferences.setValue(value: autoOpenQRCodeURL, key: .AutoOpenQRCodeURL)
        }
    }

    @Published var autoOpenProvidedURL: String {
        didSet {
            Preferences.setValue(value: autoOpenProvidedURL, key: .AutoOpenProvidedURL)
        }
    }

    @Published var autoOpenProvidedURLAddNewLine: Bool {
        didSet {
            Preferences.setValue(value: autoOpenProvidedURLAddNewLine, key: .AutoOpenProvidedURLAddNewLine)
        }
    }


    @Published var recongitionLanguage: RecongitionLanguage {
        didSet {
            Preferences.setValue(value: recongitionLanguage.rawValue, key: .RecongitionLanguage)
        }
    }

    @Published var menuBarIcon: MenuBarIcon {
        didSet {
            Preferences.setValue(value: menuBarIcon.rawValue, key: .MenuBarIcon)
        }
    }

    init() {
        needsOnboarding = Preferences.getValue(key: .NeedsOnboarding) as? Bool ?? true
        captureSound = Preferences.getValue(key: .CaptureSound) as? Bool ?? true
        showMenuBarIcon = Preferences.getValue(key: .ShowMenuBarIcon) as? Bool ?? true
        ignoreLineBreaks = Preferences.getValue(key: .IgnoreLineBreaks) as? Bool ?? false
        autoOpenCapturedURL = Preferences.getValue(key: .AutoOpenCapturedURL) as? Bool ?? false
        autoOpenQRCodeURL = Preferences.getValue(key: .AutoOpenQRCodeURL) as? Bool ?? false
        autoOpenProvidedURL = Preferences.getValue(key: .AutoOpenProvidedURL) as? String ?? ""
        autoOpenProvidedURLAddNewLine = Preferences.getValue(key: .AutoOpenProvidedURLAddNewLine) as? Bool ?? true
        recongitionLanguage = .English
        if let lang = Preferences.getValue(key: .RecongitionLanguage) as? String {
            recongitionLanguage = RecongitionLanguage(rawValue: lang) ?? .English
        }
        menuBarIcon = .Option1
        if let mbitem = Preferences.getValue(key: .MenuBarIcon) as? String {
            menuBarIcon = MenuBarIcon(rawValue: mbitem) ?? .Option1
        }
    }

    static func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    private static func setValue(value: Any?, key: PreferencesKeys) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    private static func getValue(key: PreferencesKeys) -> Any? {
        UserDefaults.standard.value(forKey: key.rawValue)
    }
}
