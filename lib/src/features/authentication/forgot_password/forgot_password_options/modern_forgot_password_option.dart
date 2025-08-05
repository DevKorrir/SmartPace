import 'package:flutter/material.dart';

class ModernForgotPasswordOption extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const ModernForgotPasswordOption({
    Key? key,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  @override
  State<ModernForgotPasswordOption> createState() =>
      _ModernForgotPasswordOptionState();
}

class _ModernForgotPasswordOptionState extends State<ModernForgotPasswordOption>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isPressed = true);
              _hoverController.forward();
            },
            onTapUp: (_) {
              setState(() => _isPressed = false);
              _hoverController.reverse();
              widget.onTap();
            },
            onTapCancel: () {
              setState(() => _isPressed = false);
              _hoverController.reverse();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    _isPressed
                        ? (isDark ? Colors.grey[800] : Colors.grey[100])
                        : (isDark ? Colors.grey[850] : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color:
                      _isPressed
                          ? widget.iconColor.withOpacity(0.3)
                          : (isDark ? Colors.grey[700]! : Colors.grey[200]!),
                  width: 1.5,
                ),
                boxShadow:
                    _isPressed
                        ? []
                        : [
                          BoxShadow(
                            color: (isDark ? Colors.black : Colors.grey)
                                .withOpacity(isDark ? 0.3 : 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.iconBackground,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.iconColor, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color
                                ?.withOpacity(0.7),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 16,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.4),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
