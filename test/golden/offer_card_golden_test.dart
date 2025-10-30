import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:la_bonne_alternance/data/models/job.dart';
import 'package:la_bonne_alternance/data/models/identifier.dart';
import 'package:la_bonne_alternance/data/models/offer.dart';
import 'package:la_bonne_alternance/data/models/workplace.dart';
import 'package:la_bonne_alternance/data/models/location.dart';
import 'package:la_bonne_alternance/data/models/contract.dart';
import 'package:la_bonne_alternance/widgets/offer_card.dart';

void main() {
  group('OfferCard Golden Tests', () {
    final job = Job(
      identifier: const Identifier(id: '1', partnerLabel: 'LBA'),
      workplace: const Workplace(
        name: 'Acme Corp',
        location: Location(city: 'Paris', postcode: '75001'),
      ),
      contract: const Contract(
        type: 'Apprentissage',
        workMode: 'hybrid',
      ),
      offer: const Offer(
        title: 'Développeur Flutter',
        targetDiplomaLevel: '5',
      ),
    );

    testGoldens('OfferCard light theme', (tester) async {
      await tester.pumpWidgetBuilder(
        OfferCard(job: job),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
        surfaceSize: const Size(400, 200),
      );

      await screenMatchesGolden(tester, 'offer_card_light');
    });

    testGoldens('OfferCard dark theme', (tester) async {
      await tester.pumpWidgetBuilder(
        OfferCard(job: job),
        wrapper: materialAppWrapper(theme: ThemeData.dark()),
        surfaceSize: const Size(400, 200),
      );

      await screenMatchesGolden(tester, 'offer_card_dark');
    });
  });
}
