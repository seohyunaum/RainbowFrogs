import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const RainbowFrogsApp());
}

class RainbowFrogsApp extends StatelessWidget {
  const RainbowFrogsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rainbow Frogs',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff93b879)),
      ),
      home: const HomeScreen(),
    );
  }
}

class AppColors {
  static const leaf = Color(0xffa8c491);
  static const darkLeaf = Color(0xff5d7d4d);
  static const pond = Color(0xffdff5e9);
  static const tan = Color(0xffc88a55);
  static const cream = Color(0xfffff8ea);
  static const cardBack = Color(0xff858b53);
  static const softPink = Color(0xffffd6c9);
}

enum GameScreenMode {
  distribution3,
  distribution4,
  drawing,
  emote,
  emoteSelection,
  trading,
  winner,
}

class FrogSkin {
  final String name;
  final Color color;
  final Color belly;
  const FrogSkin(this.name, this.color, this.belly);
}

const frogSkins = [
  FrogSkin('Green', Color(0xffbce37c), Color(0xfffff7c8)),
  FrogSkin('Blue', Color(0xffbceeed), Color(0xfffffff0)),
  FrogSkin('Pink', Color(0xffffc6b8), Color(0xfffff5e9)),
  FrogSkin('Yellow', Color(0xffffe891), Color(0xfffff7c8)),
  FrogSkin('Purple', Color(0xffd4d0e8), Color(0xfffff6e0)),
  FrogSkin('Mint', Color(0xffb7efe0), Color(0xfffff8e6)),
];

class LeafBackground extends StatelessWidget {
  final Widget child;
  final bool pondScene;
  const LeafBackground({super.key, required this.child, this.pondScene = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: pondScene
              ? const [Color(0xffe7f8ef), Color(0xffcfeecb), Color(0xffedf8d9)]
              : const [Color(0xfff2fff2), Color(0xffe5f7d5), Color(0xffd8f0c1)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(painter: LeafPatternPainter(pondScene: pondScene)),
          child,
        ],
      ),
    );
  }
}

class LeafPatternPainter extends CustomPainter {
  final bool pondScene;
  LeafPatternPainter({required this.pondScene});

  @override
  void paint(Canvas canvas, Size size) {
    final leafPaint = Paint()..color = const Color(0xff8cc86f).withOpacity(.55);
    final lightPaint = Paint()..color = Colors.white.withOpacity(.35);
    final skyPaint = Paint()..color = const Color(0xffb7e9f2).withOpacity(.45);

    if (pondScene) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(size.width * .45, size.height * .68), width: size.width * .85, height: size.height * .28),
        skyPaint,
      );
      final bankPaint = Paint()..color = const Color(0xffbadb84).withOpacity(.7);
      canvas.drawOval(Rect.fromLTWH(-40, size.height * .73, size.width + 80, size.height * .24), bankPaint);
    }

    for (int i = 0; i < 34; i++) {
      final x = (i * 73 % 997) / 997 * size.width;
      final y = (i * 131 % 811) / 811 * size.height;
      final w = 10.0 + (i % 4) * 4;
      final h = 20.0 + (i % 3) * 6;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate((i % 8) * math.pi / 8);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: w, height: h), leafPaint);
      canvas.restore();
    }

    for (int i = 0; i < 18; i++) {
      final x = (i * 59 % 700) / 700 * size.width;
      final y = (i * 91 % 500) / 500 * size.height;
      canvas.drawCircle(Offset(x, y), 4 + (i % 4) * 2, lightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const AppIconButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.55),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.darkLeaf, size: 22),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LeafBackground(
          pondScene: true,
          child: Stack(
            children: [
              const Positioned(top: 12, right: 12, child: AppIconButton(icon: Icons.settings)),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Rainbow Frogs', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 18),
                        const FrogAvatar(size: 130, skin: frogSkins[2]),
                        const SizedBox(height: 24),
                        MenuButton(
                          icon: Icons.play_arrow,
                          label: 'Start Game',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen(mode: GameScreenMode.distribution3))),
                        ),
                        const SizedBox(height: 12),
                        MenuButton(
                          icon: Icons.shopping_cart_outlined,
                          label: 'Pond Store',
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StoreScreen())),
                        ),
                        const SizedBox(height: 20),
                        const CurrencyBar(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const MenuButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.tan,
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 2,
        ),
      ),
    );
  }
}

class CurrencyBar extends StatelessWidget {
  const CurrencyBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        CurrencyPill(icon: '🥥', text: '51'),
        SizedBox(width: 10),
        CurrencyPill(icon: '🌶️', text: '500'),
      ],
    );
  }
}

class CurrencyPill extends StatelessWidget {
  final String icon;
  final String text;
  const CurrencyPill({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(color: AppColors.darkLeaf.withOpacity(.88), borderRadius: BorderRadius.circular(16)),
      child: Text('$icon  $text', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
    );
  }
}

class GameScreen extends StatelessWidget {
  final GameScreenMode mode;
  const GameScreen({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LeafBackground(
          child: Stack(
            children: [
              const Positioned(top: 10, right: 10, child: AppIconButton(icon: Icons.settings)),
              if (mode != GameScreenMode.winner) ...[
                const Positioned(left: 18, top: 48, child: PlayerLabel(name: 'Player_name', skin: 0, crown: true)),
                const Positioned(right: 16, top: 85, child: PlayerLabel(name: 'Player_name', skin: 2, compact: true)),
                if (mode == GameScreenMode.distribution4 || mode == GameScreenMode.trading)
                  const Positioned(left: 16, top: 135, child: PlayerLabel(name: 'Player_name', skin: 1, compact: true)),
                if (mode != GameScreenMode.distribution4)
                  const Positioned(right: 20, bottom: 32, child: PlayerLabel(name: 'You', skin: 3, compact: true)),
              ],
              _body(context),
              if (mode != GameScreenMode.winner) const Positioned(left: 12, bottom: 88, child: GoalTags()),
              if (mode != GameScreenMode.winner && mode != GameScreenMode.trading)
                const Positioned(bottom: 16, left: 0, right: 0, child: PlayerHand()),
              if (mode == GameScreenMode.trading) const TradingLayout(),
              if (mode != GameScreenMode.winner)
                Positioned(
                  bottom: 20,
                  right: 118,
                  child: RoundIconButton(icon: Icons.shuffle, onTap: () {}),
                ),
              if (mode != GameScreenMode.winner)
                Positioned(
                  bottom: 20,
                  right: 70,
                  child: RoundIconButton(icon: Icons.chat_bubble_outline, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen(mode: GameScreenMode.emoteSelection)))),
                ),
              const Positioned(left: 8, top: 8, child: BackCircle()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    switch (mode) {
      case GameScreenMode.drawing:
        return const DrawingCards();
      case GameScreenMode.emote:
        return const EmoteBubbles();
      case GameScreenMode.emoteSelection:
        return const EmoteSelectionOverlay();
      case GameScreenMode.trading:
        return const SizedBox.shrink();
      case GameScreenMode.winner:
        return const WinnerPanel();
      case GameScreenMode.distribution4:
      case GameScreenMode.distribution3:
        return const Center(child: CardStack(count: 5, width: 62, height: 88));
    }
  }
}

class BackCircle extends StatelessWidget {
  const BackCircle({super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => Navigator.maybePop(context),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(color: Colors.white.withOpacity(.45), shape: BoxShape.circle),
          child: const Icon(Icons.arrow_back, size: 20),
        ),
      );
}

class PlayerLabel extends StatelessWidget {
  final String name;
  final int skin;
  final bool crown;
  final bool compact;
  const PlayerLabel({super.key, required this.name, required this.skin, this.crown = false, this.compact = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            FrogAvatar(size: compact ? 54 : 68, skin: frogSkins[skin]),
            if (crown) const Positioned(top: -16, left: 14, child: Text('👑', style: TextStyle(fontSize: 20))),
            if (compact) Positioned(right: -6, top: -4, child: BadgeNumber(number: skin + 1)),
          ],
        ),
        Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class BadgeNumber extends StatelessWidget {
  final int number;
  const BadgeNumber({super.key, required this.number});
  @override
  Widget build(BuildContext context) => CircleAvatar(radius: 10, backgroundColor: Colors.white, child: Text('$number', style: const TextStyle(fontSize: 10)));
}

class GoalTags extends StatelessWidget {
  const GoalTags({super.key});
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SmallTag('x = 2'),
          SizedBox(height: 6),
          SmallTag('y = -1'),
          SizedBox(height: 6),
          SmallTag('Closest to Zero!'),
        ],
      );
}

class SmallTag extends StatelessWidget {
  final String text;
  const SmallTag(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(color: AppColors.leaf.withOpacity(.9), borderRadius: BorderRadius.circular(8)),
        child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      );
}

class PlayerHand extends StatelessWidget {
  const PlayerHand({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(7, (i) => Transform.translate(offset: Offset(-i * 7, 0), child: const PlayingCard(width: 54, height: 86))),
    );
  }
}

class PlayingCard extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final bool back;
  const PlayingCard({super.key, this.width = 72, this.height = 108, this.child, this.back = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: back ? AppColors.cardBack : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 4, offset: const Offset(1, 2))],
      ),
      child: child,
    );
  }
}

class CardStack extends StatelessWidget {
  final int count;
  final double width;
  final double height;
  const CardStack({super.key, required this.count, required this.width, required this.height});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: width + count * 4,
        height: height,
        child: Stack(children: List.generate(count, (i) => Positioned(left: i * 4, child: PlayingCard(width: width, height: height, back: true)))),
      );
}

class DrawingCards extends StatelessWidget {
  const DrawingCards({super.key});
  @override
  Widget build(BuildContext context) => Positioned.fill(
        child: Stack(
          children: [
            Positioned(left: 90, top: 60, child: Transform.rotate(angle: -0.85, child: const CardStack(count: 8, width: 78, height: 108))),
            const Center(child: CardStack(count: 4, width: 58, height: 86)),
          ],
        ),
      );
}

class EmoteBubbles extends StatelessWidget {
  const EmoteBubbles({super.key});
  @override
  Widget build(BuildContext context) => const Stack(
        children: [
          Positioned(left: 110, top: 50, child: SpeechBubble(text: 'Hurry up!')),
          Positioned(right: 82, top: 56, child: SpeechBubble(text: 'Take these\nplease!')),
          Center(child: CardStack(count: 5, width: 56, height: 84)),
        ],
      );
}

class SpeechBubble extends StatelessWidget {
  final String text;
  const SpeechBubble({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.black54)),
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

class EmoteSelectionOverlay extends StatelessWidget {
  const EmoteSelectionOverlay({super.key});
  @override
  Widget build(BuildContext context) {
    final messages = ['Hurry up!', 'Good game', 'Hahaha', 'Take this!', 'Thanks!', 'Booooo', 'Unlucky!', 'Help me!', 'Noooooo'];
    return Stack(
      children: [
        Positioned.fill(child: Container(color: Colors.black.withOpacity(.6))),
        Positioned(right: 14, top: 22, child: Column(children: const [OverlayLine(), SizedBox(height: 12), OverlayLine()])),
        Positioned(right: 18, bottom: 28, child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: messages.map((m) => Chip(label: Text(m, style: const TextStyle(fontSize: 12)), visualDensity: VisualDensity.compact)).toList(),
        )),
        const Positioned(left: 18, top: 48, child: PlayerLabel(name: 'Player_name', skin: 0, crown: true)),
      ],
    );
  }
}

class OverlayLine extends StatelessWidget {
  const OverlayLine({super.key});
  @override
  Widget build(BuildContext context) => Container(width: 180, height: 20, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)));
}

class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const RoundIconButton({super.key, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: CircleAvatar(backgroundColor: AppColors.leaf, radius: 22, child: Icon(icon, color: Colors.black87)),
      );
}

class TradingLayout extends StatelessWidget {
  const TradingLayout({super.key});
  @override
  Widget build(BuildContext context) => Stack(
        children: const [
          Positioned(left: 16, top: 70, child: TradePile()),
          Positioned(right: 28, top: 70, child: TradePile()),
          Positioned(left: 0, right: 0, bottom: 16, child: PlayerHand()),
          Positioned(left: 0, right: 0, bottom: 118, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [PlayingCard(width: 64, height: 100), SizedBox(width: 18), PlayingCard(width: 64, height: 100)])),
        ],
      );
}

class TradePile extends StatelessWidget {
  const TradePile({super.key});
  @override
  Widget build(BuildContext context) => Column(children: const [PlayingCard(width: 46, height: 70, back: true), SizedBox(height: 12), PlayingCard(width: 50, height: 78), SizedBox(height: 8), PlayingCard(width: 50, height: 78)]);
}

class WinnerPanel extends StatelessWidget {
  const WinnerPanel({super.key});
  @override
  Widget build(BuildContext context) {
    final rows = [('Player_name', 0, '0', '1'), ('Player_name', 1, '-10', '3'), ('You', 3, '500', '-1')];
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 54, 18, 20),
      child: Column(
        children: rows.map((r) {
          return Expanded(
            child: Row(
              children: [
                PlayerLabel(name: r.$1, skin: r.$2, compact: true),
                const SizedBox(width: 15),
                Expanded(child: Row(children: List.generate(7, (_) => const Padding(padding: EdgeInsets.only(right: 4), child: PlayingCard(width: 42, height: 64))))),
                ScoreBox(text: r.$3),
                const SizedBox(width: 8),
                CurrencyPill(icon: '🥥', text: r.$4),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ScoreBox extends StatelessWidget {
  final String text;
  const ScoreBox({super.key, required this.text});
  @override
  Widget build(BuildContext context) => Container(
        width: 90,
        height: 55,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.white.withOpacity(.45), borderRadius: BorderRadius.circular(18)),
        child: Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
      );
}

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LeafBackground(
          child: Stack(
            children: [
              const Positioned(left: 8, top: 8, child: BackCircle()),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 54, 18, 18),
                child: Row(
                  children: [
                    SizedBox(
                      width: 130,
                      child: Column(
                        children: const [
                          StoreTab(text: 'Skins', selected: true),
                          StoreTab(text: 'BGM'),
                          StoreTab(text: 'Accessories'),
                          StoreTab(text: 'Wallpapers'),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: frogSkins.map((skin) => StoreItem(skin: skin)).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreTab extends StatelessWidget {
  final String text;
  final bool selected;
  const StoreTab({super.key, required this.text, this.selected = false});
  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 12),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: selected ? AppColors.leaf : const Color(0xffb5987d), borderRadius: BorderRadius.circular(18)),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
}

class StoreItem extends StatelessWidget {
  final FrogSkin skin;
  const StoreItem({super.key, required this.skin});
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: const Color(0xff9d806b).withOpacity(.65), borderRadius: BorderRadius.circular(6)),
        child: Center(child: FrogAvatar(size: 86, skin: skin)),
      );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: LeafBackground(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  const Expanded(child: Center(child: FrogAvatar(size: 170, skin: frogSkins[2], sword: true))),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ProfileField(label: 'Username', value: 'frippyfrog'),
                        ProfileField(label: 'Skin Color', value: 'Pink', pink: true),
                        ProfileField(label: 'Accessories', value: 'Sword'),
                        ProfileField(label: '', value: 'None'),
                        ProfileField(label: '', value: 'None'),
                        SizedBox(height: 16),
                        CurrencyBar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final bool pink;
  const ProfileField({super.key, required this.label, required this.value, this.pink = false});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600))),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
                decoration: BoxDecoration(color: pink ? AppColors.softPink : AppColors.leaf, borderRadius: BorderRadius.circular(18)),
                child: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      );
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: LeafBackground(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  StoreTab(text: 'Volume', selected: true),
                  StoreTab(text: 'Background Music', selected: true),
                  StoreTab(text: 'Wallpaper', selected: true),
                ],
              ),
            ),
          ),
        ),
      );
}

class FrogSkinsScreen extends StatelessWidget {
  const FrogSkinsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: GridView.count(crossAxisCount: 3, children: frogSkins.map((s) => FrogAvatar(size: 110, skin: s)).toList()),
          ),
        ),
      );
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Rainbow Frogs', style: TextStyle(fontSize: 24))));
}

class CardDesignScreen extends StatelessWidget {
  const CardDesignScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                PlayingCard(width: 90, height: 145, child: Center(child: Text('10x', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900)))),
                PlayingCard(width: 90, height: 145, back: true),
              ],
            ),
          ),
        ),
      );
}

class FrogAvatar extends StatelessWidget {
  final double size;
  final FrogSkin skin;
  final bool sword;
  const FrogAvatar({super.key, required this.size, required this.skin, this.sword = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: FrogPainter(skin: skin, sword: sword)),
    );
  }
}

class FrogPainter extends CustomPainter {
  final FrogSkin skin;
  final bool sword;
  FrogPainter({required this.skin, required this.sword});

  @override
  void paint(Canvas canvas, Size size) {
    final shadow = Paint()..color = Colors.black.withOpacity(.08);
    final body = Paint()..color = skin.color;
    final belly = Paint()..color = skin.belly;
    final outline = Paint()
      ..color = const Color(0xff7b715f).withOpacity(.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .018;
    final eye = Paint()..color = Colors.black87;
    final blush = Paint()..color = const Color(0xffff9d8f).withOpacity(.45);

    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .5, size.height * .85), width: size.width * .75, height: size.height * .12), shadow);
    canvas.drawCircle(Offset(size.width * .36, size.height * .26), size.width * .13, body);
    canvas.drawCircle(Offset(size.width * .64, size.height * .26), size.width * .13, body);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .5, size.height * .55), width: size.width * .72, height: size.height * .64), body);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .5, size.height * .64), width: size.width * .43, height: size.height * .35), belly);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .26, size.height * .78), width: size.width * .28, height: size.height * .18), body);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .74, size.height * .78), width: size.width * .28, height: size.height * .18), body);
    canvas.drawCircle(Offset(size.width * .36, size.height * .26), size.width * .05, eye);
    canvas.drawCircle(Offset(size.width * .64, size.height * .26), size.width * .05, eye);
    canvas.drawCircle(Offset(size.width * .46, size.height * .39), size.width * .013, eye);
    canvas.drawCircle(Offset(size.width * .54, size.height * .39), size.width * .013, eye);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .31, size.height * .45), width: size.width * .1, height: size.height * .06), blush);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .69, size.height * .45), width: size.width * .1, height: size.height * .06), blush);
    canvas.drawArc(Rect.fromCenter(center: Offset(size.width * .5, size.height * .43), width: size.width * .18, height: size.height * .13), 0, math.pi, false, outline);
    canvas.drawOval(Rect.fromCenter(center: Offset(size.width * .5, size.height * .55), width: size.width * .72, height: size.height * .64), outline);

    if (sword) {
      final swordPaint = Paint()
        ..color = const Color(0xff355d78)
        ..strokeWidth = size.width * .035
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(size.width * .72, size.height * .63), Offset(size.width * .92, size.height * .38), swordPaint);
      canvas.drawLine(Offset(size.width * .69, size.height * .6), Offset(size.width * .78, size.height * .68), swordPaint..color = const Color(0xffd69c2f));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}