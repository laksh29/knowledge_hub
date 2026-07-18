# Agentic SDLC and Spec-Driven Development

Kiro-style Spec-Driven Development on an agentic SDLC

## Project Context

### Paths
- Steering: `.kiro/steering/`
- Specs: `.kiro/specs/`
- Coding standard: `flutter-clean-architecture-guide.md` (repo root)

### Coding Standard

This is a Flutter app. `flutter-clean-architecture-guide.md` at the repo root is the binding Clean Architecture & TDD standard — every rule in it is mandatory unless it explicitly says "guideline." `.kiro/steering/tech.md` and `.kiro/steering/structure.md` summarize it for quick reference, but the guide itself (code-level patterns, worked examples, §9 PR review checklist) must be read directly by any command that designs, generates tasks for, implements, or reviews code. Non-negotiable, project-wide on top of the guide:
- Never use `dynamic` or `Object?` as a stand-in type.
- Never use `Map<String, dynamic>` across layers — only inside `fromJson`/`toJson` at the Model boundary. Use a typed Model/Entity/ViewModel instead.
- Every variable declaration, function/method parameter, and return type is explicit and concrete.
- Every class, variable, field, parameter, and function name is verbose and contextual.

### Steering vs Specification

**Steering** (`.kiro/steering/`) - Guide AI with project-wide rules and context
**Specs** (`.kiro/specs/`) - Formalize development process for individual features

### Active Specifications
- Check `.kiro/specs/` for active specifications
- Use `/kiro:spec-status [feature-name]` to check progress

## Development Guidelines
- Think in English, generate responses in English. All Markdown content written to project files (e.g., requirements.md, design.md, tasks.md, research.md, validation reports) MUST be written in the target language configured for this specification (see spec.json.language).

## Minimal Workflow
- Phase 0 (optional): `/kiro:steering`, `/kiro:steering-custom`
- Phase 1 (Specification):
  - `/kiro:spec-init "description"`
  - `/kiro:spec-requirements {feature}`
  - `/kiro:validate-gap {feature}` (optional: for existing codebase)
  - `/kiro:spec-design {feature} [-y]`
  - `/kiro:validate-design {feature}` (optional: design review)
  - `/kiro:spec-tasks {feature} [-y]`
- Phase 2 (Implementation): `/kiro:spec-impl {feature} [tasks]`
  - `/kiro:validate-impl {feature}` (optional: after implementation)
- Progress check: `/kiro:spec-status {feature}` (use anytime)

## Development Rules
- 3-phase approval workflow: Requirements → Design → Tasks → Implementation
- Human review required each phase; use `-y` only for intentional fast-track
- Keep steering current and verify alignment with `/kiro:spec-status`
- Follow the user's instructions precisely, and within that scope act autonomously: gather the necessary context and complete the requested work end-to-end in this run, asking questions only when essential information is missing or the instructions are critically ambiguous.

## Steering Configuration
- Load entire `.kiro/steering/` as project memory
- Default files: `product.md`, `tech.md`, `structure.md`
- Custom files are supported (managed via `/kiro:steering-custom`)
