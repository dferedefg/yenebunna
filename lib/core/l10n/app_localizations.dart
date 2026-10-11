enum AppLanguage {
  en,
  am;

  String get code => this == AppLanguage.am ? 'am' : 'en';
  String get badgeLabel => this == AppLanguage.am ? 'አማርኛ' : 'EN';
  String get fullName =>
      this == AppLanguage.am ? 'አማርኛ (Amharic)' : 'English (EN)';
}

class AppStrings {
  AppStrings._();

  static const Map<String, Map<String, String>> _dict = {
    'en': {
      'nav_terroir': 'Terroir',
      'nav_roasters': 'Roasters',
      'nav_orders': 'Orders',
      'nav_bag': 'Bag',
      'nav_account': 'Account',
      'hero_greeting_user': 'Selam',
      'hero_greeting_guest': 'Guest Explorer · እንኳን ደህና መጡ',
      'hero_title': 'Freshly Roasted in Addis Ababa',
      'jebena_timer': 'Jebena Timer',
      'search_hint': 'Search coffee type, brand, roast, or flavor note...',
      'compare_lots': 'Compare',
      'ecx_qr': 'ECX Lot QR',
      'roasters_title': 'Addis Ababa Artisan Roasteries',
      'roasters_subtitle':
          'Live cast-iron drum telemetry & same-day motorbike dispatch across Addis',
      'book_cupping': 'Book Cupping',
      'orders_title': 'Live Roast & Addis Courier Tracking',
      'past_orders_title': 'Past Completed Roasts (Quick 1-Tap Reorder)',
      'verify_lot': 'Verify Lot',
      'vat_invoice': 'VAT Invoice',
      'reorder': 'Reorder',
      'cart_tab': 'Roast Bag & Checkout',
      'favorites_tab': 'Saved Favorites',
      'checkout_btn': 'Verify Payment & Start Drum Roasting',
      'sync_cloud': 'Hydrate from Back4App Cloud (GET)',
      'lang_switch': 'Language: English (Switch to አማርኛ)',
    },
    'am': {
      'nav_terroir': 'የቡና መገኛ',
      'nav_roasters': 'መቁያዎች',
      'nav_orders': 'ትዕዛዞች',
      'nav_bag': 'ቅርጫት',
      'nav_account': 'መግለጫ',
      'hero_greeting_user': 'ሰላም',
      'hero_greeting_guest': 'እንኳን ደህና መጡ · የቡና ጎብኚ',
      'hero_title': 'በአዲስ አበባ ትኩስ የተቆላ ልዩ ቡና',
      'jebena_timer': 'የጀበና ሰዓት',
      'search_hint': 'የቡና ዓይነት፣ ብራንድ ወይም ጣዕም ይፈልጉ...',
      'compare_lots': 'አወዳድር',
      'ecx_qr': 'ECX ሎት ማረጋገጫ',
      'roasters_title': 'የአዲስ አበባ ልዩ የቡና መቁያዎች',
      'roasters_subtitle': 'የቀጥታ የቡና መቁያ ክትትል እና የሞተር ብስክሌት ፈጣን ማድረሻ',
      'book_cupping': 'የቡና ቅምሻ ቀጠሮ',
      'orders_title': 'የቀጥታ ቆሎ እና የአዲስ አበባ ማድረሻ ክትትል',
      'past_orders_title': 'ያለፉ ትዕዛዞች (በአንድ ንክኪ እንደገና ይዘዙ)',
      'verify_lot': 'ሎት አረጋግጥ',
      'vat_invoice': 'ደረሰኝ (VAT)',
      'reorder': 'ድጋሚ እዘዝ',
      'cart_tab': 'የቡና ቅርጫት እና ክፍያ',
      'favorites_tab': 'የተመረጡ ቡናዎች',
      'checkout_btn': 'ክፍያ አረጋግጥ እና ቆሎ ጀምር',
      'sync_cloud': 'ከBack4App ክላውድ አመሳስል (GET)',
      'lang_switch': 'ቋንቋ፦ አማርኛ (Switch to English)',
    },
  };

  static String of(AppLanguage lang, String key) {
    return _dict[lang.code]?[key] ?? _dict['en']![key] ?? key;
  }
}
