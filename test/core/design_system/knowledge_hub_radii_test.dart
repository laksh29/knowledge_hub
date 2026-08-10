import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';

void main() {
  group('KnowledgeHubRadii', () {
    test('mirrors design.md {rounded.*} radius scale exactly', () {
      expect(KnowledgeHubRadii.sm, 8);
      expect(KnowledgeHubRadii.md, 14);
      expect(KnowledgeHubRadii.full, 9999);
      expect(KnowledgeHubRadii.xl, 32);
    });
  });
}
