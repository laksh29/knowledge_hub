import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

void main() {
  group('KnowledgeHubTextStyles', () {
    test('titleMd mirrors design.md {typography.title-md}', () {
      expect(KnowledgeHubTextStyles.titleMd.fontSize, 16);
      expect(KnowledgeHubTextStyles.titleMd.fontWeight, FontWeight.w600);
      expect(KnowledgeHubTextStyles.titleMd.height, 1.25);
      expect(KnowledgeHubTextStyles.titleMd.letterSpacing, 0);
    });

    test('buttonMd mirrors design.md {typography.button-md}', () {
      expect(KnowledgeHubTextStyles.buttonMd.fontSize, 16);
      expect(KnowledgeHubTextStyles.buttonMd.fontWeight, FontWeight.w500);
      expect(KnowledgeHubTextStyles.buttonMd.height, 1.25);
      expect(KnowledgeHubTextStyles.buttonMd.letterSpacing, 0);
    });

    test('bodyMd mirrors design.md {typography.body-md}', () {
      expect(KnowledgeHubTextStyles.bodyMd.fontSize, 16);
      expect(KnowledgeHubTextStyles.bodyMd.fontWeight, FontWeight.w400);
      expect(KnowledgeHubTextStyles.bodyMd.height, 1.5);
      expect(KnowledgeHubTextStyles.bodyMd.letterSpacing, 0);
    });

    test('bodySm mirrors design.md {typography.body-sm}', () {
      expect(KnowledgeHubTextStyles.bodySm.fontSize, 14);
      expect(KnowledgeHubTextStyles.bodySm.fontWeight, FontWeight.w400);
      expect(KnowledgeHubTextStyles.bodySm.height, 1.43);
      expect(KnowledgeHubTextStyles.bodySm.letterSpacing, 0);
    });

    test('caption mirrors design.md {typography.caption}', () {
      expect(KnowledgeHubTextStyles.caption.fontSize, 14);
      expect(KnowledgeHubTextStyles.caption.fontWeight, FontWeight.w500);
      expect(KnowledgeHubTextStyles.caption.height, 1.29);
      expect(KnowledgeHubTextStyles.caption.letterSpacing, 0);
    });

    test('captionSm mirrors design.md {typography.caption-sm}', () {
      expect(KnowledgeHubTextStyles.captionSm.fontSize, 13);
      expect(KnowledgeHubTextStyles.captionSm.fontWeight, FontWeight.w400);
      expect(KnowledgeHubTextStyles.captionSm.height, 1.23);
      expect(KnowledgeHubTextStyles.captionSm.letterSpacing, 0);
    });
  });
}
