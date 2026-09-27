import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_elevation.dart';

void main() {
  group('KnowledgeHubElevation', () {
    test(
      'cardHoverFloat mirrors design.md single documented shadow tier exactly',
      () {
        final List<BoxShadow> shadows = KnowledgeHubElevation.cardHoverFloat;

        expect(shadows.length, 3);

        expect(shadows[0].color, const Color.fromRGBO(0, 0, 0, 0.02));
        expect(shadows[0].offset, Offset.zero);
        expect(shadows[0].blurRadius, 0);
        expect(shadows[0].spreadRadius, 1);

        expect(shadows[1].color, const Color.fromRGBO(0, 0, 0, 0.04));
        expect(shadows[1].offset, const Offset(0, 2));
        expect(shadows[1].blurRadius, 6);
        expect(shadows[1].spreadRadius, 0);

        expect(shadows[2].color, const Color.fromRGBO(0, 0, 0, 0.1));
        expect(shadows[2].offset, const Offset(0, 4));
        expect(shadows[2].blurRadius, 8);
        expect(shadows[2].spreadRadius, 0);
      },
    );
  });
}
