import 'package:flutter/material.dart';
import '../../../../core/utils/app_theme.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color color;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM), // ✅ تم التصحيح
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM), // ✅ تم التصحيح
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppConstants.paddingS), // ✅ تم التصحيح
              Expanded(
                child: Text(
                  title,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface, // ✅ تم التصحيح
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingS), // ✅ تم التصحيح
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty)
            Text(
              subtitle!,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface, // ✅ تم التصحيح
              ),
            ),
        ],
      ),
    );
  }
}

class SharedStatsBuilder {
  static Widget buildMobileStats({
    required List<StatsCard> cards,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: cards[0]),
            const SizedBox(width: AppConstants.paddingM), // ✅ تم التصحيح
            Expanded(child: cards[1]),
          ],
        ),
        if (cards.length > 2) ...[
          const SizedBox(height: AppConstants.paddingM), // ✅ تم التصحيح
          Row(
            children: [
              Expanded(child: cards[2]),
              const SizedBox(width: AppConstants.paddingM), // ✅ تم التصحيح
              if (cards.length > 3)
                Expanded(child: cards[3])
              else
                const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ],
    );
  }

  static Widget buildDesktopStats({
    required List<StatsCard> cards,
  }) {
    return Row(
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i < cards.length - 1) const SizedBox(width: AppConstants.paddingM),
        ],
      ],
    );
  }

  static Widget buildStatsContainer({
    required BuildContext context,
    required List<StatsCard> cards,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      decoration: const BoxDecoration( // ✅
        border: Border(
          bottom: BorderSide(color: AppColors.divider),
        ),
      ),
      child: ResponsiveHelper.isMobile(context)
          ? buildMobileStats(cards: cards)
          : buildDesktopStats(cards: cards),
    );
  }
}