---
name: kiro-spec-design
description: Generate comprehensive technical design translating requirements (WHAT) into architecture (HOW) with discovery process. Use when creating architecture from requirements.
allowed-tools: Read, Write, Edit, Grep, Glob, WebSearch, WebFetch, Agent
argument-hint: <feature-name> [-y]
metadata:
  shared-rules: "design-principles.md, design-discovery-full.md, design-discovery-light.md, design-synthesis.md, design-review-gate.md"
---

# kiro-spec-design Skill

## Core Mission
- **Success Criteria**:
  - All requirements mapped to technical components with clear interfaces
  - The design makes responsibility boundaries explicit enough to guide task generation and review
  - Appropriate architecture discovery and research completed
  - Design aligns with steering context and existing patterns
  - Visual diagrams included for complex architectures
  - UI components cite `design.md` (repo root) tokens/components rather than inventing visual values

## Execution Steps

### Step 1: Gather Context

If steering/spec context is already available from conversation, skip redundant file reads.
Otherwise, load all necessary context:
- `.kiro/specs/{feature}/spec.json`, `requirements.md`, `design.md` (if exists)
- `.kiro/specs/{feature}/research.md` (if exists, contains gap analysis from `/kiro-validate-gap`)
- Core steering context: `product.md`, `tech.md`, `structure.md`
- `flutter-clean-architecture-guide.md` (repo root) — the project's binding Flutter Clean Architecture & TDD standard. Read it directly; `tech.md`/`structure.md` only summarize it and intentionally omit code-level examples and the PR review checklist (§9)
- `design.md` (repo root) — the project's binding UI design system (colors, typography, spacing, radius, elevation, components). Read it directly whenever this feature includes any screen/page/widget; `.kiro/steering/design-system.md` only condenses it
- Additional steering files only when directly relevant to requirement coverage, architecture boundaries, integrations, runtime prerequisites, security/performance constraints, or team conventions that affect implementation readiness
- `.kiro/settings/templates/specs/design.md` for document structure
- Read `rules/design-principles.md` from this skill's directory for design principles
- `.kiro/settings/templates/specs/research.md` for discovery log structure

**Validate requirements approval**:
- If auto-approve flag is true: Auto-approve requirements in spec.json
- Otherwise: Verify approval status (stop if unapproved, see Safety & Fallback)

### Step 2: Discovery & Analysis

**Critical: This phase ensures design is based on complete, accurate information.**

1. **Classify Feature Type**:
   - **New Feature** (greenfield) → Full discovery required
   - **Extension** (existing system) → Integration-focused discovery
   - **Simple Addition** (CRUD/UI) → Minimal or no discovery
   - **Complex Integration** → Comprehensive analysis required

2. **Execute Appropriate Discovery Process**:

   **For Complex/New Features**:
   - Read and execute `rules/design-discovery-full.md` from this skill's directory
   - Conduct thorough research using WebSearch/WebFetch:
     - Latest architectural patterns and best practices
     - External dependency verification (APIs, libraries, versions, compatibility)
     - Official documentation, migration guides, known issues
     - Performance benchmarks and security considerations

   **For Extensions**:
   - Read and execute `rules/design-discovery-light.md` from this skill's directory
   - Focus on integration points, existing patterns, compatibility
   - Use Grep to analyze existing codebase patterns

   **For Simple Additions**:
   - Skip formal discovery, quick pattern check only

#### Parallel Research (subagent dispatch)

The following research areas are independent and can be dispatched as **subagents** via the Agent tool. The agent should decide the optimal decomposition based on feature complexity — split, merge, add, or skip subagents as needed. Each subagent returns a **findings summary** (not raw data) to keep the main context clean for synthesis.

**Typical research areas** (adjust as appropriate):
- **Codebase analysis**: Existing architecture patterns, integration points, code conventions (using Grep/Glob)
- **External research**: Dependencies, APIs, latest best practices (using WebSearch/WebFetch)
- **Context loading** (usually main context): Steering files, design principles, discovery rules, templates

For simple additions, skip subagent dispatch entirely and do a quick pattern check in main context.

After all findings return, synthesize in main context before proceeding.

3. **Retain Discovery Findings for Step 3**:
   - External API contracts and constraints
   - Technology decisions with rationale
   - Existing patterns to follow or extend
   - Integration points and dependencies
   - Identified risks and mitigation strategies
   - Boundary candidates, out-of-boundary decisions, and likely revalidation triggers

4. **Persist Findings to Research Log**:
   - Create or update `.kiro/specs/{feature}/research.md` using the shared template
   - Summarize discovery scope and key findings
   - Record investigations with sources and implications
   - Document architecture pattern evaluation, design decisions, and risks
   - Use the language specified in spec.json when writing or updating `research.md`

### Step 3: Synthesis

**Apply design synthesis to discovery findings before writing.**

- Read and apply `rules/design-synthesis.md` from this skill's directory
- This step requires the full picture from discovery findings — execute in main context, not in a subagent
- Record synthesis outcomes (generalizations found, build-vs-adopt decisions, simplifications) in `research.md`

### Step 4: Generate Design Draft

1. **Generate Design Draft**:
   - **Follow specs/design.md template structure and generation instructions strictly**
   - **Boundary-first requirement**: Before expanding supporting sections, make the boundary explicit. The draft must clearly define what this spec owns, what it does not own, which dependencies are allowed, and what changes would require downstream revalidation.
   - **Integrate all discovery findings and synthesis outcomes**: Use researched information (APIs, patterns, technologies) and synthesis decisions (generalizations, build-vs-adopt, simplifications) throughout component definitions, architecture decisions, and integration points
   - **File Structure Plan** (required): Populate the File Structure Plan section with concrete file paths and responsibilities. Analyze the codebase to determine which files need to be created vs. modified. Each file must have one clear responsibility. This section directly drives task `_Boundary:_` annotations and implementation Task Briefs — vague file structures produce vague implementations.
   - **Testing Strategy**: Derive test items from requirements' acceptance criteria, not generic patterns. Each test item should reference specific components and behaviors from this design. E2E paths must map to the critical user flows identified in requirements. Avoid vague entries like "test login works" -- instead specify what is being verified and why it matters.
   - If existing design.md found in Step 1, use it as reference context (merge mode)
   - Apply design rules: Type Safety, Visual Communication, Formal Tone
   - Use language specified in spec.json
   - Keep this as a draft until the review gate passes; do not write `design.md` yet

### Step 5: Review Design Draft

- Read and apply `rules/design-review-gate.md` from this skill's directory
- Verify requirements coverage, architecture readiness, and implementation executability before finalizing the design
- If issues are local to the draft, repair the design and review again
- Keep the review bounded to at most 2 repair passes
- If the draft exposes a real requirements/design gap, stop and return to requirements clarification instead of papering over it in `design.md`

### Step 6: Finalize Design Document

1. **Write Final Design**:
   - Write `.kiro/specs/{feature}/design.md` only after the design review gate passes
   - Write research.md with discovery findings and synthesis outcomes (if not already written)

2. **Update Metadata** in spec.json:

   - Set `phase: "design-generated"`
   - Set `approvals.design.generated: true, approved: false`
   - Set `approvals.requirements.approved: true`
   - Update `updated_at` timestamp

## Critical Constraints
 - **Type Safety** (Dart/Flutter, per `flutter-clean-architecture-guide.md` and `.kiro/steering/tech.md`):
   - Never use `dynamic` — not as a variable, parameter, or return type.
   - Never use `Object?` as a substitute for a proper type — every value has a concrete type.
   - Never use `Map<String, dynamic>` to pass structured data between functions or layers — define a typed Model/Entity/ViewModel class. The only exception is `fromJson`/`toJson` serialization or an explicitly documented schema-free server blob, confined to the Model boundary.
   - Every variable declaration, function/method parameter, and return type must be explicit and concrete — no inferred return types, no `var` for non-obvious locals.
   - Every class, variable, field, parameter, and function name must be verbose and contextual — describe precisely what it holds or does (see `.kiro/steering/tech.md` Naming).
   - Document public interfaces and contracts (Repository, DataSource, UseCase, Service) clearly to ensure cross-component type safety.
 - **UI/Visual Design** (whenever the feature includes a screen, page, or widget):
   - Derive every color, typography, spacing, radius, and elevation value from `design.md` (repo root) tokens/components — never invent a hex value, raw px number, or ad hoc font size/weight.
   - Cite the specific `design.md` token(s)/component name(s) each UI component uses in its Components & Interfaces entry.
   - If a needed visual pattern isn't covered by `design.md` (see its "Known Gaps" section), flag it explicitly as an open decision rather than guessing a plausible value.
- **Requirements Traceability IDs**: Use numeric requirement IDs only (e.g. "1.1", "1.2", "3.1", "3.3") exactly as defined in requirements.md. Do not invent new IDs or use alphabetic labels.

## Output Description

**Command execution output** (separate from design.md content):

Provide brief summary in the language specified in spec.json:

1. **Status**: Confirm design document generated at `.kiro/specs/{feature}/design.md`
2. **Discovery Type**: Which discovery process was executed (full/light/minimal)
3. **Key Findings**: 2-3 critical insights from discovery that shaped the design
4. **Review Gate**: Confirm the design review gate passed
5. **Next Action**: Approval workflow guidance (see Safety & Fallback)
6. **Research Log**: Confirm `research.md` updated with latest decisions

**Format**: Concise Markdown (under 200 words) - this is the command output, NOT the design document itself

**Note**: The actual design document follows `.kiro/settings/templates/specs/design.md` structure.

## Safety & Fallback

### Error Scenarios

**Requirements Not Approved**:
- **Stop Execution**: Cannot proceed without approved requirements
- **User Message**: "Requirements not yet approved. Approval required before design generation."
- **Suggested Action**: "Run `/kiro-spec-design {feature} -y` to auto-approve requirements and proceed"

**Missing Requirements**:
- **Stop Execution**: Requirements document must exist
- **User Message**: "No requirements.md found at `.kiro/specs/{feature}/requirements.md`"
- **Suggested Action**: "Run `/kiro-spec-requirements {feature}` to generate requirements first"

**Template Missing**:
- **User Message**: "Template file missing at `.kiro/settings/templates/specs/design.md`"
- **Suggested Action**: "Check repository setup or restore template file"
- **Fallback**: Use inline basic structure with warning

**Steering Context Missing**:
- **Warning**: "Steering directory empty or missing - design may not align with project standards"
- **Proceed**: Continue with generation but note limitation in output

**`design.md` Missing** (feature includes UI):
- **Warning**: "No `design.md` found at repo root - UI components may not align with an established design system"
- **Proceed**: Continue with generation but flag every UI component's visual values as provisional pending a design system reference

**Invalid Requirement IDs**:
  - **Stop Execution**: If requirements.md is missing numeric IDs or uses non-numeric headings (for example, "Requirement A"), stop and instruct the user to fix requirements.md before continuing.

**Spec Gap Found During Design Review**:
- **Stop Execution**: Do not write a patched-over `design.md`
- **User Message**: "Design review found a real spec gap or ambiguity that must be resolved before design can be finalized."
- **Suggested Action**: Clarify or fix `requirements.md`, then re-run `/kiro-spec-design {feature}`

### Next Phase: Task Generation

**If Design Approved**:
- **Optional**: Run `/kiro-validate-design {feature}` for interactive quality review
- Run `/kiro-spec-tasks {feature}` to generate implementation tasks
- Or `/kiro-spec-tasks {feature} -y` to auto-approve and proceed directly

**If Modifications Needed**:
- Provide feedback and re-run `/kiro-spec-design {feature}`
- Existing design used as reference (merge mode)
