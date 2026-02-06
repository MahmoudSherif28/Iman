/// إزالة الرموز الصغيرة من نص القرآن العثماني (النقاط السوداء، الدال الصغيرة، إلخ)
/// التي تظهر داخل الكلمات وليست جزءاً من رسم المصحف للقراءة.
String stripUthmaniDisplaySymbols(String text) {
  if (text.isEmpty) return text;
  // رموز عربية صغيرة فوق/تحت السطر (دوائر، دال صغيرة، ميم صغيرة، إلخ)
  // Unicode: Arabic small high/low marks, presentation forms
  const pattern = '[\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06EF\u0616-\u061A]';
  return text.replaceAll(RegExp(pattern), '');
}
