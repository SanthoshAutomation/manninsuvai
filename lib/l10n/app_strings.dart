/// All UI strings in English and Tamil.
/// Access via context.read<LocaleProvider>().s('key')
class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    // ── Bottom Nav ──────────────────────────────────────────────────────────
    'nav_home':     {'en': 'Home',     'ta': 'முகப்பு'},
    'nav_products': {'en': 'Products', 'ta': 'பொருட்கள்'},
    'nav_cart':     {'en': 'Cart',     'ta': 'கூடை'},
    'nav_about':    {'en': 'About',    'ta': 'பற்றி'},

    // ── Home Screen ─────────────────────────────────────────────────────────
    'home_tagline':       {'en': 'From our soil to your soul', 'ta': 'மண்ணின் சுவை உங்கள் உள்ளம் வரை'},
    'home_featured':      {'en': 'Most Loved Products',        'ta': 'அதிகம் விரும்பப்படும் பொருட்கள்'},
    'home_categories':    {'en': 'Shop by Category',           'ta': 'வகையை தேர்ந்தெடுங்கள்'},
    'home_why_us':        {'en': 'Why Choose Us',              'ta': 'ஏன் எங்களை தேர்வு செய்யலாம்'},
    'home_view_all':      {'en': 'View All',                   'ta': 'அனைத்தும் காண்க'},
    'home_contact':       {'en': 'Order via WhatsApp',         'ta': 'வாட்ஸ்அப் மூலம் ஆர்டர் செய்யுங்கள்'},

    // ── Product Screen ───────────────────────────────────────────────────────
    'products_title':     {'en': 'Our Products',  'ta': 'எங்கள் பொருட்கள்'},
    'products_search':    {'en': 'Search...',     'ta': 'தேடுக...'},
    'products_all':       {'en': 'All',           'ta': 'அனைத்தும்'},
    'products_in_stock':  {'en': 'In Stock',      'ta': 'கையிருப்பில் உள்ளது'},
    'products_out_stock': {'en': 'Out of Stock',  'ta': 'கையிருப்பில் இல்லை'},

    // ── Product Card / Detail ────────────────────────────────────────────────
    'add_to_cart':      {'en': 'Add to Cart',       'ta': 'கூடையில் சேர்'},
    'added_to_cart':    {'en': 'Added to cart!',    'ta': 'கூடையில் சேர்க்கப்பட்டது!'},
    'out_of_stock':     {'en': 'OUT OF STOCK',       'ta': 'கையிருப்பு இல்லை'},
    'pre_book':         {'en': 'Pre-book',           'ta': 'முன்பதிவு'},
    'from_price':       {'en': 'From',               'ta': 'தொடக்கம்'},
    'contact_us':       {'en': 'Contact Us',         'ta': 'தொடர்பு கொள்ளுங்கள்'},

    // ── Cart Screen ──────────────────────────────────────────────────────────
    'cart_title':       {'en': 'My Cart',            'ta': 'என் கூடை'},
    'cart_empty':       {'en': 'Your cart is empty', 'ta': 'உங்கள் கூடை காலியாக உள்ளது'},
    'cart_order_wa':    {'en': 'Order via WhatsApp', 'ta': 'வாட்ஸ்அப் மூலம் ஆர்டர்'},
    'cart_subtotal':    {'en': 'Subtotal',           'ta': 'மொத்தம்'},
    'cart_delivery':    {'en': 'Delivery',           'ta': 'டெலிவரி'},
    'cart_total':       {'en': 'Total',              'ta': 'மொத்த தொகை'},
    'cart_free_del':    {'en': 'Free Delivery',      'ta': 'இலவச டெலிவரி'},
    'cart_contact_del': {'en': 'Contact for charges','ta': 'கட்டணம் தொடர்பு செய்யவும்'},
    'cart_clear':       {'en': 'Clear',              'ta': 'அழி'},
    'cart_order_summary':{'en': 'Order Summary',     'ta': 'ஆர்டர் சுருக்கம்'},

    // ── About ────────────────────────────────────────────────────────────────
    'about_title':      {'en': 'About Us',           'ta': 'எங்களை பற்றி'},
    'about_our_story':  {'en': 'Our Story',          'ta': 'எங்கள் கதை'},
    'about_contact':    {'en': 'Contact Us',         'ta': 'தொடர்பு கொள்ளுங்கள்'},
    'about_brands':     {'en': 'Our Brands',         'ta': 'எங்கள் பிராண்டுகள்'},
    'about_follow':     {'en': 'Follow Us',          'ta': 'எங்களை பின்தொடரவும்'},

    // ── Category Names ───────────────────────────────────────────────────────
    'cat_health_mix':   {'en': 'Health Mixes',       'ta': 'ஆரோக்கிய கலவைகள்'},
    'cat_tea':          {'en': 'Tea & Beverages',    'ta': 'தேநீர் & பானங்கள்'},
    'cat_beauty':       {'en': 'Natural Beauty',     'ta': 'இயற்கை அழகு'},
    'cat_gifts':        {'en': 'Gift Combos',        'ta': 'பரிசு தொகுப்புகள்'},
    'cat_prebook':      {'en': 'Pre-Booking',        'ta': 'முன்பதிவு'},

    // ── Quality Features ─────────────────────────────────────────────────────
    'feat_natural':     {'en': 'All Natural',        'ta': 'முழு இயற்கை'},
    'feat_homemade':    {'en': 'Homemade',            'ta': 'வீட்டில் தயாரிக்கப்பட்டது'},
    'feat_fssai':       {'en': 'FSSAI Certified',    'ta': 'FSSAI சான்றிதழ் பெற்றது'},
    'feat_delivery':    {'en': 'Fast Delivery',      'ta': 'விரைவான டெலிவரி'},

    // ── Install Prompt ───────────────────────────────────────────────────────
    'install_prompt':   {'en': 'Install App',        'ta': 'ஆப் நிறுவுக'},
    'install_tip':      {'en': 'Install this app for a better experience',
                         'ta': 'சிறந்த அனுபவத்திற்கு இந்த ஆப்பை நிறுவுங்கள்'},
  };

  static String get(String key, String locale) {
    return _strings[key]?[locale] ?? _strings[key]?['en'] ?? key;
  }
}
