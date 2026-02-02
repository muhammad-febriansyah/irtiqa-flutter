# Flutter UI Implementation Guide - IRTIQA

## ✅ What Has Been Completed

### 1. Splash Screen ✨
**File:** `lib/app/modules/splash/`

**Features:**
- ✅ Animated logo with fade-in and scale effect
- ✅ App branding with gradient background
- ✅ Loading indicator
- ✅ Auto-navigation based on auth status
- ✅ 2-second delay for smooth UX

**Controller Features:**
- Check if user is logged in
- Validate token by fetching user data
- Auto-redirect to home if authenticated
- Auto-redirect to login if not authenticated

**Screenshot:** Purple gradient background with crescent moon & star logo

---

### 2. Login Screen 🔐
**File:** `lib/app/modules/login/`

**Features:**
- ✅ Clean, modern UI design
- ✅ Email and password input fields
- ✅ Password visibility toggle
- ✅ Form validation
- ✅ Loading state during API call
- ✅ Forgot password link (placeholder)
- ✅ Link to register screen
- ✅ Error handling with snackbar notifications
- ✅ Full API integration

**Controller Features:**
- Form validation
- API integration with AuthRepository
- Token auto-save
- Error handling
- Auto-navigation on success

**Screenshot:** White background, logo at top, purple accent color

---

### 3. Register Screen 📝
**File:** `lib/app/modules/register/`

**Features:**
- ✅ Full name, email, password, confirm password fields
- ✅ Password visibility toggles for both fields
- ✅ Terms & conditions checkbox
- ✅ Comprehensive form validation
- ✅ Loading state during registration
- ✅ Success/error notifications
- ✅ Link back to login screen
- ✅ Full API integration

**Controller Features:**
- Multi-field validation
- Password strength validation (min 8 chars)
- Password match validation
- Email format validation
- Terms acceptance validation
- API integration with AuthRepository
- Detailed error messages
- Auto-navigation on success

**Screenshot:** Scrollable form with all fields, purple CTA button

---

## 🎨 Design System

### Color Palette
```dart
Primary Color:     #4F46E5 (Indigo-600)
Background:        #FFFFFF (White)
Text Primary:      #1F2937 (Gray-800)
Text Secondary:    #6B7280 (Gray-500)
Border:            #E5E7EB (Gray-200)
Error:             #EF4444 (Red-500)
Success:           #10B981 (Green-500)
```

### Typography
- **Heading 1:** 32px, Bold (Welcome messages)
- **Heading 2:** 24px, Bold (Section titles)
- **Body:** 16px, Regular
- **Button:** 16px, SemiBold
- **Caption:** 14px, Regular

### Spacing
- Screen padding: 24px
- Input field gap: 16px
- Section gap: 24px
- Logo margin: 20-30px

### Components
- **Input Fields:** Rounded corners (12px), outlined style
- **Buttons:** Full-width, 56px height, rounded (12px)
- **Logo:** 80-150px depending on screen
- **Icons:** Iconsax icon pack

---

## 📱 Assets Setup

### Logo
**Location:** `assets/images/logo.svg`

**Design:** Islamic-themed logo with:
- Gradient purple background (#4F46E5 → #7C3AED)
- White crescent moon and star
- "IRTIQA" text

**To Replace Logo:**
1. Replace `assets/images/logo.svg` with your own logo
2. Supported formats: SVG (recommended), PNG
3. Recommended size: 200x200px minimum
4. Keep 1:1 aspect ratio

---

## 🚀 Running the App

### 1. Install Dependencies
```bash
cd /applications/mobile/irtiqa
flutter pub get
```

### 2. Configure API Endpoint
Edit `.env` file:
```bash
# For local development
API_BASE_URL=http://localhost:8000/api/v1

# For Android emulator
API_BASE_URL=http://10.0.2.2:8000/api/v1

# For iOS simulator
API_BASE_URL=http://localhost:8000/api/v1

# For real device (use your computer's IP)
API_BASE_URL=http://192.168.1.100:8000/api/v1
```

### 3. Start Laravel Backend
```bash
cd /Applications/laravel/irtiqa
php artisan serve
```

### 4. Run Flutter App
```bash
# Check available devices
flutter devices

# Run on specific device
flutter run -d <device-id>

# Or just run (will prompt for device)
flutter run
```

---

## 🧪 Testing the Flow

### Complete User Journey:

1. **First Launch**
   - App opens on Splash Screen
   - Shows logo with animation (2 seconds)
   - Auto-navigates to Login (not authenticated)

2. **Register New Account**
   - Tap "Sign Up" on Login screen
   - Fill in all fields:
     - Name: John Doe
     - Email: john@example.com
     - Password: password123
     - Confirm: password123
   - Check "Accept Terms"
   - Tap "Sign Up"
   - Success: redirected to Home
   - Token saved automatically

3. **Logout & Login**
   - Logout from app (implement in Home screen)
   - App returns to Login
   - Enter credentials
   - Tap "Sign In"
   - Success: redirected to Home

4. **Auto-Login**
   - Close app completely
   - Reopen app
   - Splash screen checks token
   - If valid: auto-navigate to Home
   - If expired: navigate to Login

---

## 📋 Validation Rules

### Login
- Email: Required, valid email format
- Password: Required

### Register
- Name: Required, trimmed
- Email: Required, valid email format
- Password: Required, minimum 8 characters
- Confirm Password: Required, must match password
- Terms: Must be accepted

---

## 🎯 Features Implemented

### API Integration
- ✅ Register with API
- ✅ Login with API
- ✅ Token management (save/retrieve/delete)
- ✅ Auto token injection in headers
- ✅ 401 handling (auto logout)
- ✅ Error handling with user-friendly messages

### UI/UX
- ✅ Responsive design
- ✅ Loading states
- ✅ Form validation
- ✅ Password visibility toggles
- ✅ Smooth animations
- ✅ Error notifications (snackbar)
- ✅ Success notifications (snackbar)

### Navigation
- ✅ Splash → Login/Home
- ✅ Login → Register
- ✅ Login → Home (on success)
- ✅ Register → Login
- ✅ Register → Home (on success)

---

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── app/
│   ├── core/
│   │   └── api_client.dart           # Dio HTTP client
│   ├── data/
│   │   ├── models/
│   │   │   └── user_model.dart       # User & Profile models
│   │   ├── providers/
│   │   │   └── auth_provider.dart    # Auth API endpoints
│   │   └── repositories/
│   │       └── auth_repository.dart  # Auth business logic
│   ├── modules/
│   │   ├── splash/
│   │   │   ├── controllers/
│   │   │   │   └── splash_controller.dart
│   │   │   ├── bindings/
│   │   │   │   └── splash_binding.dart
│   │   │   └── views/
│   │   │       └── splash_view.dart
│   │   ├── login/
│   │   │   ├── controllers/
│   │   │   │   └── login_controller.dart
│   │   │   ├── bindings/
│   │   │   │   └── login_binding.dart
│   │   │   └── views/
│   │   │       └── login_view.dart
│   │   ├── register/
│   │   │   ├── controllers/
│   │   │   │   └── register_controller.dart
│   │   │   ├── bindings/
│   │   │   │   └── register_binding.dart
│   │   │   └── views/
│   │   │       └── register_view.dart
│   │   └── home/
│   │       └── ... (to be implemented)
│   └── routes/
│       ├── app_pages.dart            # Route definitions
│       └── app_routes.dart           # Route constants
└── assets/
    └── images/
        └── logo.svg                   # App logo
```

---

## 🔧 Customization Guide

### Change Primary Color
Update in all files:
```dart
// Old: Color(0xFF4F46E5)
// New: Color(0xYOURCOLOR)
```

Files to update:
- `splash_view.dart`
- `login_view.dart`
- `register_view.dart`

### Change Logo
1. Replace `assets/images/logo.svg`
2. Update in `pubspec.yaml` if different format
3. No code changes needed

### Add Custom Font
1. Add font files to `assets/fonts/`
2. Update `pubspec.yaml`:
```yaml
fonts:
  - family: YourFont
    fonts:
      - asset: assets/fonts/YourFont-Regular.ttf
      - asset: assets/fonts/YourFont-Bold.ttf
        weight: 700
```
3. Use in code:
```dart
style: TextStyle(fontFamily: 'YourFont')
```

---

## ⚠️ Common Issues

### 1. Logo Not Showing
**Solution:**
```bash
flutter clean
flutter pub get
flutter run
```

### 2. API Connection Failed
**Problem:** Can't connect to Laravel backend

**Solutions:**
- **Android Emulator:** Use `http://10.0.2.2:8000`
- **iOS Simulator:** Use `http://localhost:8000`
- **Real Device:** Use your computer's local IP (e.g., `http://192.168.1.100:8000`)
- Make sure Laravel server is running: `php artisan serve`

### 3. Token Not Saving
**Solution:** Make sure GetStorage is initialized in `main.dart`
```dart
await GetStorage.init();
```

### 4. 401 Error on API Call
**Problem:** Token expired or invalid

**Solution:**
- Handled automatically by ApiClient
- User will be logged out and redirected to login
- Just login again

---

## 📝 Next Steps

### Immediate Tasks:
1. ✅ Splash Screen - DONE
2. ✅ Login Screen - DONE
3. ✅ Register Screen - DONE
4. ⏳ Home Screen - TODO
5. ⏳ Profile Screen - TODO
6. ⏳ Consultation Screens - TODO
7. ⏳ Dream Journal Screens - TODO

### Home Screen (Next Priority):
- Dashboard with stats
- Quick actions
- Recent consultations
- Recent dreams
- Navigation menu

### Additional Features:
- Forgot password flow
- Edit profile with avatar upload
- Logout functionality
- Settings screen
- Dark mode support (optional)

---

## 🎨 Screenshots Preview

### Splash Screen
```
┌─────────────────────┐
│                     │
│                     │
│      [  LOGO  ]     │
│                     │
│       IRTIQA        │
│  Islamic Counseling │
│                     │
│     ( loading )     │
│                     │
│                     │
└─────────────────────┘
```

### Login Screen
```
┌─────────────────────┐
│    [  LOGO  ]       │
│                     │
│  Welcome Back       │
│  Sign in to...      │
│                     │
│  [Email Field   ]   │
│  [Password Field]   │
│                     │
│     Forgot Pass?    │
│                     │
│  [  Sign In  ]      │
│                     │
│       OR            │
│                     │
│  Don't have account?│
│      Sign Up        │
└─────────────────────┘
```

### Register Screen
```
┌─────────────────────┐
│← [  LOGO  ]         │
│                     │
│  Create Account     │
│  Sign up to...      │
│                     │
│  [Name Field    ]   │
│  [Email Field   ]   │
│  [Password Field]   │
│  [Confirm Pass  ]   │
│                     │
│  □ Accept Terms     │
│                     │
│  [  Sign Up  ]      │
│                     │
│  Already have acc?  │
│      Sign In        │
└─────────────────────┘
```

---

## 🚀 Ready to Go!

Your authentication flow is complete and fully functional. Run the app and test the entire flow from splash to login/register.

For API documentation, see: `API_DOCUMENTATION.md`
For integration guide, see: `FLUTTER_INTEGRATION_GUIDE.md`

Happy coding! 🎉
