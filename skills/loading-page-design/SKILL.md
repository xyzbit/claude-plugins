---
name: loading-page-design
description: Design and create loading pages, loading animations, progress indicators, skeleton screens, and loading spinners. Use this skill whenever the user wants to create a loading page, loading spinner, progress bar, skeleton loader, or any loading state UI. This includes splash screens, brand loading pages, inline loading indicators, and suspense/shimmer loading states. Make sure to use this skill when the user mentions loading states, wait screens, loading animations, progress indicators, or skeleton loaders — even if they don't explicitly ask for a "loading page."
---

# Loading Page Design Skill

Design beautiful, performant loading pages that provide excellent user experience while users wait for content to load.

## Core Principles

### 1. Set Clear Expectations
Users should always know:
- Something is happening
- How long they might wait (if predictable)
- What is being loaded

### 2. Keep It Engaging
- Use smooth, purposeful animations
- Show branded visual elements
- Provide feedback through progress indicators

### 3. Performance First
- Loading page itself must load fast
- Use CSS animations over JavaScript where possible
- Keep the loading UI lightweight

## Loading Page Types

### Full Page Loader
Covers the entire viewport during initial page load. Best for:
- Critical path loading
- App initialization
- Heavy content pages

### Skeleton Screen
Shows a wireframeplaceholder structure of content loading. Best for:
- Feed/list content
- Card-based layouts
- Dynamic data tables

### Inline Loader
Small indicator within existing content. Best for:
- Button loading states
- Form submissions
- Section refreshes

### Progress Bar
Shows percentage or steps complete. Best for:
- File uploads/downloads
- Multi-step processes
- Known-duration operations

## Animation Guidelines

### Spinner Animations
```css
/* Classic rotating spinner */
@keyframes spin {
  to { transform: rotate(360deg); }
}

/* Pulsing dots */
@keyframes pulse {
  0%, 100% { opacity: 0.4; }
  50% { opacity: 1; }
}
```

### Skeleton/Shimmer Effect
```css
@keyframes shimmer {
  0% { background-position: -200% 0; }
  100% { background-position: 200% 0; }
}

.skeleton {
  background: linear-gradient(
    90deg,
    #f0f0f0 25%,
    #e0e0e0 50%,
    #f0f0f0 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
}
```

### Progress Bar
```css
@keyframes progress {
  0% { width: 0%; }
  100% { width: var(--progress, 100%); }
}
```

## Design Patterns

### Pattern 1: Minimal Dot Spinner
- 3-4 dots in a row
- Sequential pulse animation
- Subtle, non-distracting
- Use case: Inline loading, small spaces

### Pattern 2: Branded Splash Loader
- Full viewport
- Centered logo
- Optional tagline
- Subtle background animation
- Use case: App launch, brand moment

### Pattern 3: Progress Stepper
- Shows current step / total steps
- Step labels below
- Percentage optional
- Use case: Onboarding, multi-step forms

### Pattern 4: Skeleton with Content Hint
- Shows content structure
- Rounded rectangles for text lines
- Circular placeholders for avatars/images
- Subtle shimmer animation
- Use case: Feed loading, card grids

### Pattern 5: Infinity Loader
- Continuous flowing animation
- Brand color gradient
- Use case: Background processing, long waits

## Color Guidelines

- **Primary**: Your brand color (for progress/spinner)
- **Secondary**: Lighter shade of primary (for skeleton background)
- **Background**: White or very light gray (#fafafa or #f5f5f5)
- **Text**: Dark gray (#333) for loading text
- **Subtle**: Light gray (#e0e0e0) for skeleton shapes

## Accessibility

1. **Reduced Motion**: Always respect `prefers-reduced-motion`
   ```css
   @media (prefers-reduced-motion: reduce) {
     *, *::before, *::after {
       animation-duration: 0.01ms !important;
       animation-iteration-count: 1 !important;
     }
   }
   ```

2. **Screen Readers**: Include `aria-live="polite"` for dynamic loading states

3. **Color Contrast**: Ensure text on loading screens meets WCAG AA

4. **Focus Management**: Don't trap focus in loading overlay

## Output Format

When designing a loading page, always provide:

1. **HTML Structure** - Semantic, accessible markup
2. **CSS Styles** - Responsive, animation-friendly
3. **JavaScript** (if needed) - For progress updates, simulated loading

### Example Output Structure
```html
<!-- Loading Page -->
<div class="loading-page" role="status" aria-live="polite">
  <div class="loading-content">
    <!-- Logo/Brand -->
    <div class="loading-logo"></div>

    <!-- Progress/Spinner -->
    <div class="loading-indicator">
      <div class="spinner"></div>
    </div>

    <!-- Optional Text -->
    <p class="loading-text">Loading your content...</p>
  </div>
</div>
```

## Implementation Checklist

- [ ] Loading page renders immediately (critical)
- [ ] Animation is smooth (60fps target)
- [ ] Works with `prefers-reduced-motion`
- [ ] Has proper ARIA attributes
- [ ] Shows meaningful content structure for skeleton loaders
- [ ] Uses brand colors appropriately
- [ ] Responsive on mobile devices
- [ ] Loading page itself loads < 50KB total
