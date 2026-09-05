import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_assets.dart';

/// Reusable App Logo Widget
class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const AppLogo({
    super.key,
    this.size = AppDimensions.logoSize,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo Image
        Container(
          width: size,
          height: size,
          decoration: const BoxDecoration(
            // Will add shadow/effects if needed
          ),
          child: Image.asset(
            AppAssets.splashLogo,
            width: size,
            height: size,
            fit: BoxFit.contain,
          ),
        ),

        if (showText) ...[
          const SizedBox(height: AppDimensions.spacingL),

          // App Name
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(text: 'Gentle\n', style: AppTextStyles.appTitle),
                TextSpan(text: 'Dose', style: AppTextStyles.appTitle),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingM),

          // Tagline
          Text(
            'Because your health\nmatters every day.',
            textAlign: TextAlign.center,
            style: AppTextStyles.tagline,
          ),
        ],
      ],
    );
  }
}
