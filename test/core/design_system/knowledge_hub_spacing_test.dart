import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';

void main() {
  group('KnowledgeHubSpacing', () {
    test('mirrors design.md 4px-base spacing scale exactly', () {
      expect(KnowledgeHubSpacing.xxs, 2);
      expect(KnowledgeHubSpacing.xs, 4);
      expect(KnowledgeHubSpacing.sm, 8);
      expect(KnowledgeHubSpacing.md, 12);
      expect(KnowledgeHubSpacing.base, 16);
      expect(KnowledgeHubSpacing.lg, 24);
      expect(KnowledgeHubSpacing.xl, 32);
      expect(KnowledgeHubSpacing.xxl, 48);
      expect(KnowledgeHubSpacing.section, 64);
    });
  });
}
