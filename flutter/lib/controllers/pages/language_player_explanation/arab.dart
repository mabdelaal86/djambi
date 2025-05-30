import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../configs.dart';
import '../base.dart';

class GameSummaryArabicGame extends BasePage {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // تحديد حجم منطقة التمرير
    final frameSize = Vector2(
      bodySize.x - Configs.smallMargin * 2,
      bodySize.y - Configs.smallMargin * 2,
    );

    // تعريف الأقسام باللغة العربية
    final sections = <Section>[
      Section(
        title: '🎯 الهدف',
        content:
            "كن آخر لاعب يحتفظ برئيسه حيًا. القضاء على رؤساء اللاعبين الآخرين يتيح لك السيطرة على قطعهم المتبقية.",
      ),
      Section(
        title: '🧩 مكونات اللعبة',
        content:
            "اللاعبون: 4 (أحمر، أزرق، أصفر، أخضر).\n"
            "لوحة اللعب: شبكة 9×9 مع المربع المركزي (E5) المسمى بالمتاهة، والذي يرمز إلى مركز القوة.\n"
            "القطع لكل لاعب:\n"
            "- 1 رئيس\n"
            "- 1 قاتل\n"
            "- 1 مراسل\n"
            "- 1 دبلوماسي\n"
            "- 1 ناقل الجثث\n"
            "- 4 مقاتلين",
      ),
      Section(
        title: '🕹️ آليات اللعب',
        content:
            "ترتيب الأدوار: يتناوب اللاعبون في تسلسل ثابت.",
      ),
      Section(
        title: 'الحركة:',
        content:
            "- الرئيس، القاتل، المراسل، الدبلوماسي، ناقل الجثث: يتحركون عددًا غير محدود من المربعات في خطوط مستقيمة (مثل الملكة في الشطرنج)، دون القفز فوق قطع أخرى.\n"
            "- المقاتلون: يتحركون 1 أو 2 مربع في أي اتجاه.",
      ),
      Section(
        title: '⚔️ الإجراءات والقدرات',
        content: "",
      ),
      Section(
        title: "الرئيس:",
        content:
            "- يمكنه القتل بالتحرك إلى قطعة الخصم.\n"
            "- يضع الجثة في أي مربع غير مشغول، بما في ذلك المتاهة.\n"
            "- عند التواجد في المتاهة، يحصل على دور إضافي بعد كل حركة للخصم.\n"
            "- لا يمكن قتله بواسطة المقاتلين أثناء وجوده في المتاهة.",
      ),
      Section(
        title: "القاتل:",
        content:
            "- يقتل بالتحرك إلى قطعة الخصم.\n"
            "- يضع الجثة في المربع الأصلي للقاتل.",
      ),
      Section(
        title: "المراسل:",
        content:
            "- يقتل قطعة مجاورة (أفقيًا أو عموديًا) دون التحرك إليها.\n"
            "- تبقى الجثة في موقعها الأصلي.\n"
            "- يمكنه اختيار عدم القتل.",
      ),
      Section(
        title: "الدبلوماسي:",
        content:
            "- يحرك قطعة حية للخصم عن طريق تبديل الأماكن.\n"
            "- توضع القطعة المنقولة في أي مربع غير مشغول، باستثناء المتاهة (إلا إذا كانت رئيسًا).",
      ),
      Section(
        title: "ناقل الجثث:",
        content:
            "- ينقل جثة عن طريق تبديل الأماكن.\n"
            "- توضع الجثة في أي مربع غير مشغول، باستثناء المتاهة.",
      ),
      Section(
        title: "المقاتلون:",
        content:
            "- يقتلون بالتحرك إلى قطعة الخصم.\n"
            "- توضع الجثة في أي مربع غير مشغول، باستثناء المتاهة.\n"
            "- لا يمكنهم قتل الرئيس أثناء وجوده في المتاهة.",
      ),
      Section(
        title: '🏛️ المتاهة (E5)',
        content:
            "فقط الرئيس يمكنه احتلال هذا المربع المركزي. يعتبر الرئيس في المتاهة 'في السلطة' ويحصل على دور إضافي بعد كل حركة للخصم. أثناء وجوده في المتاهة، يكون الرئيس محصنًا من هجمات المقاتلين. يمكن للقطع الأخرى المرور عبر المتاهة ولكن لا يمكنها التوقف فيها.",
      ),
      Section(
        title: '🧟 الجثث',
        content:
            "عند قتل قطعة، تتحول إلى جثة وتبقى على اللوحة، مما يشكل عقبة. يمكن لناقل الجثث تحريك الجثث إلى مواقع استراتيجية.",
      ),
      Section(
        title: '🤝 التحالفات والخيانة',
        content:
            "يمكن للاعبين تشكيل تحالفات غير رسمية، لكن الخيانة مسموحة وغالبًا ما تكون استراتيجية. لا توجد قواعد رسمية تحكم التحالفات؛ فهي تعتمد على تفاوض اللاعبين.",
      ),
      Section(
        title: '🏁 نهاية اللعبة',
        content:
            "تنتهي اللعبة عندما يبقى رئيس واحد حيًا فقط. عند قتل رئيس، يحصل اللاعب الذي قتله على السيطرة على قطع اللاعب المتوفى المتبقية. إذا كان الرئيس محاطًا بالجثث ولا يملك ناقل جثث، يعتبر مُقضى عليه.",
      ),
    ];

    // دمج جميع الأقسام في نص واحد
    final fullText = sections
        .map((section) => '${section.title}\n${section.content}')
        .join('\n\n');

    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 18.0,
        color: const Color(0xFFFFFFFF),
        fontFamily: 'Amiri', // تأكد من إضافة الخط إلى المشروع
      ),
      textDirection: TextDirection.rtl,
    );

    // إنشاء مكون صندوق النص القابل للتمرير
    final scrollBox = ScrollTextBoxComponent(
      text: fullText,
      textRenderer: textPaint,
      size: frameSize,
      position: Vector2(Configs.smallMargin, Configs.smallMargin),
      boxConfig: TextBoxConfig(
        margins: const EdgeInsets.all(10),
      ),
    );

    // إضافة صندوق النص إلى اللعبة
    await add(scrollBox);
  }
}

// نموذج القسم
class Section {
  final String title;
  final String content;
  Section({required this.title, required this.content});
}
