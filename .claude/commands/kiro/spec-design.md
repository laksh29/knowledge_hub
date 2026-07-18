---
description: Create comprehensive technical design for a specification
allowed-tools: Bash, Glob, Grep, LS, Read, Write, Edit, MultiEdit, Update, WebSearch, WebFetch
argument-hint: <feature-name> [-y]
---

# Technical Design Generator

<background_information>
- **Mission**: Generate comprehensive technical design document that translates requirements (WHAT) into architectural design (HOW)
- **Success Criteria**:
  - All requirements mapped to technical components with clear interfaces
  - Appropriate architecture discovery and research completed
  - Design aligns with steering context and existing patterns
  - Visual diagrams included for complex architectures
</background_information>

<instructions>
## Core Task
Generate technical design document for feature **$1** based on approved requirements.

## Execution Steps

### Step 1: Load Context

**Read all necessary context**:
- `.kiro/specs/$1/spec.json`, `requirements.md`, `design.md` (if exists)
- **Entire `.kiro/steering/` directory** for complete project memory
- `flutter-clean-architecture-guide.md` (repo root) — the project's binding Flutter Clean Architecture & TDD standard. Read it directly; `.kiro/steering/tech.md`/`structure.md` only summarize it and intentionally omit code-level examples and the PR review checklist (§9)
- `.kiro/settings/templates/specs/design.md` for document structure
- `.kiro/settings/rules/design-principles.md` for design principles
- `.kiro/settings/templates/specs/research.md` for discovery log structure

**Validate requirements approval**:
- If `-y` flag provided ($2 == "-y"): Auto-approve requirements in spec.json
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
   - Read and execute `.kiro/settings/rules/design-discovery-full.md`
   - Conduct thorough research using WebSearch/WebFetch:
     - Latest architectural patterns and best practices
     - External dependency verification (APIs, libraries, versions, compatibility)
     - Official documentation, migration guides, known issues
     - Performance benchmarks and security considerations
   
   **For Extensions**:
   - Read and execute `.kiro/settings/rules/design-discovery-light.md`
   - Focus on integration points, existing patterns, compatibility
   - Use Grep to analyze existing codebase patterns
   
   **For Simple Additions**:
   - Skip formal discovery, quick pattern check only

3. **Retain Discovery Findings for Step 3**:
- External API contracts and constraints
- Technology decisions with rationale
- Existing patterns to follow or extend
- Integration points and dependencies
- Identified risks and mitigation strategies
- Potential architecture patterns and boundary options (note details in `research.md`)
- Parallelization considerations for future tasks (capture dependencies in `research.md`)

4. **Persist Findings to Research Log**:
- Create or update `.kiro/specs/$1/research.md` using the shared template
- Summarize discovery scope and key findings (Summary section)
- Record investigations in Research Log topics with sources and implications
- Document architecture pattern evaluation, design decisions, and risks using the template sections
- Use the language specified in spec.json when writing or updating `research.md`

### Step 3: Generate Design Document

1. **Load Design Template and Rules**:
- Read `.kiro/settings/templates/specs/design.md` for structure
- Read `.kiro/settings/rules/design-principles.md` for principles

2. **Generate Design Document**:
- **Follow specs/design.md template structure and generation instructions strictly**
- **Integrate all discovery findings**: Use researched information (APIs, patterns, technologies) throughout component definitions, architecture decisions, and integration points
- If existing design.md found in Step 1, use it as reference context (merge mode)
- Apply design rules: Type Safety, Visual Communication, Formal Tone
- Use language specified in spec.json
- Ensure sections reflect updated headings ("Architecture Pattern & Boundary Map", "Technology Stack & Alignment", "Components & Interface Contracts") and reference supporting details from `research.md`

3. **Update Metadata** in spec.json:
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
- **Latest Information**: Use WebSearch/WebFetch for external dependencies and best practices
- **Steering Alignment**: Respect existing architecture patterns from steering context
- **Template Adherence**: Follow specs/design.md template structure and generation instructions strictly
- **Design Focus**: Architecture and interfaces ONLY, no implementation code
- **Requirements Traceability IDs**: Use numeric requirement IDs only (e.g. "1.1", "1.2", "3.1", "3.3") exactly as defined in requirements.md. Do not invent new IDs or use alphabetic labels.
</instructions>

## Tool Guidance
- **Read first**: Load all context before taking action (specs, steering, templates, rules)
- **Research when uncertain**: Use WebSearch/WebFetch for external dependencies, APIs, and latest best practices
- **Analyze existing code**: Use Grep to find patterns and integration points in codebase
- **Write last**: Generate design.md only after all research and analysis complete

## Output Description

**Command execution output** (separate from design.md content):

Provide brief summary in the language specified in spec.json:

1. **Status**: Confirm design document generated at `.kiro/specs/$1/design.md`
2. **Discovery Type**: Which discovery process was executed (full/light/minimal)
3. **Key Findings**: 2-3 critical insights from `research.md` that shaped the design
4. **Next Action**: Approval workflow guidance (see Safety & Fallback)
5. **Research Log**: Confirm `research.md` updated with latest decisions

**Format**: Concise Markdown (under 200 words) - this is the command output, NOT the design document itself

**Note**: The actual design document follows `.kiro/settings/templates/specs/design.md` structure.

## Safety & Fallback

### Error Scenarios

**Requirements Not Approved**:
- **Stop Execution**: Cannot proceed without approved requirements
- **User Message**: "Requirements not yet approved. Approval required before design generation."
- **Suggested Action**: "Run `/kiro:spec-design $1 -y` to auto-approve requirements and proceed"

**Missing Requirements**:
- **Stop Execution**: Requirements document must exist
- **User Message**: "No requirements.md found at `.kiro/specs/$1/requirements.md`"
- **Suggested Action**: "Run `/kiro:spec-requirements $1` to generate requirements first"

**Template Missing**:
- **User Message**: "Template file missing at `.kiro/settings/templates/specs/design.md`"
- **Suggested Action**: "Check repository setup or restore template file"
- **Fallback**: Use inline basic structure with warning

**Steering Context Missing**:
- **Warning**: "Steering directory empty or missing - design may not align with project standards"
- **Proceed**: Continue with generation but note limitation in output

**Discovery Complexity Unclear**:
- **Default**: Use full discovery process (`.kiro/settings/rules/design-discovery-full.md`)
- **Rationale**: Better to over-research than miss critical context
- **Invalid Requirement IDs**:
  - **Stop Execution**: If requirements.md is missing numeric IDs or uses non-numeric headings (for example, "Requirement A"), stop and instruct the user to fix requirements.md before continuing.

### Next Phase: Task Generation

**If Design Approved**:
- Review generated design at `.kiro/specs/$1/design.md`
- **Optional**: Run `/kiro:validate-design $1` for interactive quality review
- Then `/kiro:spec-tasks $1 -y` to generate implementation tasks

**If Modifications Needed**:
- Provide feedback and re-run `/kiro:spec-design $1`
- Existing design used as reference (merge mode)

**Note**: Design approval is mandatory before proceeding to task generation.
