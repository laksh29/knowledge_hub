# UI Design System

## Source of Truth

`design.md` (repo root) is the binding visual design system for every screen, page, and widget in this app — colors, typography, spacing, radius, elevation, and component specs. Any design, task, or implementation work touching the `presentation` layer must read `design.md` directly and derive values from it; this file only condenses it for quick reference.

**Rule**: no UI component invents its own hex color, raw px value, or ad hoc font size/weight. Every visual value traces back to a `design.md` token (`{colors.*}`, `{typography.*}`, `{spacing.*}`, `{rounded.*}`, `{component.*}`) surfaced through a typed Dart constants/theme class (this project's equivalent of `ScapiaColors`/`ScapiaStyles`) — never a hardcoded literal inline in a widget.

## Token Categories (see `design.md` for full values)

- **Colors** (`{colors.*}`): brand/accent (primary, primary-active, primary-disabled), surface (canvas, surface-soft, surface-strong), hairlines/borders, text (ink, body, muted, muted-soft, on-primary), semantic (error states, legal links), scrim.
- **Typography** (`{typography.*}`): a fixed hierarchy table (display, title, body, caption, badge, button, link, nav-link sizes/weights/line-height/letter-spacing) — pick the closest matching token rather than choosing a new size.
- **Layout** (`{spacing.*}`): 4px base unit scale (`xxs`…`section`), grid/container max-widths, gutters — reuse the scale, don't introduce new spacing values.
- **Elevation**: effectively one shadow tier plus flat baseline — do not invent progressive shadow levels.
- **Radius** (`{rounded.*}`): sm/md/full/xl — shape language is soft; avoid hard corners outside the documented tokens.
- **Components** (`{component.*}`): named, pre-specified components (buttons, search surface, nav, cards, forms, footer) with concrete dimensions/padding/states — reuse the closest existing component spec before designing a new one.
- **Responsive breakpoints**: Mobile / Tablet / Desktop / Wide, with documented collapsing strategy per component.

## How This Applies Per Phase

- **Design (`/kiro:spec-design`)**: any component in Components & Interfaces that renders UI must cite the `design.md` tokens/components it uses (or explicitly note a documented gap from `design.md`'s "Known Gaps" section and how it's resolved).
- **Tasks (`/kiro:spec-tasks`)**: UI-related tasks reference the specific `design.md` component/token names in their detail bullets so implementers don't reinvent values.
- **Implementation (`/kiro:spec-impl`)**: widgets pull colors/typography/spacing/radius/elevation from the project's typed design-token classes (derived from `design.md`), never inline literals; new visual patterns not covered by `design.md` must be flagged, not silently invented.

## Known Gaps (from `design.md`)

`design.md` explicitly documents its own gaps (hover states, loading/skeleton screens, map styling, form error outline+helper-text combo, Luxe/Plus sub-brand systems). When a task needs one of these, treat it as an open design decision — flag it for explicit resolution rather than guessing a value that looks plausible.

---
_This file is a pointer and condensed index. Read `design.md` directly for exact hex values, the full typography table, and component specs before designing, task-planning, or implementing any UI._
