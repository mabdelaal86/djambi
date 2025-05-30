import 'package:flame/components.dart';
import 'package:flutter/widgets.dart';

import '../../components.dart';
import '../../configs.dart';
import '../base.dart';

class GameSummaryChineseGame extends BasePage {
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final frameSize = Vector2(
      bodySize.x - Configs.smallMargin * 2,
      bodySize.y - Configs.smallMargin * 2,
    );

    final sections = <Section>[
      Section(
        title: '🎯 目标',
        content:
            "成为最后一个保有首领的玩家。消灭其他玩家的首领后，可以控制他们剩余的棋子。",
      ),
      Section(
        title: '🧩 游戏组件',
        content:
            "玩家人数：4人（红、蓝、黄、绿）。\n"
            "棋盘：9×9 网格，中央格子（E5）称为迷宫，象征权力中心。\n"
            "每位玩家的棋子：\n"
            "- 1 个首领\n"
            "- 1 个刺客\n"
            "- 1 个记者\n"
            "- 1 个外交官\n"
            "- 1 个灵车\n"
            "- 4 个民兵",
      ),
      Section(
        title: '🕹️ 游戏机制',
        content: "轮流进行，按照固定顺序依次进行。",
      ),
      Section(
        title: '移动规则：',
        content:
            "- 首领、刺客、记者、外交官、灵车：可以直线移动任意格数（如象棋中的皇后），但不能越过其他棋子。\n"
            "- 民兵：可以向任何方向移动1或2格。",
      ),
      Section(
        title: '⚔️ 行动与能力',
        content: "",
      ),
      Section(
        title: "首领：",
        content:
            "- 可通过移动至敌方棋子的位置将其击杀。\n"
            "- 将尸体放置于任意空格，包括迷宫。\n"
            "- 占据迷宫后，每当其他玩家移动后可获得额外一回合。\n"
            "- 当处于迷宫中时，不能被民兵击杀。",
      ),
      Section(
        title: "刺客：",
        content:
            "- 移动至敌方棋子位置将其击杀。\n"
            "- 尸体放置在刺客原来的位置。",
      ),
      Section(
        title: "记者：",
        content:
            "- 可击杀相邻（上下左右）棋子而不移动。\n"
            "- 尸体保持原位。\n"
            "- 可选择不击杀。",
      ),
      Section(
        title: "外交官：",
        content:
            "- 可交换对方存活棋子的位置。\n"
            "- 被移动的棋子放置于任意空格，不能放置在迷宫（除非是首领）。",
      ),
      Section(
        title: "灵车：",
        content:
            "- 可交换尸体的位置。\n"
            "- 尸体可以放在任意空格，除了迷宫。",
      ),
      Section(
        title: "民兵：",
        content:
            "- 通过移动至敌方棋子位置将其击杀。\n"
            "- 尸体可放置在任意空格，除了迷宫。\n"
            "- 无法击杀位于迷宫中的首领。",
      ),
      Section(
        title: '🏛️ 迷宫 (E5)',
        content:
            "只有首领可以停留在此中央格子。处于迷宫中的首领视为“掌权”，每当其他玩家完成一次移动后，可额外行动一次。在迷宫中的首领不会被民兵攻击。其他棋子可穿越迷宫，但不能停留。",
      ),
      Section(
        title: '🧟 尸体',
        content:
            "当一枚棋子被击杀后，会变为尸体，留在棋盘上成为障碍。灵车可以将尸体移动到战略位置。",
      ),
      Section(
        title: '🤝 联盟与背叛',
        content:
            "玩家可非正式地组建联盟，但允许背叛，且常常具有战略意义。联盟不受官方规则限制，仅依赖玩家之间的协商。",
      ),
      Section(
        title: '🏁 游戏结束',
        content:
            "当只剩下一位首领时，游戏结束。击杀首领的玩家将接管该玩家剩余的棋子。若首领被尸体包围且无灵车，则视为被淘汰。",
      ),
    ];

    final fullText = sections
        .map((section) => '${section.title}\n${section.content}')
        .join('\n\n');

    final textPaint = TextPaint(
      style: TextStyle(
        fontSize: 18.0,
        color: const Color(0xFFFFFFFF),
      ),
    );

    final scrollBox = ScrollTextBoxComponent(
      text: fullText,
      textRenderer: textPaint,
      size: frameSize,
      position: Vector2(Configs.smallMargin, Configs.smallMargin),
      boxConfig: TextBoxConfig(
        margins: const EdgeInsets.all(10),
      ),
    );

    await add(scrollBox);
  }
}

class Section {
  final String title;
  final String content;
  Section({required this.title, required this.content});
}
