import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musicbox/src/app/features/log/presentation/widgets/rating_picker_widget.dart';

void main() {
  group('RatingPickerWidget', () {
    Future<void> pump(WidgetTester tester, {required int? rating, required ValueChanged<int?> onChanged}) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: RatingPickerWidget(rating: rating, onChanged: onChanged)),
        ),
      );
    }

    testWidgets('renders five stars', (tester) async {
      await pump(tester, rating: null, onChanged: (_) {});

      expect(find.byType(Icon), findsNWidgets(5));
    });

    testWidgets('tapping a star reports its value', (tester) async {
      int? picked;
      await pump(tester, rating: null, onChanged: (value) => picked = value);

      await tester.tap(find.byType(InkResponse).at(2));

      expect(picked, 3);
    });

    testWidgets('tapping the current rating clears it', (tester) async {
      int? picked = 4;
      await pump(tester, rating: 4, onChanged: (value) => picked = value);

      await tester.tap(find.byType(InkResponse).at(3));

      expect(picked, isNull);
    });

    testWidgets('each star has a 44px touch target', (tester) async {
      await pump(tester, rating: 2, onChanged: (_) {});

      final size = tester.getSize(find.byType(InkResponse).first);

      expect(size.width, greaterThanOrEqualTo(44));
      expect(size.height, greaterThanOrEqualTo(44));
    });
  });
}
