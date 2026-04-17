# Error Handling & Debugging Guide

## Overview

The app has comprehensive error handling and debugging capabilities across all layers.

---

## 🔍 Debug Logging

### 1. **API Request/Response Logging** (Automatic)

All API calls are automatically logged in debug console:

```
┌─────────────────────────────────────────
│ REQUEST[POST] => /auth/login
│ Headers: {Content-Type: application/json, ...}
│ Body: {email: "...", password: "..."}
└─────────────────────────────────────────
```

```
┌─────────────────────────────────────────
│ RESPONSE[200] => /auth/login
│ Body: {success: true, data: {...}}
└─────────────────────────────────────────
```

```
┌─────────────────────────────────────────
│ ERROR[500] => /auth/login
│ Message: Server error
│ Response: {message: "..."}
└─────────────────────────────────────────
```

**Location:** `lib/core/services/api_service.dart`

---

### 2. **Controller-Level Logging**

All controllers use `LoggerHelper` for structured logging:

```dart
final _logger = LoggerHelper('SpeakerHomeController');

// Usage
_logger.i('Login successful');
_logger.d('Loading data...');
_logger.w('Warning message');
_logger.e('Error occurred', error: e, stackTrace: stackTrace);
```

**Example Output:**
```
[I] SpeakerHomeController: Login successful
[D] SpeakerHomeController: Loading invitations...
[E] SpeakerHomeController: Failed to load data: DioException
```

**Location:** `lib/core/helpers/logger_helper.dart`

---

## ⚠️ Error Handling

### 1. **Global API Error Interceptor**

All API errors are caught and processed:

- ✅ **401 Unauthorized** → Auto token refresh
- ✅ **Network Errors** → User-friendly message
- ✅ **Server Errors (500)** → Logged + toast in debug
- ✅ **Bad Request (400)** → Shows backend error message
- ✅ **Forbidden (403)** → "Access Denied" message
- ✅ **Not Found (404)** → "Resource not found" message

**Location:** `lib/core/services/api_service.dart` → `_showErrorToast()`

---

### 2. **Controller Error Handling**

All async operations wrapped in try-catch:

```dart
try {
  final response = await _service.doSomething();
  // Handle success
} catch (e) {
  _logger.e('Failed to do something: $e');
  ToastMessageHelper.showToastMessage(
    'Failed to do something',
    title: 'Error',
  );
}
```

---

### 3. **User-Friendly Error Messages**

| Error Type | User Message | Debug Log |
|------------|-------------|-----------|
| **No Internet** | "Please check your internet connection" | ✅ Full error details |
| **Token Expired** | (Auto-refresh, no message) | ✅ Token refresh logged |
| **Server Error** | "Server error. Try again later" | ✅ Full response logged |
| **Validation Error** | Backend error message | ✅ Full response logged |
| **Permission Denied** | "You don't have permission" | ✅ Full error logged |

---

## ️ Safety Checks

### **Form Validation**

All forms have validation before submission:

```dart
if (!formKey.currentState!.validate()) {
  return; // Don't submit invalid data
}
```

### **Confirmation Dialogs**

Destructive actions show confirmation:

```dart
final confirmed = await Get.dialog<bool>(
  AlertDialog(
    title: const Text('Delete Job?'),
    content: const Text('Are you sure?'),
    actions: [
      TextButton(onPressed: () => Get.back(result: false), child: Text('Cancel')),
      TextButton(onPressed: () => Get.back(result: true), child: Text('Delete')),
    ],
  ),
);

if (confirmed != true) return; // User cancelled
```

### **Loading States**

All async operations show loading indicators:

```dart
isSubmitting.value = true;
try {
  // API call
} finally {
  isSubmitting.value = false;
}
```

---

## 📍 Where to Find Logs

### **Debug Console (VS Code/Android Studio)**

1. Run app in debug mode
2. Open "Debug Console" tab
3. Look for:
   - `REQUEST` / `RESPONSE` / `ERROR` (API calls)
   - `[TagName]` (Controller logs)
   - Stack traces for exceptions

### **Filter Logs**

```
# Filter by tag
filter: SpeakerHomeController

# Filter by type
filter: REQUEST
filter: RESPONSE
filter: ERROR
```

---

## 🧪 Testing Error Scenarios

### **1. Network Errors**
- Turn off WiFi/Cellular
- Try to submit form
- **Expected:** "No Internet" toast + debug log

### **2. Server Errors**
- Backend returns 500
- **Expected:** Error toast (debug mode) + full response logged

### **3. Validation Errors**
- Submit empty form
- **Expected:** Inline validation errors (no toast)

### **4. Permission Errors**
- Try action without permission
- **Expected:** "Access Denied" toast + logged

---

## 📋 Implemented Error Handling by Feature

| Feature | Logger | Toast on Error | Loading State | Confirmation |
|---------|--------|----------------|---------------|--------------|
| **Speaker Invitations** | ✅ | ✅ | ✅ | ❌ |
| **Live Session Controls** | ✅ | ✅ | ✅ | ❌ |
| **Q&A Submit** | ✅ | ✅ | ✅ | ❌ |
| **Poll Vote** | ✅ | ✅ | ✅ | ❌ |
| **Survey Submit** | ✅ | ✅ | ✅ | ❌ |
| **Job Posting** | ✅ | ✅ | ✅ | ❌ |
| **Delete Job** | ✅ | ✅ | ✅ | ✅ |
| **Role Switch** | ✅ | ✅ | ✅ | ❌ |
| **Logout** | ✅ | ❌ |  | ✅ |

---

## 🚀 Production Recommendations

### **Disable Debug Toasts**

Currently, error toasts only show in debug mode:

```dart
if (kDebugMode) {
  ToastMessageHelper.showToastMessage(errorMessage, title: title);
}
```

For production, consider:
1. Remove `kDebugMode` check for critical errors
2. Add error reporting service (Sentry, Crashlytics)
3. Log errors to backend for monitoring

---

## 🐛 Troubleshooting

### **"I don't see any logs"**

1. Make sure app is in **debug mode**
2. Check "Debug Console" in your IDE
3. Verify `LoggerHelper` is initialized

### **"Errors are not showing toast"**

1. Check if running in debug mode (`kDebugMode`)
2. Verify error is not 401 (auto-refresh)
3. Check `_showErrorToast` in `ApiService`

### **"Form submits without validation"**

1. Ensure `formKey` is assigned to `Form` widget
2. Call `formKey.currentState!.validate()` before submit
3. Check validator functions return `null` on valid input

---

## 📞 Quick Reference

```dart
// Log info
_logger.i('User logged in');

// Log debug
_logger.d('Loading data from API');

// Log warning
_logger.w('Cache miss, fetching from server');

// Log error with stack trace
try {
  // risky operation
} catch (e, stackTrace) {
  _logger.e('Operation failed', error: e, stackTrace: stackTrace);
}

// Show user message
ToastMessageHelper.showToastMessage('Success!', title: 'Done');

// Show error with backend message
ToastMessageHelper.showToastMessage(
  response['message'] ?? 'Failed',
  title: 'Error',
);
```

---

**Last Updated:** March 30, 2026
**Version:** 1.0.1
