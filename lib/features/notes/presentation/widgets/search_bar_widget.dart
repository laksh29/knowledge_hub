import 'package:flutter/material.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_colors.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_elevation.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_radii.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_spacing.dart';
import 'package:knowledge_hub/core/design_system/knowledge_hub_text_styles.dart';

/// The embedded free-text search entry atop the note list (task 5.2,
/// Requirement 6.1) per `.kiro/specs/notes-mvp/design.md`'s §"Presentation
/// Layer — UI Components" resolved `SearchBarWidget` spec: reuses
/// `search-bar-pill`'s full spec — `KnowledgeHubRadii.full`,
/// `KnowledgeHubColors.canvas` fill, 1px hairline border,
/// `KnowledgeHubElevation.cardHoverFloat` (documented there as applying to
/// "the search bar at rest"), 64px height. A single free-text [TextField]
/// stands in for the source component's Where/When/Who segments, with a
/// leading search icon and placeholder in `bodyMd`/muted.
///
/// Deliberately a plain [TextField], not [AppTextFieldWidget] — that shared
/// component renders the stacked-label-above-bordered-box `text-input`
/// shape, which is a different component token than this pill-shaped
/// search bar.
///
/// No [TextEditingController] is threaded in: unlike
/// `NoteEditorPage`'s title field, nothing external ever needs to rewrite
/// this field's text out from under the user's typing — `SearchState`
/// carries no query string to resync from, only search status — so
/// [TextField] is left to own its default internal controller.
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: KnowledgeHubSpacing.base),
      decoration: BoxDecoration(
        color: KnowledgeHubColors.canvas,
        borderRadius: BorderRadius.circular(KnowledgeHubRadii.full),
        border: Border.all(color: KnowledgeHubColors.hairline),
        boxShadow: KnowledgeHubElevation.cardHoverFloat,
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.search, color: KnowledgeHubColors.muted),
          const SizedBox(width: KnowledgeHubSpacing.sm),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.ink),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search notes',
                hintStyle: KnowledgeHubTextStyles.bodyMd.copyWith(color: KnowledgeHubColors.muted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
