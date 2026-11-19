# دليل وخطة تنفيذ فلو مكالمات الطوارئ (Emergency Calling Flow Specification)

وثيقة شاملة توضح معمارية النظام، آلية تسجيل الطبيب واستقبال الرنين في كافة الحالات، متطلبات الباك إند (APIs)، إعدادات ZegoCloud، وتفاصيل كل شاشات الفلو والـ Edge Cases بناءً على التصميم المعتمد.

---

## 1. المعمارية وتكامل النظام (System Architecture)

يعتمد النظام على **تطبيقين منفصلين** (تطبيق المريض وتطبيق الطبيب) مع خادم الباك إند ومنصة **ZegoCloud**:

```
[تطبيق المريض (Patient App)]
         │
         │  (1) POST /api/emergency/calls/initiate
         ▼
[الباك إند (Backend Server)] ────(2) إشعار اتصال فوري (VoIP Push / CallKit)────► [تطبيق الطبيب (Doctor App)]
         │                                                                             │
         │◄───────────────── (3) قبول الاتصال أو الرفض ─────────────────────────────────┘
         │
         ├─── (4) تحديث الحالة لحظياً (SignalR / WebSocket)
         ▼
[انضمام الطرفين لنفس الغرفة RoomID عبر ZegoCloud وتوليد Zego Token]
         │
         ▼
   ┌─────────────────────────────────────────┐
   │         مكالمة الفيديو (ZegoCloud)       │
   │  فيديو الطبيب كامل + كاميرا المريض PIP   │
   └─────────────────────────────────────────┘
         │
         ▼
   (5) إنهاء المكالمة ◄───► تحديث الحالة في الباك إند ◄───► شاشة الملخص والتقييم
```

---

## 2. آلية تسجيل الطبيب واستقبال الرنين (Doctor Registration & Ringing Mechanism)

لكي يرن هاتف الطبيب فوراً حتى لو كان **التطبيق في الخلفية أو الشاشة مقفلة أو التطبيق مقفولاً بالكامل (Killed)**، هذه هي الآلية التقنية المعتمدة:

### أ. ماذا يسجل الطبيب عند تسجيل الدخول (Login)؟
عند إتمام تسجيل دخول الطبيب بنجاح، يتم تنفيذ خطوتين تلقائياً في الخلفية:

1. **تسجيل معرف الطبيب في Zego (Zego UserID):**
   * يتم ربط هوية الطبيب في Zego بنفس الـ `ID` أو `UUID` المسجل في قاعدة البيانات:
   ```dart
   ZegoUIKitPrebuiltCallInvitationService().init(
     appID: yourAppID,
     appSign: yourAppSign,
     userID: doctor.id, // معرف الطبيب الثابت
     userName: doctor.name,
     plugins: [ZegoUIKitSignalingPlugin()],
   );
   ```

2. **تسجيل توكن الجهاز للإشعارات الفورية (Device Push Token):**
   * يطلب التطبيق الـ Push Token الخاص بهاتف الطبيب:
     * على **Android**: يُطلب `FCM Token` عبر Firebase Cloud Messaging.
     * على **iOS**: يُطلب `VoIP APNs Token` الخاص بالمكالمات عبر Apple Push Notification service.
   * يتم إرسال هذا التوكن لخدمة Zego ZPNs وللباك إند عبر API لحفظه في جدول أجهزة الطبيب:
   ```json
   POST /api/doctor/device-token
   {
     "doctorId": "doc_9876",
     "deviceToken": "fcm_or_apns_token_xyz...",
     "platform": "android" // أو "ios"
   }
   ```

---

### ب. كيف يرن هاتف الطبيب حسب حالة جهازه؟

| حالة تطبيق الطبيب | آلية وصول الاتصال | ما يظهر على شاشة هاتف الطبيب |
| :--- | :--- | :--- |
| **1. التطبيق مفتوح وشغال (Foreground)** | اتصال لحظي مباشر عبر سيرفر Zego WebSockets. | نافذة اتصال واردة داخل التطبيق (In-App Incoming Call Dialog) مع زرين: قبول ورفض. |
| **2. التطبيق في الخلفية (Background) أو الشاشة مقفلة** | إرسال إشعار رنين ذو أولوية قصوى (**High-Priority VoIP Push Notification**). | **على iPhone**: تفتح شاشة رنين النظام الرسمية (**Apple CallKit**) كمكالمة هاتفية عادية.<br>**على Android**: تضيء الشاشة وتفتح واجهة رنين كاملة (**Full-Screen Intent**). |
| **3. التطبيق مقفول وممسوح من الرام (Terminated / Killed)** | يقوم الـ VoIP Push بإيقاظ نظام التشغيل وتشغيل خدمة الاتصال في الخلفية فوراً. | يرن الهاتف فوراً بنغمة الرنين، وبمجرد ضغط الطبيب "قبول (Accept)" يفتح التطبيق ويدخل لغرفة مكالمة الفيديو مباشرة. |

---

### ج. ماذا يحدث عند تسجيل الخروج (Logout) أو إغلاق التواجد (Go Offline)؟
1. يرسل تطبيق الطبيب للباك إند تحديث حالة: `is_available = false` ليختفي من قائمة طوارئ المرضى.
2. يستدعي التطبيق أمر إلغاء التسجيل:
   ```dart
   ZegoUIKitPrebuiltCallInvitationService().uninit();
   ```
   هذا الإجراء يمسح تسجيل جهاز الطبيب من سيرفرات Zego لمنع رنين هاتفه بالخطأ أثناء إجازته أو بعد تسجيل الخروج.

---

## 3. متطلبات الباك إند بالتفصيل (Backend API Requirements)

### أ. التخصصات والأطباء المتاحون (Specialties & Doctors)

#### 1. جلب التخصصات المتاحة للطوارئ
* **Endpoint:** `GET /api/emergency/specialties`
* **Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid-specialty-1",
      "name": "الباطنة",
      "iconUrl": "https://.../internal_medicine.svg",
      "availableDoctorsCount": 3
    },
    {
      "id": "uuid-specialty-2",
      "name": "الأطفال",
      "iconUrl": "https://.../pediatrics.svg",
      "availableDoctorsCount": 1
    }
  ]
}
```

#### 2. جلب أطباء الطوارئ المتاحين والبدلاء
* **Endpoint:** `GET /api/emergency/doctors`
* **Query Parameters:**
  * `specialtyId` (optional, string): معرف التخصص.
  * `gender` (optional, int): 0 = الكل، 1 = ذكر (طبيب)، 2 = أنثى (طبيبة).
  * `minRating` (optional, double): 4.0 أو 4.5.
  * `sortBy` (optional, string): `available` (المتاح أولاً)، `highest_rated` (الأعلى تقييماً)، `most_reviews` (الأكثر تقييمات).
  * `search` (optional, string): البحث بالاسم أو التخصص.
* **Response:**
```json
{
  "success": true,
  "data": {
    "specialtyDoctors": [
      {
        "id": "doctor-uuid-1",
        "name": "د. عمر أحمد",
        "title": "استشاري الباطنة",
        "avatarUrl": "https://.../dr_omar.jpg",
        "rating": 4.9,
        "ratingCount": 124,
        "isAvailable": true,
        "consultationType": "video",
        "specialtyId": "uuid-specialty-1",
        "specialtyName": "الباطنة"
      }
    ],
    "generalDoctors": [
      {
        "id": "doctor-uuid-2",
        "name": "د. أحمد محمود",
        "title": "طبيب عام",
        "avatarUrl": "https://.../dr_ahmed.jpg",
        "rating": 4.8,
        "ratingCount": 98,
        "isAvailable": true,
        "consultationType": "video",
        "specialtyName": "طب عام"
      },
      {
        "id": "doctor-uuid-3",
        "name": "د. منى علي",
        "title": "طبيبة عامة",
        "avatarUrl": "https://.../dr_mony.jpg",
        "rating": 4.8,
        "ratingCount": 67,
        "isAvailable": true,
        "consultationType": "video",
        "specialtyName": "طب عام"
      }
    ]
  }
}
```
> **ملاحظة هامة:** إذا لم يكن هناك أطباء في التخصص المطلوب، تعود `specialtyDoctors` فارغة وتعود `generalDoctors` بالأطباء المتاحين في الطب العام لعرض الاقتراح البديل كما بالتصميم.

#### 3. بروفايل طبيب الطوارئ
* **Endpoint:** `GET /api/emergency/doctors/{id}`
* **Response:**
```json
{
  "success": true,
  "data": {
    "id": "doctor-uuid-1",
    "name": "د. عمر أحمد",
    "title": "استشاري الباطنة",
    "avatarUrl": "https://.../dr_omar.jpg",
    "rating": 4.9,
    "ratingCount": 124,
    "isAvailable": true,
    "about": "استشاري الباطنة، متخصص في تشخيص ومتابعة الأمراض المزمنة واضطرابات الجهاز الهضمي.",
    "qualifications": [
      "دكتوراه أمراض الباطنة",
      "١٢ عاماً من الخبرة في طب الباطنة"
    ],
    "reviews": [
      {
        "id": "rev-1",
        "userName": "محمد س.",
        "rating": 5.0,
        "comment": "استشارة سريعة وممتازة ومهنية جداً",
        "date": "2026-11-10"
      }
    ]
  }
}
```

---

### ب. إدارة جلسات الاتصال (Call Lifecycle APIs)

#### 1. بدء طلب مكالمة طوارئ (Initiate Call)
* **Endpoint:** `POST /api/emergency/calls/initiate`
* **Request Body:**
```json
{
  "doctorId": "doctor-uuid-1",
  "specialtyId": "uuid-specialty-1"
}
```
* **Response:**
```json
{
  "success": true,
  "data": {
    "callId": "call-session-uuid-101",
    "roomId": "room_emergency_call_101",
    "zegoToken": "04AAAAA...", // Token مشفر من Zego
    "timeoutSeconds": 45,
    "doctor": {
      "id": "doctor-uuid-1",
      "name": "د. عمر أحمد",
      "title": "استشاري الباطنة",
      "avatarUrl": "https://.../dr_omar.jpg"
    }
  }
}
```
* **سلوك الباك إند:** إرسال إشعار رنين فوري (VoIP Push عبر APNs / FCM High-Priority) لتطبيق الطبيب لإيقاظ جهازه وعرض واجهة اتصال واردة عبر CallKit / Full-Screen Intent.

#### 2. إلغاء الاتصال من المريض (Cancel Call)
* **Endpoint:** `POST /api/emergency/calls/{callId}/cancel`
* **الغرض:** يُستدعى عند ضغط المريض على زر "إلغاء الاتصال" أثناء الرنين لإيقاف الرنين عند الطبيب.

#### 3. التحديثات اللحظية لحالة المكالمة (Real-Time Status: SignalR / WebSockets)
أثناء وجود المريض في شاشة "الاتصال بالطبيب"، يرسل الباك إند أحداث لحظية:
* `OnCallAccepted`: الطبيب وافق ⬅ ينتقل المريض لشاشة الفيديو فوراً.
* `OnCallRejected`: الطبيب رفض / مشغول ⬅ ينتقل لشاشة "تعذر الاتصال".
* `OnCallTimeout`: لم يرد الطبيب خلال 45 ثانية ⬅ ينتقل لشاشة "لم يستجب الطبيب للمكالمة".
* `OnCallEnded`: إنهاء المكالمة من أحد الطرفين.

#### 4. إنهاء المكالمة (End Call)
* **Endpoint:** `POST /api/emergency/calls/{callId}/end`
* **Request Body:**
```json
{
  "durationSeconds": 321,
  "reason": "user_completed" // user_completed | connection_lost | doctor_ended
}
```

#### 5. ملخص المكالمة المنتهية (Call Summary)
* **Endpoint:** `GET /api/emergency/calls/{callId}/summary`
* **Response:**
```json
{
  "success": true,
  "data": {
    "callId": "call-session-uuid-101",
    "doctor": {
      "name": "د. عمر أحمد",
      "title": "استشاري الباطنة",
      "avatarUrl": "https://.../dr_omar.jpg"
    },
    "consultationType": "استشارة طوارئ",
    "durationFormatted": "05:21",
    "endedAt": "2026-11-18T16:05:00Z"
  }
}
```

#### 6. إرسال تقييم الاستشارة (Rate Call)
* **Endpoint:** `POST /api/emergency/calls/{callId}/rate`
* **Request Body:**
```json
{
  "rating": 5,
  "comment": "استجابة سريعة وتشخيص دقيق وممتاز"
}
```

---

## 4. متطلبات منصة ZegoCloud

1. **إعدادات الحساب والمشروع:**
   * إنشاء مشروع نوع **Video Call** على [Zego Console](https://console.zegocloud.com/).
   * استخراج `AppID` و `AppSign` و `ServerSecret` (لخدمة الباك إند).
2. **الأمان (Token Authentication):**
   * يقوم الباك إند بتوليد `Zego Token 04` لكل جلسة مكالمة بناءً على `UserID` و `RoomID` لمنع تضمين الـ `AppSign` الحساس في كود التطبيق.
3. **حزمة الـ SDK:**
   * الاعتماد على `zego_uikit_prebuilt_call` و `zego_zpns` مع ضبط أذونات الكاميرا والمايكروفون والـ Background Modes.

---

## 5. شاشات الفلو بالتفصيل (Screens Breakdown)

### الشاشة 1: الطوارئ (Emergency Home & Specialties)
* **العناصر:**
  * بار بحث "تحدث إلى طبيب متاح الآن" (ابحث عن تخصص).
  * قائمة التخصصات (الباطنة، الأسنان، الأطفال، العظام، الجلدية، الأنف والأذن، العيون، النساء والتوليد).
  * توجيه المريض مباشرة إلى قائمة أطباء التخصص عند الضغط.

### الشاشة 2: طوارئ التخصص (Doctors List Screen)
* **العناصر:**
  * شريط علوي يحتوي على أزرار "ترتيب" و "تصفية".
  * عداد الأطباء المتاحين.
  * قسم "أطباء [التخصص]": بطاقات الأطباء المتاحين مع تقييمهم وزر عريض "اتصال الآن".
  * قسم "أطباء العام": بطاقات أطباء الطب العام كبديل جاهز فوراً.

### الشاشة 3: التخصص فارغ مع اقتراح الطب العام (Specialty Empty State)
* تظهر إذا لم يتوفر أي طبيب في التخصص المطلوب:
* رسالة: *"لا يتوفر طبيب باطنة حالياً - يمكنك التواصل مع أطباء طب عام الآن"*.
* عرض بطاقات أطباء الطب العام المتاحين مع زر "اختيار تخصص آخر".

### الشاشة 4: تصفية أطباء الطوارئ (Filter Screen / Sheet)
* الفلاتر:
  * التخصص (Dropdown).
  * نوع الطبيب: (الكل / طبيب / طبيبة).
  * التقييم: (الكل / 4 نجوم / 4.5 نجوم).
* زر عريض: "عرض الأطباء" ومسح الكل.

### الشاشة 5: ترتيب الأطباء (Sort Bottom Sheet)
* الخيارات:
  * المتاح أولاً.
  * الأعلى تقييماً.
  * الأكثر تقييمات.
* زر عريض: "تطبيق الترتيب".

### الشاشة 6: شاشة عدم وجود أطباء نهائياً (Full Empty State)
* في حال عدم وجود أي طبيب باطنة أو عام متاح:
* رسالة: *"لا يوجد أطباء متاحون حالياً. اختر تخصصاً آخر أو جرب لاحقاً"* مع زر عريض "اختيار تخصص آخر".

### الشاشة 7: بروفايل الطبيب (Doctor Profile Screen)
* صورة الطبيب، اسمه، لقبه العلمي، تقييمه، شارة "متاح الآن".
* تبويبات:
  * "عن الطبيب": نبذة عن الطبيب، المؤهلات والخبرة.
  * "التقييمات": آراء المرضى السابقين.
* زر سفلي عريض عائم: "بدء مكالمة فيديو".

### الشاشة 8: شاشة جاري الاتصال (Outgoing Call / Ringing Screen)
* صورة الطبيب، الاسم والتخصص.
* نص متحرك: "جاري الاتصال...".
* تايمر مهلة زمني (45 ثانية).
* زر سفلي عريض: "إلغاء الاتصال".

### الشاشة 9: شاشة تعذر الاتصال (Call Failed / Timeout Screen)
* تظهر إذا رفض الطبيب أو لم يجب خلال المهلة.
* رسالة: *"لم يستجب الطبيب للمكالمة - يمكنك إعادة المحاولة أو اختيار طبيب آخر متاح"*.
* زر أساسي عريض: **"إعادة الاتصال"** (إعادة المحاولة مع نفس الطبيب).
* زر ثانوي عريض: **"عرض الأطباء المتاحين"** (العودة للقائمة).

### الشاشة 10: شاشة مكالمة الفيديو الفعالة (Active Video Call Screen)
* واجهة Zego Video Call:
  * فيديو الطبيب (Remote Stream) يملأ الخلفية.
  * كاميرا المريض (Local Stream) في نافذة PIP صغيرة عائمة وقابلة للتحريك.
  * شريط علوي: اسم الطبيب + نوع الاستشارة + عداد الوقت (مثال: `02:41`).
  * شريط تحكم سفلي:
    * كتم/تشغيل المايكروفون.
    * تبديل الكاميرا (أمامية / خلفية).
    * قفل/فتح الكاميرا.
    * زر إنهاء المكالمة باللون الأحمر.

### الشاشة 11: شاشة انتهاء الاستشارة والتقييم (Call Summary & Rating Screen)
* أيقونة صح خضراء مع عبارة: *"انتهت استشارتك - شكراً لك، نرجو تقييمك للاستشارة"*.
* بطاقة ملخص الاستشارة:
  * بيانات الطبيب.
  * نوع الاستشارة (استشارة طوارئ).
  * مدة المكالمة (مثال: `05:21`).
* قسم التقييم:
  * "كيف تقيم تجربتك مع الطبيب؟" (شريط تقييم تفاعلي 5 نجوم).
  * حقل نصي اختياري: "أضف تعليقاً عن الاستشارة (اختياري)".
  * زر عريض: "إرسال التقييم".
* زر سفلي عريض: "العودة إلى أطباء الطوارئ".

---

## 6. الحالات الاستثنائية والـ Edge Cases

| الحالة | السلوك المتوقع في التطبيق |
| :--- | :--- |
| **عدم وجود اتصال بالإنترنت أثناء طلب المكالمة** | إظهار تنبيه فوراً ومنع بدء الاتصال مع إبقاء المريض في نفس الشاشة. |
| **انقطاع الإنترنت أثناء مكالمة الفيديو** | تفعيل شاشة "إعادة الاتصال بالشبكة (Reconnecting)" لمدة 15 ثانية؛ إذا لم يعد النت تنتهي المكالمة وتُحسب المدة المنقضية. |
| **رفض المريض صلاحيات الكاميرا أو المايكروفون** | إظهار Dialog يطلب فتح إعدادات الهاتف (App Settings) لتفعيل الصلاحيات لأنها إجبارية لمكالمات الطوارئ. |
| **خروج المريض من التطبيق أثناء المكالمة** | استمرار المكالمة في الخلفية عبر الـ PIP (Picture-in-Picture) أو الصوت. |
| **انشغال الطبيب بمكالمة طوارئ أخرى في نفس الثانية** | استقبال حالة `DoctorBusy` من الباك إند وتحويل المريض تلقائياً لطبيب الطب العام المتاح بعد استئذانه. |

---

## 7. خطوات البدء المقترحة لفريق التطوير (Next Steps)

1. إرسال قسمي **آلية تسجيل الطبيب (قسم 2)** و **متطلبات الباك إند (قسم 3)** إلى فريق الـ Backend لبرمجة جدول أجهزة الأطباء والـ Endpoints وإعداد إشعارات الـ VoIP Push و SignalR.
2. تفعيل حساب Zego وتجهيز الـ `AppID` و `AppSign` الخاصين بالـ Staging/Dev.
3. البدء في Flutter ببناء الـ Data Layer (Models & API Manager) الخاصة باستعراض التخصصات والأطباء المتاحين.
4. بناء واجهات المستخدم (UI) لشاشات القوائم والفلترة والبروفايل.
5. دمج شاشات الاتصال (Ringing & Video Call) بعد ربط SignalR و Zego.
