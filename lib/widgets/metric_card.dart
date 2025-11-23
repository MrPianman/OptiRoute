import 'package:flutter/material.dart';
import '../theme/theme_controller.dart';

class MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final void Function()? onTap;
  final String? subtitle;
  final String? trend;
  final bool? isPositiveTrend;

  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
    this.subtitle,
    this.trend,
    this.isPositiveTrend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = color ?? scheme.primary;
    final grandmaModeEnabled = ThemeController.instance.grandmaMode.value;

    final Color backgroundColor = grandmaModeEnabled
        ? (isDark
            ? scheme.surfaceVariant.withValues(alpha: 0.95)
            : scheme.surface)
        : (isDark
            ? cardColor.withValues(alpha: 0.25)
            : cardColor.withValues(alpha: 0.9));

    final BorderRadius radius = BorderRadius.circular(grandmaModeEnabled ? 22 : 16);
    final Color primaryTextColor = grandmaModeEnabled
        ? (isDark ? Colors.white : scheme.onSurface)
        : Colors.white;
    final Color secondaryTextColor = grandmaModeEnabled
        ? (isDark ? Colors.white.withValues(alpha: 0.85) : scheme.onSurfaceVariant)
        : Colors.white.withValues(alpha: 0.8);

    final TextStyle titleStyle = TextStyle(
      color: primaryTextColor,
      fontSize: grandmaModeEnabled ? 16 : 12,
      fontWeight: grandmaModeEnabled ? FontWeight.w700 : FontWeight.w500,
      letterSpacing: grandmaModeEnabled ? 0.4 : 0,
    );

    final TextStyle valueStyle = TextStyle(
      color: primaryTextColor,
      fontSize: grandmaModeEnabled ? 38 : 28,
      fontWeight: FontWeight.bold,
      height: 1,
    );

    final TextStyle detailStyle = TextStyle(
      color: secondaryTextColor,
      fontSize: grandmaModeEnabled ? 14 : 11,
      fontWeight: grandmaModeEnabled ? FontWeight.w600 : FontWeight.w400,
    );
    
    return Card(
      elevation: grandmaModeEnabled ? 3 : 0,
      shadowColor: grandmaModeEnabled ? cardColor.withValues(alpha: 0.35) : null,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: grandmaModeEnabled
            ? BorderSide(color: cardColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(grandmaModeEnabled ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(grandmaModeEnabled ? 12 : 8),
                    decoration: BoxDecoration(
                      color: grandmaModeEnabled
                          ? cardColor.withValues(alpha: isDark ? 0.3 : 0.15)
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(grandmaModeEnabled ? 14 : 8),
                      border: grandmaModeEnabled
                          ? Border.all(color: cardColor.withValues(alpha: 0.9), width: 1.2)
                          : null,
                    ),
                    child: Icon(
                      icon,
                      size: grandmaModeEnabled ? 26 : 20,
                      color: grandmaModeEnabled ? cardColor : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: titleStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (grandmaModeEnabled && subtitle != null && trend == null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              subtitle!,
                              style: detailStyle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: grandmaModeEnabled ? 16 : 12),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  value,
                  style: valueStyle,
                ),
              ),
              SizedBox(height: grandmaModeEnabled ? 14 : 8),
              if (trend != null && isPositiveTrend != null)
                _TrendBadge(
                  label: trend!,
                  isPositive: isPositiveTrend!,
                  grandmaMode: grandmaModeEnabled,
                  fallbackTextColor: secondaryTextColor,
                )
              else if (subtitle != null)
                Text(
                  subtitle!,
                  style: detailStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (grandmaModeEnabled && onTap != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      Icon(Icons.touch_app, size: 18, color: secondaryTextColor),
                      const SizedBox(width: 6),
                      Text(
                        'Tap for details',
                        style: detailStyle.copyWith(fontSize: 13),
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

class _TrendBadge extends StatelessWidget {
  final String label;
  final bool isPositive;
  final bool grandmaMode;
  final Color fallbackTextColor;

  const _TrendBadge({
    required this.label,
    required this.isPositive,
    required this.grandmaMode,
    required this.fallbackTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = isPositive ? Colors.green : Colors.redAccent;
    final Color background = grandmaMode
        ? base.withValues(alpha: 0.18)
        : fallbackTextColor.withValues(alpha: 0.2);
    final Color iconColor = grandmaMode ? base : Colors.white;
    final Color textColor = grandmaMode ? base : Colors.white;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: grandmaMode ? 14 : 8,
        vertical: grandmaMode ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(grandmaMode ? 999 : 12),
        border: grandmaMode ? Border.all(color: base, width: 1.2) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            size: grandmaMode ? 20 : 14,
            color: iconColor,
          ),
          SizedBox(width: grandmaMode ? 8 : 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: grandmaMode ? 15 : 11,
              fontWeight: grandmaMode ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
