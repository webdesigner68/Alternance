import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:la_bonne_alternance/widgets/skeleton_loading.dart';

void main() {
  group('Skeleton Golden Tests', () {
    testGoldens('SkeletonOfferCard light theme', (tester) async {
      await tester.pumpWidgetBuilder(
        const SkeletonOfferCard(),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
        surfaceSize: const Size(400, 200),
      );

      await screenMatchesGolden(tester, 'skeleton_card_light');
    });

    testGoldens('SkeletonOfferCard dark theme', (tester) async {
      await tester.pumpWidgetBuilder(
        const SkeletonOfferCard(),
        wrapper: materialAppWrapper(theme: ThemeData.dark()),
        surfaceSize: const Size(400, 200),
      );

      await screenMatchesGolden(tester, 'skeleton_card_dark');
    });
  });
}
