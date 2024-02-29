import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:instagram_blocks_ui/instagram_blocks_ui.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({
    required this.isFollowed,
    required this.wasFollowed,
    required this.follow,
    this.isOutlined = false,
    super.key,
  });

  final bool isFollowed;
  final bool wasFollowed;
  final VoidCallback follow;
  final bool isOutlined;

  String? _followingStatus(BuildContext context) {
    switch ((wasFollowed, isFollowed)) {
      case (true, true):
        return BlockSettings().followTextDelegate.followingText;
      case (false, false):
        return BlockSettings().followTextDelegate.followText;
      case (true, false):
        return BlockSettings().followTextDelegate.followText;
      case _:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveBackgroundColor = isOutlined
        ? null
        : context.customReversedAdaptiveColor(
            light: AppColors.brightGrey,
            dark: AppColors.emphasizeDarkGrey,
          );
    Widget button(String data) => Tappable(
          onTap: follow,
          borderRadius: 6,
          fadeStrength: FadeStrength.medium,
          color: effectiveBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            child: Text(
              data,
              style: context.labelLarge
                  ?.apply(color: isOutlined ? AppColors.white : null),
            ),
          ),
        );

    return switch (_followingStatus(context)) {
      null => const SizedBox.shrink(),
      final String data => Tappable(
          onTap: follow,
          borderRadius: 6,
          color: effectiveBackgroundColor,
          child: switch (isOutlined) {
            true => DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.brightGrey),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
                child: button(data),
              ),
            false => button(data),
          },
        ),
    };
  }
}
