import 'package:dashboard/src/common_widgets/margins.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage baseDialog({
  required BuildContext modalSheetContext,
  required TextTheme textTheme,
  required String title,
  required Widget Function(WidgetRef) child,
  required void Function(WidgetRef) onBack,
  required void Function(WidgetRef, GlobalKey<FormState>) onNext,
  Text? Function(WidgetRef)? backButtonText,
  Text? Function(WidgetRef)? nextButtonText,
}) {
  return WoltModalSheetPage(
    topBarTitle: Text(title, style: textTheme.titleMedium),
    isTopBarLayerAlwaysVisible: true,
    trailingNavBarWidget: IconButton(
      padding: const EdgeInsets.all(16),
      icon: const Icon(Icons.close),
      onPressed: Navigator.of(modalSheetContext).pop,
    ),
    child: _Body(
      child: child,
      onBack: onBack,
      onNext: onNext,
      backButtonText: backButtonText,
      nextButtonText: nextButtonText,
    ),
  );
}

class _Body extends ConsumerWidget {
  const _Body({
    required this.child,
    required this.onBack,
    required this.onNext,
    this.backButtonText,
    this.nextButtonText,
  });

  final Widget Function(WidgetRef) child;
  final void Function(WidgetRef) onBack;
  final void Function(WidgetRef, GlobalKey<FormState>) onNext;
  final Text? Function(WidgetRef)? backButtonText;
  final Text? Function(WidgetRef)? nextButtonText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 20),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            child(
              ref,
            ),
            verticalMargin32,
            Align(
              alignment: Alignment.bottomRight,
              child: _BottomButtons(
                formKey: formKey,
                onBack: onBack,
                onNext: onNext,
                backButtonText: backButtonText,
                nextButtonText: nextButtonText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomButtons extends ConsumerWidget {
  const _BottomButtons({
    required this.onBack,
    required this.onNext,
    this.backButtonText,
    this.nextButtonText,
    required this.formKey,
  });

  final void Function(WidgetRef) onBack;
  final void Function(WidgetRef, GlobalKey<FormState>) onNext;

  final Text? Function(WidgetRef)? backButtonText;
  final Text? Function(WidgetRef)? nextButtonText;

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backButtonText = this.backButtonText?.call(ref);
    final nextButtonText = this.nextButtonText?.call(ref);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => onBack(ref),
          child: backButtonText ??
              const Text(
                'Back',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
        ),
        horizontalMargin16,
        TextButton(
          onPressed: () => onNext(ref, formKey),
          child: nextButtonText ??
              const Text(
                'Next',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
        ),
      ],
    );
  }
}
