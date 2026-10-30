# Google Play — بيانات صفحة التطبيق

## ملفات الصور (في نفس المجلد)
| الخانة في Play Console | الملف | المقاس |
|---|---|---|
| App icon | `icon_512.png` | 512×512 |
| Feature graphic | `feature_graphic_1024x500.png` | 1024×500 |
| Phone screenshots | `screenshots/01_home.png` … `05_after_prayer.png` (بالترتيب) | 1080×1920 |

ملف التطبيق: `build/app/outputs/bundle/release/app-release.aab`

---

## العربية (ar) — اللغة الافتراضية

**اسم التطبيق** (30 حرف كحد أقصى)
```
إيمان - قرآن ومواقيت وأذكار
```

**الوصف المختصر** (80 حرف كحد أقصى)
```
المصحف بسطور المصحف الورقي، مواقيت الصلاة والأذان، الأذكار واتجاه القبلة
```

**الوصف الكامل**
```
إيمان رفيقك اليومي في العبادة، يجمع لك كل ما تحتاجه في تطبيق واحد خفيف وبدون إعلانات.

📖 المصحف الشريف
• المصحف كاملاً ٦٠٤ صفحة بنفس سطور وترتيب مصحف المدينة الورقي (١٥ سطراً في كل صفحة)
• بخط مجمع الملك فهد لطباعة المصحف الشريف (رواية حفص عن عاصم)
• يعمل بدون إنترنت
• حفظ آخر صفحة قرأتها تلقائياً، وإضافة علامات على الصفحات
• فهرس السور والانتقال السريع لأي صفحة أو جزء
• الوضع الليلي للقراءة المريحة
• تفسير الآيات من عدة كتب تفسير
• مخطط الختمة ودعاء ختم القرآن

🎙️ تسميع القرآن
• اختبر حفظك: الآيات مخفية وتظهر آية بآية مع كل ضغطة

🎧 سماع القرآن
• تلاوات لعدد كبير من القراء
• التشغيل في الخلفية والتحكم من الإشعارات
• تحميل السور للاستماع بدون إنترنت

🕌 مواقيت الصلاة والأذان
• مواقيت دقيقة حسب موقعك (طريقة الهيئة المصرية العامة للمساحة)
• تنبيه بالأذان عند دخول وقت كل صلاة
• التاريخ الهجري

🧭 اتجاه القبلة
• بوصلة تحدد اتجاه القبلة من مكانك

📿 الأذكار والأدعية
• أذكار الصباح والمساء، أذكار بعد الصلاة، أذكار النوم، أذكار عامة وأدعية مأثورة
• عدّاد لكل ذكر
• أضف أذكارك الخاصة

🔒 الخصوصية
• بدون إعلانات وبدون تتبع
• الموقع يُستخدم فقط لحساب مواقيت الصلاة واتجاه القبلة

نسأل الله أن يجعله في ميزان حسناتنا وحسناتكم.
```

**ملاحظات الإصدار (What's new)**
```
• المصحف أصبح بنفس سطور المصحف الورقي (١٥ سطراً لكل صفحة)
• إصلاح ترتيب أرقام الآيات
• إضافة أذكار جديدة بعد الصلاة
• تحسين تنبيهات الأذان
```

---

## English (en-US)

**App name**
```
Iman - Quran, Prayer & Azkar
```

**Short description**
```
Quran with mushaf page layout, prayer times & adhan, azkar and Qibla compass
```

**Full description**
```
Iman is your daily worship companion — everything you need in one light, ad-free app.

📖 The Holy Quran
• Full 604-page Mushaf with the exact line layout of the printed Madani Mushaf (15 lines per page)
• King Fahd Complex Uthmani script (Hafs narration)
• Works offline
• Auto-saves your last page, plus bookmarks
• Surah index and quick jump to any page or juz
• Night mode
• Verse tafsir from several books
• Khatma planner and Khatm du'a

🎙️ Memorization test (Tasmee')
• Verses are hidden and revealed one by one as you recite

🎧 Quran audio
• Recitations from many reciters
• Background playback with notification controls
• Download surahs for offline listening

🕌 Prayer times & Adhan
• Accurate times for your location (Egyptian General Authority of Survey method)
• Adhan alert at each prayer time
• Hijri date

🧭 Qibla compass

📿 Azkar & Du'a
• Morning, evening, after-prayer and bedtime azkar, plus general azkar and du'as
• Counter for each dhikr
• Add your own azkar

🔒 Privacy
• No ads, no tracking
• Location is used only to calculate prayer times and the Qibla direction
```

**Release notes**
```
• Mushaf now matches the printed Mushaf line by line (15 lines per page)
• Fixed verse number ordering
• Added more after-prayer azkar
• Improved adhan notifications
```

---

## إعدادات Play Console

**Store settings**
- App category: **Books & Reference** (أو Lifestyle)
- Tags: Quran, Prayer times, Islam
- Contact email: (إيميلك)

**App content**
- **Privacy policy:** لازم لينك عام — ارفع `privacy-policy.html` على GitHub Pages أو Google Sites وحط اللينك
- **Ads:** No, my app does not contain ads
- **App access:** All functionality is available without special access
- **Content rating (IARC questionnaire):** Category = Reference, News, or Educational → أجب No على كل الأسئلة (عنف، جنس، مخدرات، قمار، محتوى من المستخدمين مشارَك، شراء…) → النتيجة المتوقعة: Everyone / 3+
- **Target audience:** 13+ (اختار 13-15, 16-17, 18+ — تجنّب الفئات تحت 13 عشان متدخلش في سياسة Families)
- **News app:** No
- **Health apps:** No
- **Government app:** No
- **Financial features:** None

**Data safety**
- Does your app collect or share any of the required user data types? **Yes**
- Is all data encrypted in transit? **Yes** (HTTPS)
- Can users request data deletion? **No data is stored by the developer** — اختار الخيار المناسب أو اكتب إن مفيش بيانات بتتخزن على سيرفرات خاصة بالتطبيق
- Data types:
  - **Location → Approximate location + Precise location**
    - Collected: **Yes** · Shared: **No** (بيتبعت لـ api.aladhan.com كمقدّم خدمة لحساب المواقيت)
    - Processed ephemerally: **Yes**
    - Required or optional: **Optional** (المستخدم يقدر يرفض)
    - Purpose: **App functionality**
- كل حاجة تانية (الاسم، الإيميل، الصور، الملفات، الأجهزة…): **لا**

**Permissions declarations** (هتظهر وقت الرفع)
- **Exact alarms (SCHEDULE_EXACT_ALARM):** اختار إن التطبيق بيستخدمه لتنبيهات الأذان في مواعيد الصلاة بالظبط
- **Foreground service – media playback:** تشغيل تلاوات القرآن في الخلفية (ممكن يطلب فيديو قصير يوضح التشغيل في الخلفية مع الإشعار)

**تنبيه:** لو الحساب شخصي ومعمول بعد نوفمبر 2023، لازم **Closed testing بـ 12 مختبر لمدة 14 يوم** قبل ما تقدر تطلب Production.
