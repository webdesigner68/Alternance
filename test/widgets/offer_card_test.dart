import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:la_bonne_alternance/data/models/job.dart';
import 'package:la_bonne_alternance/data/models/identifier.dart';
import 'package:la_bonne_alternance/data/models/offer.dart';
import 'package:la_bonne_alternance/data/models/workplace.dart';
import 'package:la_bonne_alternance/data/models/location.dart';
import 'package:la_bonne_alternance/data/models/contract.dart';
import 'package:la_bonne_alternance/widgets/offer_card.dart';

void main() {
  group('OfferCard', () {
    testWidgets('should display job title', (tester) async {
      final job = Job(
        identifier: const Identifier(id: '1', partnerLabel: 'LBA'),
        offer: const Offer(title: 'Développeur Flutter'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(job: job),
          ),
        ),
      );

      expect(find.text('Développeur Flutter'), findsOneWidget);
    });

    testWidgets('should display workplace name', (tester) async {
      final job = Job(
        identifier: const Identifier(id: '1', partnerLabel: 'LBA'),
        workplace: const Workplace(name: 'Acme Corp'),
        offer: const Offer(title: 'Développeur'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(job: job),
          ),
        ),
      );

      expect(find.text('Acme Corp'), findsOneWidget);
    });

    testWidgets('should display location', (tester) async {
      final job = Job(
        identifier: const Identifier(id: '1', partnerLabel: 'LBA'),
        workplace: const Workplace(
          name: 'Acme Corp',
          location: Location(city: 'Paris', postcode: '75001'),
        ),
        offer: const Offer(title: 'Développeur'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(job: job),
          ),
        ),
      );

      expect(find.text('Paris'), findsOneWidget);
    });

    testWidgets('should display contract type badge', (tester) async {
      final job = Job(
        identifier: const Identifier(id: '1', partnerLabel: 'LBA'),
        contract: const Contract(type: 'Apprentissage'),
        offer: const Offer(title: 'Développeur'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(job: job),
          ),
        ),
      );

      expect(find.text('Apprentissage'), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      var tapped = false;
      final job = Job(
        identifier: const Identifier(id: '1', partnerLabel: 'LBA'),
        offer: const Offer(title: 'Développeur'),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OfferCard(
              job: job,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      expect(tapped, true);
    });
  });
}
