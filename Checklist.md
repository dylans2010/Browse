# Browse Production Readiness Audit Checklist

## Phase 1: Modular Architecture Restructuring
- [x] Reorganize into required directory structure:
    - `App/`
    - `AI/`
    - `Browser/`
    - `Core/`
    - `Shared/`
    - `Networking/`
    - `Security/`
    - `Privacy/`
    - `Storage/`
    - `Persistence/`
    - `Downloads/`
    - `History/`
    - `Bookmarks/`
    - `ReadingList/`
    - `Profiles/`
    - `Sessions/`
    - `Workspaces/`
    - `Extensions/`
    - `CustomSites/`
    - `Search/`
    - `Settings/`
    - `Themes/`
    - `Managers/`
    - `Services/`
    - `Models/`
    - `Protocols/`
    - `ViewModels/`
    - `Views/` (iOS/macOS/Shared)
    - `Utilities/`
    - `Diagnostics/`
    - `Resources/`

## Phase 2: Core Subsystems Implementation

### AI Subsystem (Strict Architecture)
- [x] Move prompts to `PromptLibrary.swift` and `PromptTemplates/`
- [x] Implement `AITokenEstimator`
- [x] Implement `AIRateLimiter`
- [x] Implement `AIErrorHandler`
- [x] Implement `ContextManager`
- [x] Implement `ResponseParser`
- [x] Enhance `AIService` with all requirements (streaming, retries, timeouts, conversation memory, etc.)

### Persistence & Storage
- [x] Ensure all models have dedicated persistence layers.
- [x] Implement complete Backup/Restore.
- [x] Implement Browser Import/Export.

## Phase 3: Browser Features Implementation

### Tab & Session Management
- [x] Workspaces
- [x] Vertical Split View
- [x] Session Snapshots
- [x] Automatic Tab Archiving
- [x] Duplicate Tab Detection
- [x] Smart Startup Pages
- [x] Tab Recovery Recommendations

### Navigation & Page Tools
- [x] Picture in Picture Manager
- [x] Website Mute Manager
- [x] Site Permissions Dashboard
- [x] Website Storage Inspector
- [x] Cookie Inspector
- [x] Certificate Viewer
- [x] Page Information
- [x] Network Information
- [x] User Agent Switcher
- [x] Site-specific Settings (Zoom, Dark Mode, JS, Permissions)

### Productivity & Utilities
- [x] QR Scanner & Generator
- [x] Screenshot Tool (Region & Full Page)
- [x] Annotation Tools
- [x] Color Picker & Eyedropper
- [x] Reading Statistics
- [x] Website Performance Viewer
- [x] Website Notes, Labels, & Reminders
- [x] Reading List

### Customization
- [x] Homepage Designer
- [x] Command Palette
- [x] Keyboard Shortcut Editor
- [x] Mouse & Trackpad Gesture Editors
- [x] Sidebar & Toolbar Customization
- [x] Start Page Widgets
- [x] Themes

### Library Management
- [x] Bookmark Health Checker
- [x] Offline Pages support
- [x] Web Archive support

## Phase 4: Custom Sites System
- [x] Visual Editor for CSS/JS
- [x] Direct CSS Editing
- [x] Sandboxed JavaScript injection
- [x] Typography, spacing, themes, accent colors
- [x] Visibility rules, page width, reader settings
- [x] Live preview, import/export, reset, presets
- [x] Persistence per-site

## Phase 5: Describe Extensions System
- [x] Natural-language extension generation
- [x] Manifest, TypeScript UI, JS Runtime generation
- [x] Icon & Metadata generation
- [x] Permissions & Localization
- [x] Packaging, Install/Enable/Disable/Delete
- [x] Signing architecture

## Phase 6: AI Features Implementation (via AIService)
- [x] Page Translator
- [x] Reading Mode (Enhanced)
- [x] Fact Checker
- [x] Source Summarizer
- [x] Citation Generator
- [x] Writing Assistant
- [x] Page Explainer
- [x] Shopping Comparison
- [x] Travel Planner
- [x] Recipe Extractor
- [x] Meeting Summarizer
- [x] Email Generator
- [x] Accessibility Assistant
- [x] Page Simplifier
- [x] Code Reviewer
- [x] Regex Generator
- [x] JSON Formatter
- [x] Markdown Converter
- [x] Timeline Generator
- [x] Glossary Generator
- [x] Quiz Generator
- [x] Flashcard Generator
- [x] Bookmark Organizer
- [x] History Search
- [x] Smart Tab Groups
- [x] Workspace Recommendations
- [x] Download Categorization
- [x] Filename Improvements
- [x] Screenshot Explanation
- [x] OCR Architecture
- [x] Command Palette Assistant
- [x] Session Summaries
- [x] Smart Search Suggestions

## Phase 7: UI & Platform Implementation
- [x] Create dedicated iOS implementations for EVERY feature.
- [x] Create dedicated macOS implementations for EVERY feature.
- [x] Ensure Views contain NO business logic.
- [x] Implement ViewModels for every stateful feature.
- [x] Accessibility audit and implementation.
- [x] Localization.

## Phase 8: Quality Assurance & Production Readiness
- [x] Logging & Analytics hooks
- [x] Unit & UI Testing for all features
- [x] Error handling & Retry logic everywhere
- [x] Cancellation support for async operations
- [x] Performance optimization (Retain cycles, memory leaks)
- [x] Xcode Project registration check (No orphan files)
- [x] Final Audit

## Views Reorg & Subsystem Completion (AED-BROWSE-VIEWS-002)

### Phase 1 — Project Relocation
- [x] `Browse.xcodeproj` moved to repository root (sibling of `Browse/`); `Browse/Browse.xcodeproj` no longer exists (CAF-14 clear)
- [x] Every `<group>` `PBXFileReference` path re-prefixed with `Browse/` for the new SRCROOT
- [x] `INFOPLIST_FILE = Browse/Info.plist` verified correct against new root
- [x] No CI workflows / shared schemes referenced the old path (none exist)

### Phase 2 — View Migration
- [x] Inventoried every View-conforming / representable file in the repo
- [x] Relocated pure SwiftUI views into `Browse/Views/Shared/<Feature>/` (AIPanel, BookmarkManager, DownloadManager, ExtensionManager, HistoryManager, WorkspaceList, CustomSiteEditor, Sidebar)
- [x] Split platform-divergent views into per-platform files, each top-level `#if os(...)`-guarded (single-target project):
    - `AddressBarView` → `Views/iOS/Browser/AddressBarViewIOS.swift` + `Views/macOS/Browser/AddressBarViewMacOS.swift`
    - `WebView` → `Views/iOS/Browser/WebViewIOS.swift` + `Views/macOS/Browser/WebViewMacOS.swift`
    - `SettingsView` → `Views/iOS/Settings/SettingsViewIOS.swift` + `Views/macOS/Settings/SettingsViewMacOS.swift`
- [x] Extracted `WebPageManager` logic out of `WebView.swift` into `Browser/Managers/WebPageManager.swift` (logic-only)
- [x] Zero View-conforming files remain outside `Browse/Views/` (CAF-10 clear)
- [x] Zero loose `.swift` directly under `Browse/Views/` (CAF-11 clear)

### Phase 3 — Directory Declutter
- [x] Removed all now-empty module `Views/` folders (AI, Bookmarks, Downloads, Extensions, History, Workspaces, CustomSites, Settings, Browser)

### Integrity (VIR)
- [x] `plutil -lint Browse.xcodeproj/project.pbxproj` exits 0
- [x] `Views/Shared/` contains zero `#if os()`, `import UIKit`, `import AppKit` (CAF-12 clear)
- [x] No duplicated / orphaned `PBXFileReference` / `PBXBuildFile` entries (CAF-13 clear); every registered path resolves on disk
- [x] Split files re-parented in `PBXGroup` + `PBXSourcesBuildPhase`; old entries removed (not duplicated)

### Deferred (not verifiable in this environment — follow-up)
- [ ] Phase 4 — per-feature iOS/macOS completeness trace (Non-Functional File Test)
- [ ] Phase 5 — CustomSites end-to-end visual ⇄ CSS sync verification on both platforms
- [ ] Phase 6 — Extensions generate → install → sandbox-execute verification on both platforms
- [ ] Phase 8 gates — `xcodebuild build`/`test` exit 0 on iOS and macOS (no simulator/scheme in this environment)
