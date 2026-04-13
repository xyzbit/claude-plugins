---
name: vibe-motion:promo
description: Create product-level promotional videos and animations using vibe-motion (Remotion). Use when the user wants to build landing page media, mockups, or promotional videos that require 1:1 realistic UI recreation and smooth interactions.
---

# Vibe-Motion Promotional Video Guidelines

## Core Principles

1. **Product-Level Realism**: The goal is NOT to make "conceptual animations" or abstract floating cards. The UI must be a 1:1 pixel-perfect recreation of the real frontend application (SaaS-level quality).
2. **Hybrid Media Strategy**: 
   - Primary focus: Real product UI layouts (borders, shadows, typography, colors).
   - Motion focus: Smooth state-driven transitions, real interaction simulations.
3. **One Core "Aha" Moment**: Each video scene should be short (6-8s) and focus on demonstrating exactly one core value proposition or workflow.

## Mandatory Workflow

**BEFORE writing any code for the UI, you MUST:**
1. **Locate Target UI**: Search the actual frontend repository for the components you are trying to simulate. Use `Glob` or `Grep` tools.
2. **Read Real Source Code**: Read the source code of those components to understand the exact DOM structure, nested layout wrappers, and Tailwind classes used in the real product.
3. **Analyze Element Hierarchy & Metrics**: Pay special attention to parent-child wrapper relationships (e.g., is the Right Panel a sibling to the Editor, or inside a specific main container?), and capture specific arbitrary Tailwind values (like `rounded-[32px]`, `shadow-[-20px_0_40px_...]`).
4. **NEVER Guess**: Do NOT guess or hallucinate the layout, colors, or structural hierarchy based on generic patterns. The UI must match the actual implementation exactly (e.g., using the precise `bg-stone-100` instead of a generic `bg-gray-50`, real icons, and exact border treatments).

## Implementation Methods

### 1. UI Recreation
- **DOM Structure**: Mimic the actual React component structure from the frontend codebase. Replicate the nesting.
- **Styling**: Use exact Tailwind utility classes or inline styles for colors (e.g., `bg-stone-50`, `border-stone-200`, `text-stone-900`), rounded corners (`rounded-xl`), and shadows (`shadow-sm`, `shadow-[...]`).
- **Layout**: Build the complete context. Don't just show an isolated component; show the sidebar, header, and workspace to provide a grounded, realistic environment.

### 2. Animation & Easing
Always use math-based easing functions for fluid, professional motion:

```javascript
// Interpolate between two values based on t (0-1)
const lerp = (a, b, t) => a + (b - a) * Math.max(0, Math.min(1, t));

// Easing functions
const easeOut = (t) => 1 - Math.pow(1 - Math.max(0, Math.min(1, t)), 3);
const easeInOut = (t) => t < 0.5 ? 2 * t * t : 1 - Math.pow(-2 * t + 2, 2) / 2;

// Stagger function for lists/cards
const stagger = (t, index, total, delay = 0.1) => {
  const staggered = t * total - index;
  return Math.max(0, Math.min(1, staggered + delay));
};
```

### 3. Interaction Simulation
To make the video feel like a real product recording:
- **Fake Cursors**: Add an SVG mouse cursor that moves (`lerp` X and Y coordinates) and clicks (`scale(0.9)` on click).
Pay extra attention to whether the click location is correct.
- **Typing Effects**: Simulate text input with a blinking cursor block.
- **Loading States**: Use skeleton screens (`animate-pulse`), spinners, and loading bars before revealing the final content.
- **Camera Work (Zoom/Pan)**: Use a wrapper div with `transform: scale(...) translate(...)` driven by the progress variable to subtly zoom in on the action (e.g., zooming into a specific panel when an action is triggered).

### 4. State-Driven Timeline
Use a normalized progress variable (e.g., `ran` or `progressFill` from `0` to `1`) to drive the entire scene's sequence using mapped time windows.

```javascript
// Example timeline mapping
const isModalVisible = ran < 0.1;
const modalOpacity = isModalVisible ? lerp(1, 0, ran / 0.1) : 0;
const showFirstMsg = ran > 0.2;
const cursorProgress = ran > 0.4 ? Math.min(1, (ran - 0.4) / 0.1) : 0;
```

## Checklist for Scene Creation

- [ ] **MANDATORY**: Did you actively search and read the actual frontend codebase for the target components BEFORE writing the scene?
- [ ] Does the UI match the real frontend code 1:1 (color palette, DOM nesting, exact Tailwind classes)?
- [ ] Is the context complete? (e.g., Sidebar, Header, Main Content Area)
- [ ] Are animations using `easeOut` or `easeInOut` instead of linear transitions?
- [ ] Are there simulated micro-interactions? (Cursor movements, hover states, button clicks, typing)
- [ ] Does the sequence clearly tell a single, impactful story within the 6-8s duration?