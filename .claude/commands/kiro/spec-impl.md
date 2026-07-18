---
description: Execute spec tasks using TDD methodology
allowed-tools: Bash, Read, Write, Edit, MultiEdit, Grep, Glob, LS, WebFetch, WebSearch
argument-hint: <feature-name> [task-numbers]
---

# Implementation Task Executor

<background_information>
- **Mission**: Execute implementation tasks using Test-Driven Development methodology based on approved specifications
- **Success Criteria**:
  - All tests written before implementation code
  - Code passes all tests with no regressions
  - Tasks marked as completed in tasks.md
  - Implementation aligns with design and requirements
</background_information>

<instructions>
## Core Task
Execute implementation tasks for feature **$1** using Test-Driven Development.

## Execution Steps

### Step 1: Load Context

**Read all necessary context**:
- `.kiro/specs/$1/spec.json`, `requirements.md`, `design.md`, `tasks.md`
- **Entire `.kiro/steering/` directory** for complete project memory
- `flutter-clean-architecture-guide.md` (repo root) — the project's binding Flutter Clean Architecture & TDD standard. Every rule in it is mandatory unless marked "guideline." Its §9 PR Review Checklist is the implementation-time acceptance bar
- `design.md` (repo root, the UI design system) — read it before implementing any screen/page/widget task; every color/typography/spacing/radius/elevation value must come from its tokens/components via the project's typed design-token classes, never a hardcoded literal

**Validate approvals**:
- Verify tasks are approved in spec.json (stop if not, see Safety & Fallback)

### Step 2: Select Tasks

**Determine which tasks to execute**:
- If `$2` provided: Execute specified task numbers (e.g., "1.1" or "1,2,3")
- Otherwise: Execute all pending tasks (unchecked `- [ ]` in tasks.md)

### Step 3: Execute with TDD

For each selected task, follow Kent Beck's TDD cycle:

1. **RED - Write Failing Test**:
   - Write test for the next small piece of functionality
   - Test should fail (code doesn't exist yet)
   - Use descriptive test names

2. **GREEN - Write Minimal Code**:
   - Implement simplest solution to make test pass
   - Focus only on making THIS test pass
   - Avoid over-engineering

3. **REFACTOR - Clean Up**:
   - Improve code structure and readability
   - Remove duplication
   - Apply design patterns where appropriate
   - Ensure all tests still pass after refactoring

4. **VERIFY - Validate Quality**:
   - All tests pass (new and existing)
   - No regressions in existing functionality
   - Code coverage maintained or improved

5. **MARK COMPLETE**:
   - Update checkbox from `- [ ]` to `- [x]` in tasks.md

## Critical Constraints
- **TDD Mandatory**: Tests MUST be written before implementation code
- **Task Scope**: Implement only what the specific task requires
- **Test Coverage**: All new code must have tests
- **No Regressions**: Existing tests must continue to pass
- **Design Alignment**: Implementation must follow design.md specifications
- **Type Safety** (Dart/Flutter): No `dynamic` anywhere; no `Object?` as a stand-in type; no `Map<String, dynamic>` crossing layer boundaries (only inside `fromJson`/`toJson` at the Model boundary); every variable declaration, function/method parameter, and return type explicit and concrete
- **Naming**: Every class, variable, field, parameter, and function name is verbose and contextual — describes precisely what it holds or does
- **Mocking**: `mocktail` only — never `mockito`, never positional `when(x.method())`
- **Architecture Boundaries**: Respect `domain`/`data`/`presentation` dependency direction; Bloc/Cubit's only public surface is `state`; DataSource is the only layer allowed to `throw`
- **UI/Visual Design**: Any widget/screen/page pulls colors, typography, spacing, radius, and elevation from `design.md` (repo root) tokens/components via typed constants — never an inline hex value, raw px number, or ad hoc font size/weight; flag anything not covered by `design.md`
</instructions>

## Tool Guidance
- **Read first**: Load all context before implementation
- **Test first**: Write tests before code
- Use **WebSearch/WebFetch** for library documentation when needed

## Output Description

Provide brief summary in the language specified in spec.json:

1. **Tasks Executed**: Task numbers and test results
2. **Status**: Completed tasks marked in tasks.md, remaining tasks count

**Format**: Concise (under 150 words)

## Safety & Fallback

### Error Scenarios

**Tasks Not Approved or Missing Spec Files**:
- **Stop Execution**: All spec files must exist and tasks must be approved
- **Suggested Action**: "Complete previous phases: `/kiro:spec-requirements`, `/kiro:spec-design`, `/kiro:spec-tasks`"

**Test Failures**:
- **Stop Implementation**: Fix failing tests before continuing
- **Action**: Debug and fix, then re-run

### Task Execution

**Execute specific task(s)**:
- `/kiro:spec-impl $1 1.1` - Single task
- `/kiro:spec-impl $1 1,2,3` - Multiple tasks

**Execute all pending**:
- `/kiro:spec-impl $1` - All unchecked tasks
