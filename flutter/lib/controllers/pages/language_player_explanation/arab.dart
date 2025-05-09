import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameSummaryArabic extends StatelessWidget {
  // قائمة قطع اللعبة مع العناوين والوصف باللغة العربية
  final List<Map<String, String>> pieces = [
    {
      'title': 'جامبي هي لعبة لوحية سياسية استراتيجية لأربعة لاعبين على شبكة 9×9. الهدف أن تكون آخر رئيس على قيد الحياة. المربع المركزي (اللَّبْهَة) يمنح قوّة خاصة لأي رئيس يتوقف عليه: دورات إضافية ومناعة ضد الهجمات العادية.',
      'image': '',
      'description': ''
    },
    {
      'title': 'الرئيس (C) – القائد (رمز: إكليل الغار).',
      'image': 'assets/classic/chief.svg',
      'description':
          'كلاهما (المسؤولون والمُعَتِّمون) يأسر الخصم بالانتقال إلى مربعه ثم وضع جثة الخصم في أي مربع فارغ غير اللَّبْهَة. عندما يموت الرئيس، يكتسب القاتل فورًا جميع قطع ذلك الرئيس الحية والميتة. أي رئيس على E5 يكون محميًا ولا يمكن أسره.'
    },
    {
      'title': 'القاتل الصامت (A) – قاتل متخفي (رمز: الهدف).',
      'image': 'assets/classic/assassin.svg',
      'description':
          'يلتقط تمامًا مثل المقاتل بالانتقال إلى مربع قطعة العدو، لكنه يعيد دائمًا جثة الضحية إلى المربع الذي غادره (أي “يترك الجثة في الموطن”)، مما يمنع إعادة استخدامها حتى يُحرَّك.'
    },
    {
      'title': 'المراسل (R) – القاتل الاستقصائي (رمز: العين).',
      'image': 'assets/classic/reporter.svg',
      'description':
          'يقتل بالانتقال إلى أحد الأربعة مربعات المجاورة عموديًا للهدف (لا يمكن القتل قطريًا). إذا نُقل بواسطة الدبلوماسي، يجب أن يتحرك مرة أخرى قبل القتل. تبقى الجثة في مربع هبوطه.'
    },
    {
      'title': 'المقاتل (M) – الجندي (رمز: القبضة) ×4 لكل لاعب.',
      'image': 'assets/classic/Militant.svg',
      'description':
          'قطعة هجومية تتحرك مربعًا أو مربعين في أي اتجاه (عمودي أو قطري)، تأسر بالاستبدال، وتضع الجثة في أي مربع فارغ يختاره اللاعب—باستثناء اللَّبْهَة (E5). لا يمكنه أسره رئيس في اللَّبْهَة.'
    },
    {
      'title': 'الدبلوماسي (Di) – المحرك السياسي (رمز: رأس ذو وجهين).',
      'image': 'assets/classic/diplomat.svg',
      'description':
          'قطعة غير قتالية (تسمى أيضًا مثير المتاعب) تُحرّك قطع العدو الحية دون أسره.'
    },
    {
      'title': 'ناقلة الجثث (N) – ناقل الجثث (رمز: الجمجمة).',
      'image': 'assets/classic/necromobile.svg',
      'description':
          'يقود الفريق. يمكنه القتل مثل المقاتل، وإذا توقف علىاللَّبْهَة (المركز) يحصل على دورات إضافية ومناعة من الهجمات العادية.'
    },
    {
      'title': 'ملاحظة: في الألعاب الثلاثية، تُعتبر قطع الزاوية الرابعة “رهائن” يمكن لأي لاعب تحريكها أو قتلها؛ رئيسهم لا يمنح قوة اللَّبْهَة.',
      'image': '',
      'description': ''
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ملخص اللعبة'),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          itemCount: pieces.length,
          itemBuilder: (context, index) {
            final piece = pieces[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (piece['image']!.isNotEmpty)
                    SvgPicture.asset(
                      piece['image']!,
                      width: 48,
                      height: 48,
                      semanticsLabel: piece['title'],
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          piece['title']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (piece['description']!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            piece['description']!,
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PieceCardArabic extends StatelessWidget {
  final Map<String, String> piece;
  const PieceCardArabic(this.piece);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        child: ListTile(
          leading: piece['image']!.isNotEmpty
              ? Image.network(piece['image']!, width: 50, height: 50)
              : null,
          title: Text(
            piece['title']!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: piece['description']!.isNotEmpty
              ? Text(piece['description']!)
              : null,
        ),
      ),
    );
  }
}