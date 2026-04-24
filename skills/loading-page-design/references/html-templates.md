# Loading Page HTML Templates

## 1. Full Page Brand Loader

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Loading</title>
  <style>
    .loading-page {
      position: fixed;
      inset: 0;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #ffffff;
      z-index: 9999;
      transition: opacity 0.5s ease-out;
    }

    .loading-content {
      text-align: center;
    }

    .loading-logo {
      width: 80px;
      height: 80px;
      margin: 0 auto 24px;
      /* Replace with your logo */
      background: #3498db;
      border-radius: 16px;
    }

    .loading-text {
      color: #666;
      font-family: system-ui, sans-serif;
      font-size: 14px;
      margin-top: 16px;
    }

    .spinner {
      width: 40px;
      height: 40px;
      margin: 0 auto;
      border: 3px solid #f0f0f0;
      border-top-color: #3498db;
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    .loading-page.fade-out {
      opacity: 0;
      pointer-events: none;
    }

    @media (prefers-reduced-motion: reduce) {
      .spinner { animation: none; opacity: 0.6; }
    }
  </style>
</head>
<body>
  <div class="loading-page" role="status" aria-live="polite">
    <div class="loading-content">
      <div class="loading-logo"></div>
      <div class="spinner"></div>
      <p class="loading-text">Loading...</p>
    </div>
  </div>

  <script>
    // Hide loading page when content is ready
    window.addEventListener('load', () => {
      setTimeout(() => {
        document.querySelector('.loading-page').classList.add('fade-out');
        setTimeout(() => {
          document.querySelector('.loading-page').remove();
        }, 500);
      }, 500);
    });
  </script>
</body>
</html>
```

## 2. Skeleton Card Loader

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Skeleton Loading</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: system-ui, sans-serif;
      background: #f5f5f5;
      padding: 20px;
    }

    .skeleton-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 20px;
      max-width: 1200px;
      margin: 0 auto;
    }

    .skeleton-card {
      background: white;
      border-radius: 12px;
      padding: 20px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    }

    .skeleton-img {
      width: 100%;
      height: 160px;
      background: #f0f0f0;
      border-radius: 8px;
    }

    .skeleton-title {
      height: 20px;
      width: 70%;
      background: #f0f0f0;
      border-radius: 4px;
      margin: 16px 0 12px;
    }

    .skeleton-text {
      height: 14px;
      width: 100%;
      background: #f0f0f0;
      border-radius: 4px;
      margin: 8px 0;
    }

    .skeleton-text:last-child {
      width: 60%;
    }

    .skeleton {
      background: linear-gradient(
        90deg,
        #f0f0f0 25%,
        #e8e8e8 50%,
        #f0f0f0 75%
      );
      background-size: 200% 100%;
      animation: shimmer 1.5s infinite;
    }

    @keyframes shimmer {
      0% { background-position: 200% 0; }
      100% { background-position: -200% 0; }
    }

    @media (prefers-reduced-motion: reduce) {
      .skeleton {
        animation: none;
        background: #e0e0e0;
      }
    }
  </style>
</head>
<body>
  <div class="skeleton-grid">
    <div class="skeleton-card">
      <div class="skeleton-img skeleton"></div>
      <div class="skeleton-title skeleton"></div>
      <div class="skeleton-text skeleton"></div>
      <div class="skeleton-text skeleton"></div>
      <div class="skeleton-text skeleton"></div>
    </div>
    <!-- Repeat skeleton-card for more items -->
  </div>
</body>
</html>
```

## 3. Progress Bar with Steps

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Step Progress</title>
  <style>
    .step-progress {
      max-width: 400px;
      margin: 40px auto;
      padding: 20px;
    }

    .progress-container {
      display: flex;
      justify-content: space-between;
      position: relative;
      margin-bottom: 40px;
    }

    .progress-line {
      position: absolute;
      top: 15px;
      left: 0;
      right: 0;
      height: 4px;
      background: #e0e0e0;
      z-index: 1;
    }

    .progress-fill {
      position: absolute;
      top: 15px;
      left: 0;
      height: 4px;
      background: #3498db;
      z-index: 2;
      transition: width 0.3s ease-out;
    }

    .step {
      position: relative;
      z-index: 3;
      width: 30px;
      height: 30px;
      background: #e0e0e0;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      font-weight: 600;
      font-size: 14px;
      color: #999;
      transition: all 0.3s ease;
    }

    .step.active {
      background: #3498db;
      color: white;
    }

    .step.completed {
      background: #2ecc71;
      color: white;
    }

    .step-labels {
      display: flex;
      justify-content: space-between;
      margin-top: 8px;
    }

    .step-label {
      font-size: 12px;
      color: #666;
      text-align: center;
      width: 60px;
    }

    .step-label.active {
      color: #3498db;
      font-weight: 600;
    }
  </style>
</head>
<body>
  <div class="step-progress">
    <div class="progress-container">
      <div class="progress-line"></div>
      <div class="progress-fill" id="progressFill"></div>
      <div class="step active" data-step="1">1</div>
      <div class="step" data-step="2">2</div>
      <div class="step" data-step="3">3</div>
      <div class="step" data-step="4">4</div>
    </div>
    <div class="step-labels">
      <span class="step-label active">Account</span>
      <span class="step-label">Profile</span>
      <span class="step-label">Payment</span>
      <span class="step-label">Confirm</span>
    </div>
  </div>

  <script>
    function updateProgress(currentStep) {
      const totalSteps = 4;
      const percent = ((currentStep - 1) / (totalSteps - 1)) * 100;
      document.getElementById('progressFill').style.width = percent + '%';

      document.querySelectorAll('.step').forEach((step, index) => {
        const stepNum = index + 1;
        step.classList.remove('active', 'completed');
        if (stepNum < currentStep) {
          step.classList.add('completed');
        } else if (stepNum === currentStep) {
          step.classList.add('active');
        }
      });
    }
  </script>
</body>
</html>
```

## 4. Button Loading State

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Button Loading</title>
  <style>
    .btn {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 12px 24px;
      font-size: 16px;
      font-weight: 600;
      border: none;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .btn-primary {
      background: #3498db;
      color: white;
    }

    .btn-primary:hover {
      background: #2980b9;
    }

    .btn:disabled {
      opacity: 0.7;
      cursor: not-allowed;
    }

    .btn-spinner {
      width: 18px;
      height: 18px;
      border: 2px solid rgba(255,255,255,0.3);
      border-top-color: white;
      border-radius: 50%;
      animation: spin 0.6s linear infinite;
      display: none;
    }

    .btn.loading .btn-spinner {
      display: block;
    }

    .btn.loading .btn-text {
      display: none;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }
  </style>
</head>
<body>
  <button class="btn btn-primary" id="loadingBtn">
    <span class="btn-text">Submit</span>
    <span class="btn-spinner"></span>
  </button>

  <script>
    const btn = document.getElementById('loadingBtn');

    btn.addEventListener('click', () => {
      btn.classList.add('loading');
      btn.disabled = true;

      // Simulate API call
      setTimeout(() => {
        btn.classList.remove('loading');
        btn.disabled = false;
      }, 2000);
    });
  </script>
</body>
</html>
```

## 5. Inline Dot Loader

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Inline Loading</title>
  <style>
    .inline-loading {
      display: inline-flex;
      align-items: center;
      gap: 6px;
    }

    .inline-loading span {
      width: 8px;
      height: 8px;
      background: #3498db;
      border-radius: 50%;
      animation: pulse 1.4s ease-in-out infinite;
    }

    .inline-loading span:nth-child(2) { animation-delay: 0.16s; }
    .inline-loading span:nth-child(3) { animation-delay: 0.32s; }

    @keyframes pulse {
      0%, 80%, 100% { transform: scale(0.6); opacity: 0.4; }
      40% { transform: scale(1); opacity: 1; }
    }

    @media (prefers-reduced-motion: reduce) {
      .inline-loading span { animation: none; opacity: 0.4; }
    }
  </style>
</head>
<body>
  <div style="padding: 40px; text-align: center;">
    <p>Loading content <span class="inline-loading"><span></span><span></span><span></span></span></p>
  </div>
</body>
</html>
```
