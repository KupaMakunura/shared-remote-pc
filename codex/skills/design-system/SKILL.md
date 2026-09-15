---
name: design-system
description: Applies this repo's DESIGN.md as the source of truth for UI design and shadcn implementation. Use when creating, refactoring, reviewing, or polishing pages, components, Tailwind theme tokens, shadcn compositions, forms, cards, navigation, pricing, product mockups, waitlists, or footers that must match the current documented visual system.
---

# Design System

Use this skill to make UI match `DESIGN.md`. The design file is authoritative; this skill is only the workflow for applying it.

## Source Order

1. Read `DESIGN.md` before changing UI.
2. Extract the current `name`, `description`, `colors`, `typography`, `rounded`, `spacing`, `components`, responsive rules, and do/don't rules from `DESIGN.md`.
3. If a rule in this skill conflicts with `DESIGN.md`, follow `DESIGN.md`.
4. If the work uses shadcn, also load the `shadcn` skill and follow its component, CLI, import, accessibility, and composition rules.
5. For Next.js work, read the relevant guide under `node_modules/next/dist/docs/` before writing code.

## Apply DESIGN.md

Before implementation, summarize the active design contract from `DESIGN.md` in your own working notes:

- Page mood and product category from the frontmatter `description`.
- Primary surfaces and text colors from `colors`.
- Display/body font families, sizes, weights, line heights, letter spacing, and font-feature settings from `typography`.
- Radius scale from `rounded`.
- Spacing rhythm from `spacing`.
- Component recipes from `components`.
- Layout and breakpoint behavior from the responsive section.
- Specific constraints from the do/don't and iteration sections.

Do not carry visual assumptions across turns. `DESIGN.md` may be replaced with a different design system, so reload it each time this skill is used.

## shadcn Implementation Rules

- Use shadcn components as the base primitive: `Button`, `Card`, `Tabs`, `Accordion`, `Input`, `Select`, `Dialog`, `Sheet`, `Badge`, `Separator`, `Skeleton`, `Empty`, and related composition APIs.
- Map `DESIGN.md` tokens into semantic Tailwind/shadcn variables first: `bg-background`, `text-foreground`, `text-muted-foreground`, `bg-card`, `border-border`, `ring-ring`, `bg-primary`, `text-primary-foreground`, and related CSS variables.
- Do not scatter raw hex values through feature code when a token or semantic variable can carry the decision.
- Put shared visual decisions in the global CSS theme, component variants, or established wrappers.
- Preserve shadcn composition: `CardHeader`/`CardTitle`/`CardDescription`/`CardContent`/`CardFooter`, accessible dialog/sheet titles, tab triggers inside tab lists, avatar fallbacks, field validation attributes, and icon conventions.
- Use the project package runner for shadcn CLI commands. Check existing installed components before adding new ones.
- Use the configured icon library from `components.json`; do not assume lucide unless the project is configured for lucide.

## Workflow

1. Identify the UI surface: marketing page, app workflow, dashboard, form, table, navigation, modal, or empty/loading/error state.
2. Read all relevant `DESIGN.md` sections for that surface.
3. Check installed shadcn component files before importing or adding components.
4. Update theme tokens before building feature-level UI when the current theme does not match `DESIGN.md`.
5. Compose the UI from shadcn primitives and add custom markup only for brand-specific layout, product mockups, visual assets, or display treatments not covered by shadcn.
6. Verify responsive behavior against the current `DESIGN.md` breakpoints and collapsing strategy.
7. Run the project checks that match the change, at minimum TypeScript and any relevant lint/test command available in the repo.

## Implementation Checklist

- Buttons match the relevant `{components.button-*}` token for color, radius, padding, typography, and state.
- Cards match the relevant `{components.*card*}` token for surface, radius, padding, and hierarchy.
- Inputs match `{components.text-input}` and focused/invalid states when documented.
- Navigation and footer match their component tokens and responsive behavior.
- Typography uses the documented token for each text role, including letter spacing and line height.
- Visual assets reveal the actual product, object, or state when `DESIGN.md` calls for product mockups or showcase tiles.
- Accent colors are used only where `DESIGN.md` permits them.

## Do

- Use `DESIGN.md` token references and component names when reasoning about UI.
- Keep edits consistent with the current `DESIGN.md`, even if it differs from previous versions.
- Prefer semantic theme variables over ad hoc utilities.
- Preserve shadcn accessibility and composition rules.
- Check mobile and desktop layouts for text overflow, crowding, and broken hierarchy.

## Don't

- Do not hardcode a brand style in this skill.
- Do not preserve stale colors, fonts, radii, or layout rules after `DESIGN.md` changes.
- Do not bypass shadcn primitives for UI that already exists in the component library.
- Do not invent extra modes, accents, gradients, hover states, or surfaces unless `DESIGN.md` supports them.
- Do not create a separate design-token system alongside the existing theme CSS.
