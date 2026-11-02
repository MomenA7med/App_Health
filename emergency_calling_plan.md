# دليل وخطة تنفيذ ميزة مكالمات الطوارئ (Emergency Calling Plan)
**الحل المعتمد:** Flutter + ZegoCloud (`zego_uikit_prebuilt_call` & `zego_zpns`)

---

## 1. ملخص المعمارية (Architecture Overview)

* **تطبيق المريض (Patient App):**
  * عرض قائمة أطباء الطوارئ المتاحين لحظياً (`is_online` و `is_available`).
  * زر اتصال صوتي (Audio) وفيديو (Video) في بطاقة كل دكتور.
  * بدء الدعوة للاتصال عبر `ZegoUIKitPrebuiltCallInvitationService`.

* **تطبيق الدكتور (Doctor App):**
  * الاستماع الدائم للمكالمات الواردة حتى لو كان التطبيق مغلقاً أو الشاشة مقفلة.
  * رنين بشاشة كاملة: **Apple CallKit** على iOS و **Full-Screen Intent / Foreground Service** على Android.
  * أزرار قبول (Accept) أو رفض (Decline).

---

## 2. دور فريق الباك إند (Backend Team Tasks)

1. **إدارة حالة وتواجد الأطباء (Presence & Status):**
   * جدول قاعدة بيانات لحالة الطبيب: `status: [online, in_call, offline]`.
   * Endpoint لجلب أطباء الطوارئ المتاحين: `GET /api/emergency/doctors`.
   * Endpoint لتحديث حالة الطبيب: `POST /api/doctor/availability`.

2. **توليد الـ Server Token (للإنتاج - Production Security):**
   * Endpoint لتوليد `Zego Token` مشفر عند تسجيل الدخول أو عند طلب المكالمة لضمان عدم تسريب الـ `AppSign` في التطبيق.

3. **توثيق المكالمات واستقبال Webhooks:**
   * استقبال تقارير Zego Webhooks عند:
     * بدء المكالمة وانتهائها وحساب مدتها الفعلية.
     * إغلاق المكالمة وتفريغ الطبيب ليعود لحالة `Available`.
     * تفويت المكالمة (Missed Call) لتحويل المريض لطبيب طوارئ بديل.

---

## 3. التعامل مع إشعارات الرنين و Firebase (Push & Ringing)

* **ملف `google-services.json`:**
  * ملف واحد فقط في مسار `android/app/google-services.json` يخدم كلاً من `firebase_messaging` وخدمة اتصالات `ZegoCloud`.
  * لا يوجد أي تعارض؛ Zego تستخدم نفس مشروع Firebase لإرسال إشارة الاتصال، و`firebase_messaging` يتعامل مع الإشعارات الإخبارية العادية.
* **إعدادات Firebase Console:**
  * استخراج مفتاح الخدمة (Firebase Service Account Key) بصيغة JSON ورفعه في لوحة تحكم Zego Console.
* **إعدادات Apple Developer:**
  * إنشاء شهادة VoIP Push Certificate (`.p12` أو `.p8`) ورفعها في لوحة Zego لتفعيل رنين CallKit على أجهزة iPhone.

---

## 4. قائمة فحص التنفيذ في Flutter (Implementation Checklist)

### أ. في كود Flutter:
- [ ] إضافة مكتبات `zego_uikit_prebuilt_call` و `zego_zpns`.
- [ ] تهيئة `ZegoUIKitPrebuiltCallInvitationService.init()` عند إتمام تسجيل الدخول مع تمرير `userID` و `userName`.
- [ ] إلغاء التهيئة `ZegoUIKitPrebuiltCallInvitationService.uninit()` عند تسجيل الخروج (Logout).
- [ ] وضع `ZegoSendCallInvitationButton` في شاشة الطوارئ لكل طبيب.

### ب. في إعدادات المنصات الأصلية (Native Settings):
- [ ] **Android (`AndroidManifest.xml`):**
  * إضافة أذونات: `USE_FULL_SCREEN_INTENT`, `CAMERA`, `RECORD_AUDIO`, `FOREGROUND_SERVICE`.
  * ضبط الـ `launchMode="singleTop"` للـ `MainActivity`.
- [ ] **Android (`proguard-rules.pro`):**
  * إضافة استثناءات Zego لمنع أخطاء الـ Release Build.
- [ ] **iOS (`Info.plist` & Xcode):**
  * تفعيل Background Modes: `Voice over IP`, `Audio, AirPlay, and Picture in Picture`, `Remote notifications`.
  * إضافة أذونات `NSCameraUsageDescription` و `NSMicrophoneUsageDescription`.

---

> تم حفظ هذه الخطة كمرجع دائم للرجوع إليها فور البدء في بناء الميزة.
