# frozen_string_literal: true

module LocationsSeedData
  DISTRICTS = [
        {
          name: { ru: 'Весь Израиль', en: 'All Israel', uk: 'Весь Ізраїль',
                  he: 'כל ישראל' }
        },
        { name: { ru: 'Северный округ', en: 'Northern District', uk: 'Північний округ', he: 'מחוז הצפון‏' },
          cities: [
            { ru: 'Акко',            en: 'Acre',              uk: 'Акко',            he: 'עכו‏' },
            { ru: 'Афула',           en: 'Afula',             uk: 'Афула',           he: 'עפולה‏' },
            { ru: 'Бейт-Шеан',       en: "Beit She'an",       uk: 'Бейт-Шеан',       he: 'בית שאן‏' },
            { ru: 'Йокнеам',         en: 'Yokneam',           uk: 'Йокнам',          he: 'יקנעם‏' },
            { ru: 'Кармиэль',        en: 'Karmiel',           uk: 'Кармиэль',        he: 'כרמיאל‏' },
            { ru: 'Кирьят-Шмона',    en: 'Kiryat Shmona',     uk: 'Кирьят-Шмона',    he: 'קריית שמונה‏' },
            { ru: 'Маалот-Таршиха',  en: 'Maalot-Tarshiha',   uk: 'Маалот-Таршиха',  he: ' ‏מעלות-תרשיחא' },
            { ru: 'Мигдаль-ха-Эмек', en: 'Migdal ha-Emek',    uk: 'Мигдаль-ха-Эмек', he: 'מגדל העמק‏' },
            { ru: 'Нагария',         en: 'Nahariya',          uk: 'Нагария',         he: 'נהריה‏' },
            { ru: 'Назарет',         en: 'Nazareth',          uk: 'Назарет',         he: 'נצרת‏' },
            { ru: 'Ноф-ха-Галиль',   en: 'Nof ha Galil',      uk: 'Ноф-ха-Галиль',   he: 'נוף הגליל‏' },
            { ru: 'Сахнин',          en: 'Sakhnin',           uk: 'Сахнин',          he: "סח'נין‏" },
            { ru: 'Тамра',           en: 'Tamra',             uk: 'Тамра',           he: 'טמרה‏' },
            { ru: 'Тверия',          en: 'Tiberias',          uk: 'Тверия',          he: 'טבריה‏' },
            { ru: 'Цфат',            en: 'Safed',             uk: 'Цфат',            he: 'צפת‏' },
            { ru: 'Шефарам',         en: 'Shefaram',          uk: 'Шефарам',         he: 'שפרעם‏' }
          ] },
        {
          name: { ru: 'Хайфский округ', en: 'Haifa District', uk: 'Хайфський округ',
                  he: 'מחוז חיפה' },
          cities: [
            { ru: 'Бака-эль-Гарбия', en: 'Baqa al-Gharbiyah', uk: 'Бака-эль-Гарбия', he: 'באקה אל-גרבייה‏' },
            { ru: 'Кирьят-Ата',      en: 'Kiryat Ata',        uk: 'Кирьят-Ата',      he: 'קריית אתא‏' },
            { ru: 'Кирьят-Бялик',    en: 'Kiryat Bialik',     uk: 'Кирьят-Бялик',    he: 'קריית ביאליק‏' },
            { ru: 'Кирьят-Моцкин',   en: 'Kiryat-Motzkin',    uk: 'Кирьят-Моцкин',   he: 'קריית מוצקין‏' },
            { ru: 'Кирьят-Ям',       en: 'Kiryat-Yam',        uk: 'Кирьят-Ям',       he: 'קריית ים‏' },
            { ru: 'Нешер',           en: 'Nesher',            uk: 'Нешер',           he: 'נשר‏' },
            { ru: 'Ор-Акива',        en: 'Or-Akiva',          uk: 'Ор-Акива',        he: 'אור עקיבא‏' },
            { ru: 'Тират-Кармель',   en: 'Tirat-Carmel',      uk: 'Тират-Кармель',   he: 'טירת כרמל‏' },
            { ru: 'Умм-эль-Фахм',    en: 'Umm al-Fahm',       uk: 'Умм-эль-Фахм',    he: 'אום אל-פחם‏' },
            { ru: 'Хадера',          en: 'Hadera',            uk: 'Хадера',          he: 'חדרה‏' },
            { ru: 'Хайфа',           en: 'Haifa',             uk: 'Хайфа',           he: 'חיפה‏' }
          ]
        },
        {
          name: { ru: 'Тель-Авивский округ', en: 'Tel-Aviv District', uk: 'Тель-Авівський округ',
                  he: 'מחוז תל אביב‏‏' },
          cities: [
            { ru: 'Бат-Ям',          en: 'Bat Yam',           uk: 'Бат-Ям',          he: 'בת ים‏' },
            { ru: 'Бней-Брак',       en: 'Bnei Brak',         uk: 'Бней-Брак',       he: 'בני ברק‏' },
            { ru: 'Герцлия',         en: 'Herzliya',          uk: 'Герцлия',         he: 'הרצליה‏' },
            { ru: 'Гиватаим',        en: 'Givatayim',         uk: 'Гиватаим',        he: 'גבעתיים‏' },
            { ru: 'Кирьят-Оно',      en: 'Kiryat Ono',        uk: 'Кирьят-Оно',      he: 'קריית אונו‏' },
            { ru: 'Ор-Йехуда',       en: 'Or Yehuda',         uk: 'Ор-Йехуда',       he: 'אור יהודה‏' },
            { ru: 'Рамат-Ган',       en: 'Ramat Gan',         uk: 'Рамат-Ган',       he: 'רמת גן‏' },
            { ru: 'Рамат-ха-Шарон',  en: 'Ramat HaSharon',    uk: 'Рамат-ха-Шарон',  he: 'רמת השרון‏' },
            { ru: 'Тель-Авив',       en: 'Tel Aviv',          uk: 'Тель-Авив',       he: 'תל אביב‏' },
            { ru: 'Холон',           en: 'Holon',             uk: 'Холон',           he: 'חולון‏' }
          ]
        },
        {
          name: { ru: 'Центральный округ', en: 'Central District', uk: 'Центральний округ',
                  he: 'מחוז המרכז‏' },
          cities: [
            { ru: 'Гиват-Шмуэль',         en: 'Givat-Shmuel',           uk: 'Гиват-Шмуэль', he: 'גבעת שמואל‏' },
            { ru: 'Йехуд-Моноссон',       en: 'Yehud-Monosson',         uk: 'Йехуд-Моноссон',
              he: 'יהוד-מונוסון‏' },
            { ru: 'Калансуа',             en: 'Kalansua',               uk: 'Калансуа',             he: 'קלנסווה‏' },
            { ru: 'Кафр-Касем',           en: 'Kafr Kasem',             uk: 'Кафр-Касем',           he: 'כפר קאסם‏' },
            { ru: 'Кфар-Сава',            en: 'Kfar Saba',              uk: 'Кфар-Сава',            he: 'כפר סבא‏' },
            { ru: 'Лод',                  en: 'Lod',                    uk: 'Лод',                  he: 'לוד‏' },
            { ru: 'Модиин-Маккабим-Реут', en: "Modi'in-Maccabim-Re'ut", uk: 'Модиин-Маккабим-Реут',
              he: 'מודיעין-מכבים-רעות‏' },
            { ru: 'Нес-Циона',            en: 'Neszion',                uk: 'Нес-Циона',            he: 'נס ציונה‏' },
            { ru: 'Нетания',              en: 'Netanya',                uk: 'Нетания',              he: 'נתניה‏' },
            { ru: 'Петах-Тиква',          en: 'Petah Tikva',            uk: 'Петах-Тиква',          he: 'פתח תקווה‏' },
            { ru: 'Раанана',              en: "Ra'anana",               uk: 'Раанана',              he: 'רעננה‏' },
            { ru: 'Рамла',                en: 'Ramla',                  uk: 'Рамла',                he: 'רמלה‏' },
            { ru: 'Реховот',              en: 'Rehovot',                uk: 'Реховот',              he: 'רחובות‏' },
            { ru: 'Ришон-ле-Цион',        en: 'Rishon Lezion',          uk: 'Ришон-ле-Цион',
              he: 'ראשון לציון‏' },
            { ru: 'Рош-ха-Аин',           en: 'Rosh HaAyin',            uk: 'Рош-ха-Аин',           he: 'ראש העין‏' },
            { ru: 'Тайбе',                en: 'Tayibe',                 uk: 'Тайбе',                he: 'טייבה‏' },
            { ru: 'Тира',                 en: 'Tyre',                   uk: 'Тира',                 he: 'טירה‏' },
            { ru: 'Ход-ха-Шарон',         en: 'Hod-ha-Sharon',          uk: 'Ход-ха-Шарон',         he: 'הוד השרון‏' },
            { ru: 'Эльад',                en: 'Elad',                   uk: 'Эльад',                he: 'אלעד‏' },
            { ru: 'Явне',                 en: 'Yavne',                  uk: 'Явне',                 he: 'יבנה‏' }
          ]
        },
        {
          name: { ru: 'Иерусалимский округ', en: 'Jerusalem District', uk: 'Єрусалимський округ',
                  he: 'מחוז ירושלים‏‏' },
          cities: [
            { ru: 'Бейт-Шемеш',           en: 'Beit Shemesh',           uk: 'Бейт-Шемеш',           he: 'בית שמש‏' },
            { ru: 'Иерусалим',            en: 'Jerusalem',              uk: 'Иерусалим',            he: 'ירושלים‏' }
          ]
        },
        {
          name: { ru: 'Южный округ', en: 'Southern District', uk: 'Південний округ',
                  he: 'מחוז הדרום' },
          cities: [
            { ru: 'Арад',                 en: 'Arad',                   uk: 'Арад',                 he: 'ערד‏' },
            { ru: 'Ашдод',                en: 'Ashdod',                 uk: 'Ашдод',                he: 'אשדוד‏' },
            { ru: 'Ашкелон',              en: 'Ashkelon',               uk: 'Ашкелон',              he: 'אשקלון‏' },
            { ru: 'Беэр-Шева',            en: 'Beer-Sheva',             uk: 'Беэр-Шева',            he: 'באר שבע‏' },
            { ru: 'Димона',               en: 'Dimona',                 uk: 'Димона',               he: 'דימונה‏' },
            { ru: 'Кирьят-Гат',           en: 'Kiryat Gat',             uk: 'Кирьят-Гат',           he: "קריית גת\t‏" },
            { ru: 'Кирьят-Малахи',        en: 'Kiryat Malakhi',         uk: 'Кирьят-Малахи',
              he: 'קריית מלאכי‏' },
            { ru: 'Нетивот',              en: 'Netivot',                uk: 'Нетивот',              he: 'נתיבות‏' },
            { ru: 'Офаким',               en: 'Ofakim',                 uk: 'Офаким',               he: 'אופקים‏' },
            { ru: 'Рахат',                en: 'Rahat',                  uk: 'Рахат',                he: 'רהט‏' },
            { ru: 'Сдерот',               en: 'Sderot',                 uk: 'Сдерот',               he: 'שדרות‏' },
            { ru: 'Эйлат',                en: 'Eilat',                  uk: 'Эйлат',                he: 'אילת‏' }
          ]
        },
        {
          name: { ru: 'Округ Иудея и Самария', en: 'Judea and Samaria District', uk: 'Округ Юдея і Самарія',
                  he: 'מחוז יהודה ושומרון' },
          cities: [
            { ru: 'Ариэль',               en: 'Ariel',                  uk: 'Ариэль',               he: 'אריאל‏' },
            { ru: 'Бейтар-Илит',          en: 'Beitar Ilit',            uk: 'Бейтар-Илит',          he: 'ביתר עילית‏' },
            { ru: 'Маале-Адумим',         en: "Ma'ale Adumim",          uk: 'Маале-Адумим',
              he: 'מעלה אדומים‏' },
            { ru: 'Модиин-Илит',          en: "Modi'in Ilit",           uk: 'Модиин-Илит',
              he: 'מודיעין עילית‏' }
          ]
        }
      ].freeze

  # Source: Israel CBS 2023 locality file, Israel Government Data Portal dataset
  # d9b1e04c-426f-4e32-ba40-a1ad9d8748a7.
  CBS_DISTRICTS = {
    'הצפון' => 'Northern District',
    'חיפה' => 'Haifa District',
    'תל אביב' => 'Tel-Aviv District',
    'המרכז' => 'Central District',
    'ירושלים' => 'Jerusalem District',
    'הדרום' => 'Southern District',
    'אזור יהודה ושומרון' => 'Judea and Samaria District'
  }.freeze

  CBS_LOCALITY_ALIASES = {
    'יקנעם עילית' => 'יקנעם',
    'נהרייה' => 'נהריה',
    'באקה אל-גרביה' => 'באקה אל-גרבייה',
    'הרצלייה' => 'הרצליה',
    'תל אביב -יפו' => 'תל אביב'
  }.freeze

  # CBS forms for urban localities, moshavim, and kibbutzim.
  CBS_LOCALITY_FORM_CODES = %w[
    120 130 140 150 160 170 180 190 250 260 270 280 290 310 330
  ].freeze

  CYRILLIC_TRANSLITERATION = {
    'sh' => 'ш', 'ts' => 'ц', 'tz' => 'ц', 'kh' => 'х', 'ch' => 'ч', 'zh' => 'ж',
    'th' => 'т', 'ai' => 'ай', 'ay' => 'ай', 'ei' => 'ей', 'oi' => 'ой',
    'a' => 'а', 'b' => 'б', 'c' => 'к', 'd' => 'д', 'e' => 'е', 'f' => 'ф',
    'g' => 'г', 'h' => 'х', 'i' => 'и', 'j' => 'дж', 'k' => 'к', 'l' => 'л',
    'm' => 'м', 'n' => 'н', 'o' => 'о', 'p' => 'п', 'q' => 'к', 'r' => 'р',
    's' => 'с', 't' => 'т', 'u' => 'у', 'v' => 'в', 'w' => 'в', 'x' => 'кс',
    'y' => 'й', 'z' => 'з'
  }.freeze
  CYRILLIC_TRANSLITERATION_PATTERN = Regexp.union(
    CYRILLIC_TRANSLITERATION.keys.sort_by { |key| -key.length }
  )

  def self.load_official_localities
    localized_names = DISTRICTS.to_h do |district|
      [district[:name][:en], district.fetch(:cities, []).to_h { |city| [normalize_name(city[:he]), city] }]
    end

    File.foreach(File.join(__dir__, 'israel_localities.tsv')).with_index do |line, index|
      add_official_locality(line, localized_names) unless index.zero?
    end
  end

  def self.add_official_locality(line, localized_names)
    district_code, hebrew_name, english_name, transliteration, form_code = parse_tsv_line(line)
    return unless CBS_LOCALITY_FORM_CODES.include?(form_code)

    district_name = CBS_DISTRICTS.fetch(district_code)
    district = DISTRICTS.find { |item| item[:name][:en] == district_name }
    return unless district

    names = localized_names.fetch(district_name)
    add_locality_name(district, names, hebrew_name, english_name, transliteration)
  end

  def self.add_locality_name(district, names, hebrew_name, english_name, transliteration)
    normalized_name = normalize_name(hebrew_name)
    existing_city = names[normalized_name] || names[normalize_name(CBS_LOCALITY_ALIASES[hebrew_name])]
    return update_existing_locality(existing_city, names, normalized_name, hebrew_name) if existing_city

    append_locality(district, names, hebrew_name, english_name, transliteration)
  end

  def self.update_existing_locality(city, names, normalized_name, hebrew_name)
    city[:he] = hebrew_name
    names[normalized_name] = city
  end

  def self.append_locality(district, names, hebrew_name, english_name, transliteration)
    normalized_name = normalize_name(hebrew_name)
    city = build_locality(hebrew_name, english_name, transliteration)
    district[:cities] ||= []
    district[:cities] << city
    names[normalized_name] = city
  end

  def self.build_locality(hebrew_name, english_name, transliteration)
    english_name = [english_name, transliteration].find { |name| !name.to_s.empty? }
    raise "Missing English locality name for #{hebrew_name}" unless english_name

    cyrillic_name = transliterate_locality_name(english_name)
    { ru: cyrillic_name, en: english_name, uk: cyrillic_name, he: hebrew_name }
  end

  def self.parse_tsv_line(line)
    line.chomp.split("\t", -1).map do |field|
      next field unless field.start_with?('"') && field.end_with?('"')

      field[1...-1].gsub('""', '"')
    end
  end

  def self.transliterate_locality_name(name)
    name.split(/([ -]+)/).map { |part| transliterate_locality_part(part) }.join
  end

  def self.transliterate_locality_part(part)
    return part if part.match?(/\A[ -]+\z/)

    word = part.downcase.delete("'’")
    word = word.sub(/\Aya/, 'я').sub(/\Aye/, 'е').sub(/\Ayo/, 'йо').sub(/\Ayu/, 'ю')
    word.gsub(CYRILLIC_TRANSLITERATION_PATTERN) { |latin| CYRILLIC_TRANSLITERATION.fetch(latin) }.capitalize
  end

  def self.normalize_name(name)
    name.to_s.gsub(/[\u200E-\u200F\u202A-\u202E\u2066-\u2069]/, '').strip.downcase
  end

  load_official_localities
end
