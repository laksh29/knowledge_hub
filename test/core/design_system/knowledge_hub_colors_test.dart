import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';

void main() {
  group('KnowledgeHubColors', () {
    test('mirrors design.md Surface and Text color hex values exactly', () {
      expect(KnowledgeHubColors.canvas, const Color(0xFFFFFFFF));
      expect(KnowledgeHubColors.ink, const Color(0xFF222222));
      expect(KnowledgeHubColors.body, const Color(0xFF3F3F3F));
      expect(KnowledgeHubColors.muted, const Color(0xFF6A6A6A));
      expect(KnowledgeHubColors.surfaceSoft, const Color(0xFFF7F7F7));
      expect(KnowledgeHubColors.surfaceStrong, const Color(0xFFF2F2F2));
      expect(KnowledgeHubColors.hairline, const Color(0xFFDDDDDD));
    });

    test('mirrors design.md Brand & Accent color hex values exactly', () {
      expect(KnowledgeHubColors.primary, const Color(0xFFFF385C));
      expect(KnowledgeHubColors.primaryActive, const Color(0xFFE00B41));
      expect(KnowledgeHubColors.primaryDisabled, const Color(0xFFFFD1DA));
      expect(KnowledgeHubColors.onPrimary, const Color(0xFFFFFFFF));
    });

    test('mirrors design.md Semantic error text color hex value exactly', () {
      expect(KnowledgeHubColors.errorText, const Color(0xFFC13515));
    });
  });
}
