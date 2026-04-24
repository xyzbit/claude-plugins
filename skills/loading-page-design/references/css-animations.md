# Loading Page CSS Animation Patterns

## Spinner Animations

### 1. Classic Rotating Spinner
```css
.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top-color: #3498db;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

### 2. Pulsing Dots
```css
.dots {
  display: flex;
  gap: 6px;
}

.dots span {
  width: 10px;
  height: 10px;
  background: #3498db;
  border-radius: 50%;
  animation: pulse 1.4s ease-in-out infinite;
}

.dots span:nth-child(2) { animation-delay: 0.2s; }
.dots span:nth-child(3) { animation-delay: 0.4s; }

@keyframes pulse {
  0%, 100% { transform: scale(0.8); opacity: 0.5; }
  50% { transform: scale(1.2); opacity: 1; }
}
```

### 3. Breathing Circle
```css
.breathing-circle {
  width: 60px;
  height: 60px;
  border: 3px solid #e0e0e0;
  border-radius: 50%;
  animation: breathe 2s ease-in-out infinite;
}

@keyframes breathe {
  0%, 100% {
    transform: scale(1);
    border-color: #e0e0e0;
  }
  50% {
    transform: scale(1.1);
    border-color: #3498db;
  }
}
```

### 4. Dots Bouncing
```css
.bouncing-dots {
  display: flex;
  gap: 8px;
  align-items: center;
}

.bouncing-dots span {
  width: 12px;
  height: 12px;
  background: #9b59b6;
  border-radius: 50%;
  animation: bounce 1.4s ease-in-out infinite;
}

.bouncing-dots span:nth-child(1) { animation-delay: 0s; }
.bouncing-dots span:nth-child(2) { animation-delay: 0.16s; }
.bouncing-dots span:nth-child(3) { animation-delay: 0.32s; }

@keyframes bounce {
  0%, 80%, 100% { transform: translateY(0); }
  40% { transform: translateY(-20px); }
}
```

## Skeleton/Shimmer Animations

### 1. Basic Shimmer
```css
.skeleton {
  background: linear-gradient(
    90deg,
    #f0f0f0 25%,
    #e0e0e0 50%,
    #f0f0f0 75%
  );
  background-size: 200% 100%;
  animation: shimmer 1.5s infinite;
  border-radius: 4px;
}

@keyframes shimmer {
  0% { background-position: 200% 0; }
  100% { background-position: -200% 0; }
}
```

### 2. Fade-in Content
```css
.content-fade-in {
  opacity: 0;
  animation: fadeIn 0.5s ease-out forwards;
}

@keyframes fadeIn {
  to { opacity: 1; }
}
```

### 3. Slide-up Reveal
```css
.slide-up {
  opacity: 0;
  transform: translateY(20px);
  animation: slideUp 0.5s ease-out forwards;
}

@keyframes slideUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

## Progress Bar Animations

### 1. Determinate Progress
```css
.progress-bar {
  width: 100%;
  height: 8px;
  background: #e0e0e0;
  border-radius: 4px;
  overflow: hidden;
}

.progress-fill {
  height: 100%;
  background: linear-gradient(90deg, #3498db, #2ecc71);
  border-radius: 4px;
  transition: width 0.3s ease-out;
}
```

### 2. Indeterminate Progress
```css
.indeterminate-progress {
  height: 4px;
  background: #e0e0e0;
  border-radius: 2px;
  overflow: hidden;
}

.indeterminate-progress::before {
  content: '';
  display: block;
  width: 30%;
  height: 100%;
  background: #3498db;
  animation: indeterminate 1.5s ease-in-out infinite;
}

@keyframes indeterminate {
  0% { transform: translateX(-100%); }
  100% { transform: translateX(400%); }
}
```

### 3. Striped Progress
```css
.striped-progress {
  height: 10px;
  background: repeating-linear-gradient(
    45deg,
    #3498db,
    #3498db 10px,
    #2980b9 10px,
    #2980b9 20px
  );
  background-size: 28.28px 28.28px;
  animation: stripes 1s linear infinite;
}

@keyframes stripes {
  0% { background-position: 0 0; }
  100% { background-position: 28.28px 0; }
}
```

## Reduced Motion Support

```css
@media (prefers-reduced-motion: reduce) {
  .spinner,
  .dots span,
  .skeleton,
  .progress-fill::before {
    animation: none !important;
    transition: none !important;
  }

  .skeleton {
    background: #e0e0e0;
  }

  .spinner {
    opacity: 0.6;
  }
}
```
