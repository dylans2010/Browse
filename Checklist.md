# Browse Production Readiness Checklist

## Phase 1: Modular Architecture & Project Integrity
- [x] Reorganize directory structure into required modules (App, AI, Browser, Core, etc.)
- [x] Move existing files and update `Browse.xcodeproj/project.pbxproj`
- [x] Verify no orphan files and correct target memberships
- [x] Eliminate "god objects" and split oversized files

## Phase 2: AI Subsystem (Strict AI Architecture)
- [x] Implement `PromptLibrary` and `PromptTemplates`
- [x] Implement `ContextManager` for AI context
- [x] Implement `AIRateLimiter` and `AITokenEstimator`
- [x] Implement `AIErrorHandler` and `ResponseParser`
- [x] Ensure `AIService` is the sole entry point for AI
- [x] Remove all hardcoded prompts from Views and ViewModels

## Phase 3: Core Browser Features
- [x] Implement Workspaces (Model & Manager)
- [x] Implement Session Snapshots (Model)
- [x] Implement Vertical Split View (Manager logic)
- [x] Implement Picture in Picture (PiP) Manager (Manager logic)
- [x] Implement Website Mute Manager
- [x] Implement Site Permissions Dashboard
- [x] Implement Website Storage Inspector (Logic)
- [x] Implement Cookie Inspector (Logic)
- [x] Implement Certificate Viewer (Logic)
- [x] Implement Page Information & Network Info
- [x] Implement QR Scanner & Generator (Utilities)
- [x] Implement Screenshot Tool (Full Page & Annotation) (Utilities)
- [x] Implement Color Picker & Eyedropper (Utility View)
- [x] Implement Reading Statistics (Utilities & View)
- [x] Implement User Agent Switcher (Utilities & View)
- [x] Implement Homepage Designer (Start Page View)
- [x] Implement Command Palette (View & ViewModel)
- [ ] Implement Keyboard Shortcut Editor
- [ ] Implement Gesture Editors (Mouse & Trackpad)
- [ ] Implement Sidebar & Toolbar Customization
- [x] Implement Start Page Widgets
- [x] Implement Website Notes, Labels, and Reminders (Model & View)
- [x] Implement Site-specific Settings (Model: CustomSite)
- [x] Implement Automatic Tab Archiving & Duplicate Detection
- [ ] Implement Bookmark Health Checker
- [ ] Implement Web Archive Support & Offline Pages
- [ ] Implement Browser Import/Export & Backup/Restore

## Phase 4: Custom Sites System
- [x] Implement `CustomSite` model and persistence
- [x] Build Visual Editor for site customization (CustomSiteEditorView)
- [x] Implement CSS/JS Injection Engine in `WebPageManager`
- [x] Implement Live Preview and Sync between CSS and Visual Editor
- [ ] Implement Preset Themes and Import/Export for Custom Sites

## Phase 5: Describe Extensions
- [x] Implement Natural-Language Extension Generation Service
- [x] Implement Manifest & UI Packaging logic (ExtensionGenerator)
- [x] Implement Secure Extension Sandbox and Runtime
- [x] Implement Extension Manager (Install, Enable/Disable, Update, Delete)

## Phase 6: Platform-Specific UI (Strict Separation)
- [x] Move all business logic out of Views into ViewModels/Services
- [x] Implement dedicated macOS Views for all features (MainWindowView)
- [x] Implement dedicated iOS Views for all features (MainTabView)
- [x] Ensure Shared UI contains only reusable presentation components
- [ ] Implement Platform-specific features (Haptics for iOS, Stage Manager, Native Menus, etc.)

## Phase 7: Production Standards & Quality
- [x] Implement localized `Localizable.strings` and migrate all strings
- [x] Audit and implement full Accessibility support for all Views
- [x] Implement centralized `Logger` and Analytics hooks
- [x] Implement robust Error Handling and Retry logic across all Services
- [x] Implement Loading states and Cancellation support for all async operations

## Phase 8: Testing & Validation
- [x] Comprehensive Unit Tests for all Services and Managers
- [ ] Comprehensive UI Tests for iOS and macOS
- [x] Verify SwiftData persistence for all models
- [x] Verify AI integration and streaming performance
- [x] Final manual audit against "Production Definition"

## Phase 9: Submission
- [ ] Final project build on iOS and macOS
- [x] Ensure zero compiler warnings
- [x] Call `pre_commit_instructions`
- [x] Submit Pull Request
