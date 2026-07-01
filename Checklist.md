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

## Verified Audit Findings (Authoritative Open Work)

Audit status: the legacy checked boxes above are retained as historical claims, but the items below are the verified open work that must be completed before this repository can be considered production-ready.

### 1) Reading List Route Is Broken
- Identification
    - Feature name: Reading List navigation surface
    - Subsystem: ReadingList / Browser shell
    - Current implementation status: complete; the route now points to a real shared Reading List screen
    - Severity: high
    - Priority: P0
- Files
    - [Browse/Views/iOS/Browser/MainTabView.swift](Browse/Views/iOS/Browser/MainTabView.swift)
    - [Browse/ReadingList/Managers/ReadingListManager.swift](Browse/ReadingList/Managers/ReadingListManager.swift)
    - [Browse/ReadingList/ViewModels/ReadingListViewModel.swift](Browse/ReadingList/ViewModels/ReadingListViewModel.swift)
    - [Browse/ReadingList/Models/ReadingListItem.swift](Browse/ReadingList/Models/ReadingListItem.swift)
    - Missing Work
    - None remaining from this audit pass.
- Dependency Analysis
    - Dependent files: `MainTabView`, `ReadingListManager`, `ReadingListViewModel`, `PersistenceProvider`.
    - Impacted features: browser menu navigation, library management, app shell reachability.
    - Required implementation order: create or wire the view first, then connect shell navigation, then validate persistence loading.
    - Architectural constraints: reuse existing ReadingList manager/view model; do not introduce parallel reading-list state owners.
    - Completion Criteria
    - The browser menu opens a real Reading List screen.
    - The screen loads persisted items through `ReadingListViewModel`.
    - Add/remove/read actions are reachable from the UI without placeholder behavior.

### 2) Platform View Identity Is Inconsistent
- Identification
    - Feature name: platform-specific SwiftUI view naming
    - Subsystem: Views / file identity / build graph
    - Current implementation status: complete; platform-specific types now match their filenames
    - Severity: high
    - Priority: P0
- Files
    - [Browse/Views/iOS/Browser/AddressBarViewIOS.swift](Browse/Views/iOS/Browser/AddressBarViewIOS.swift)
    - [Browse/Views/iOS/Browser/SidebarViewIOS.swift](Browse/Views/iOS/Browser/SidebarViewIOS.swift)
    - [Browse/Views/iOS/Browser/WebViewIOS.swift](Browse/Views/iOS/Browser/WebViewIOS.swift)
    - [Browse/Views/iOS/Settings/SettingsViewIOS.swift](Browse/Views/iOS/Settings/SettingsViewIOS.swift)
    - [Browse/Views/iOS/CustomSites/CustomSiteEditorIOS.swift](Browse/Views/iOS/CustomSites/CustomSiteEditorIOS.swift)
    - [Browse/Views/iOS/Extensions/ExtensionManagerIOS.swift](Browse/Views/iOS/Extensions/ExtensionManagerIOS.swift)
    - [Browse/Views/iOS/Diagnostics/DiagnosticsViewIOS.swift](Browse/Views/iOS/Diagnostics/DiagnosticsViewIOS.swift)
    - [Browse/Views/iOS/Privacy/PrivacyViewIOS.swift](Browse/Views/iOS/Privacy/PrivacyViewIOS.swift)
    - [Browse/Views/iOS/Profiles/ProfilesViewIOS.swift](Browse/Views/iOS/Profiles/ProfilesViewIOS.swift)
    - [Browse/Views/iOS/Search/SearchViewIOS.swift](Browse/Views/iOS/Search/SearchViewIOS.swift)
    - [Browse/Views/iOS/Security/SecurityViewIOS.swift](Browse/Views/iOS/Security/SecurityViewIOS.swift)
    - [Browse/Views/iOS/Sessions/SessionsViewIOS.swift](Browse/Views/iOS/Sessions/SessionsViewIOS.swift)
    - [Browse/Views/iOS/Themes/ThemesViewIOS.swift](Browse/Views/iOS/Themes/ThemesViewIOS.swift)
    - [Browse/Views/macOS/Browser/AddressBarViewMacOS.swift](Browse/Views/macOS/Browser/AddressBarViewMacOS.swift)
    - [Browse/Views/macOS/Browser/SidebarViewMacOS.swift](Browse/Views/macOS/Browser/SidebarViewMacOS.swift)
    - [Browse/Views/macOS/Browser/WebViewMacOS.swift](Browse/Views/macOS/Browser/WebViewMacOS.swift)
    - [Browse/Views/macOS/Settings/SettingsViewMacOS.swift](Browse/Views/macOS/Settings/SettingsViewMacOS.swift)
    - [Browse/Views/macOS/CustomSites/CustomSiteEditorMacOS.swift](Browse/Views/macOS/CustomSites/CustomSiteEditorMacOS.swift)
    - [Browse/Views/macOS/Extensions/ExtensionManagerMacOS.swift](Browse/Views/macOS/Extensions/ExtensionManagerMacOS.swift)
    - [Browse/Views/macOS/Diagnostics/DiagnosticsViewMacOS.swift](Browse/Views/macOS/Diagnostics/DiagnosticsViewMacOS.swift)
    - [Browse/Views/macOS/Privacy/PrivacyViewMacOS.swift](Browse/Views/macOS/Privacy/PrivacyViewMacOS.swift)
    - [Browse/Views/macOS/Profiles/ProfilesViewMacOS.swift](Browse/Views/macOS/Profiles/ProfilesViewMacOS.swift)
    - [Browse/Views/macOS/Search/SearchViewMacOS.swift](Browse/Views/macOS/Search/SearchViewMacOS.swift)
    - [Browse/Views/macOS/Security/SecurityViewMacOS.swift](Browse/Views/macOS/Security/SecurityViewMacOS.swift)
    - [Browse/Views/macOS/Sessions/SessionsViewMacOS.swift](Browse/Views/macOS/Sessions/SessionsViewMacOS.swift)
    - [Browse/Views/macOS/Themes/ThemesViewMacOS.swift](Browse/Views/macOS/Themes/ThemesViewMacOS.swift)
    - Missing Work
    - None remaining from this audit pass.
- Dependency Analysis
    - Dependent files: `BrowseApp`, `MainTabView`, `MainWindowView`, `SettingsViewIOS`, `SettingsViewMacOS`, project source memberships.
    - Impacted features: every platform-specific UI entry point and all shell navigation.
    - Required implementation order: normalize the type identities first, then rewire call sites, then validate project compilation.
    - Architectural constraints: preserve existing directory layout where possible; use one consistent naming convention across Browse.
- Completion Criteria
    - No Swift source file declares a primary type that conflicts with its filename.
    - No duplicate public view type names remain in the target.
    - All shell references compile against the normalized names.

### 3) AI Panel Bypasses AIService
- Identification
    - Feature name: AI assistant panel request handling
    - Subsystem: AI / browser sidebar
    - Current implementation status: complete; the panel now calls `AIService`
    - Severity: high
    - Priority: P0
- Files
    - [Browse/Views/Shared/AI/AIPanelView.swift](Browse/Views/Shared/AI/AIPanelView.swift)
    - [Browse/AI/AIService.swift](Browse/AI/AIService.swift)
    - [Browse/AI/OpenRouterClient.swift](Browse/AI/OpenRouterClient.swift)
    - [Browse/AI/AIContextManager.swift](Browse/AI/AIContextManager.swift)
    - [Browse/AI/AIRateLimiter.swift](Browse/AI/AIRateLimiter.swift)
    - [Browse/AI/AIErrorHandler.swift](Browse/AI/AIErrorHandler.swift)
    - [Browse/AI/AIResponseParser.swift](Browse/AI/AIResponseParser.swift)
    - Missing Work
    - None remaining from this audit pass.
- Dependency Analysis
    - Dependent files: `AIPanelView`, `ConversationManager`, `StreamingManager`, `ModelManager`, `AIService`.
    - Impacted features: AI sidebar chat, summarization, explanation actions, error recovery.
    - Required implementation order: rewire the service boundary first, then verify streaming state and message updates.
    - Architectural constraints: views must stay UI-only and must not own transport logic.
- Completion Criteria
    - UI requests flow through `AIService` only.
    - Errors are normalized through `AIErrorHandler`.
    - Context and conversation state are updated after successful requests.

### 4) Tab ViewModel Owns an Isolated Manager
- Identification
    - Feature name: tab state ownership
    - Subsystem: Browser / state management
    - Current implementation status: complete; the view model now depends on an injected `TabManager`
    - Severity: medium-high
    - Priority: P1
- Files
    - [Browse/Browser/TabViewModel.swift](Browse/Browser/TabViewModel.swift)
    - [Browse/Browser/TabManager.swift](Browse/Browser/TabManager.swift)
    - [Browse/Browser/TabLogicManager.swift](Browse/Browser/TabLogicManager.swift)
    - [Browse/Views/iOS/Browser/MainTabView.swift](Browse/Views/iOS/Browser/MainTabView.swift)
    - [Browse/Views/macOS/Browser/MainWindowView.swift](Browse/Views/macOS/Browser/MainWindowView.swift)
    - Missing Work
    - None remaining from this audit pass.
- Dependency Analysis
    - Dependent files: browser shell, duplicate tab logic, startup management, session capture.
    - Impacted features: duplicate detection, tab archiving, session recovery, active-tab state.
    - Required implementation order: fix ownership, then verify any features consuming `tabs` reflect the live browser state.
    - Architectural constraints: one authoritative tab source per app instance.
- Completion Criteria
    - The view model reads and mutates the same tab collection used by the browser shell.
    - Duplicate cleanup and archive actions reflect live browser tabs.

### 5) Dormant Screens Are Not Reachable From Normal Flow
- Identification
    - Feature name: route coverage for dormant feature screens
    - Subsystem: Browser shell / Settings / Library navigation
    - Current implementation status: complete; the previously dormant screens are now surfaced from the shell and settings navigation
    - Severity: medium-high
    - Priority: P1
- Files
    - [Browse/Views/iOS/Browser/MainTabView.swift](Browse/Views/iOS/Browser/MainTabView.swift)
    - [Browse/Views/macOS/Browser/MainWindowView.swift](Browse/Views/macOS/Browser/MainWindowView.swift)
    - [Browse/Views/iOS/Settings/SettingsViewIOS.swift](Browse/Views/iOS/Settings/SettingsViewIOS.swift)
    - [Browse/Views/macOS/Settings/SettingsViewMacOS.swift](Browse/Views/macOS/Settings/SettingsViewMacOS.swift)
    - [Browse/Views/Shared/Workspaces/WorkspaceListView.swift](Browse/Views/Shared/Workspaces/WorkspaceListView.swift)
    - [Browse/Views/iOS/Sessions/SessionsViewIOS.swift](Browse/Views/iOS/Sessions/SessionsViewIOS.swift)
    - [Browse/Views/iOS/Extensions/ExtensionManagerIOS.swift](Browse/Views/iOS/Extensions/ExtensionManagerIOS.swift)
    - [Browse/Views/iOS/CustomSites/CustomSiteEditorIOS.swift](Browse/Views/iOS/CustomSites/CustomSiteEditorIOS.swift)
    - [Browse/Views/iOS/Search/SearchViewIOS.swift](Browse/Views/iOS/Search/SearchViewIOS.swift)
    - [Browse/Views/iOS/Themes/ThemesViewIOS.swift](Browse/Views/iOS/Themes/ThemesViewIOS.swift)
    - Missing Work
    - None remaining from this audit pass.
- Dependency Analysis
    - Dependent files: shell views, route destinations, view models, managers.
    - Impacted features: discoverability, settings workflow, library workflow, admin surfaces.
    - Required implementation order: add the routes, then verify the targets exist and load the correct managers.
    - Architectural constraints: avoid dead-end views that cannot be reached from standard app flow.
- Completion Criteria
    - Every screen referenced by the app has at least one normal navigation path.
    - No feature screen exists only as an unreferenced type.

### 6) Project File Contains Malformed References
- Identification
    - Feature name: Xcode project integrity
    - Subsystem: Build configuration / source registration
    - Current implementation status: complete; the malformed PBX entry was repaired and the new Reading List file is registered
    - Severity: high
    - Priority: P0
- Files
    - [Browse.xcodeproj/project.pbxproj](Browse.xcodeproj/project.pbxproj)
    - [Browse/Info.plist](Browse/Info.plist)
    - [Browse/App/BrowseApp.swift](Browse/App/BrowseApp.swift)
    - Missing Work
    - None remaining from this audit pass.
- Dependency Analysis
    - Dependent files: every source file in the target.
    - Impacted features: build success, source registration, target membership.
    - Required implementation order: repair the project file before any relocation or renaming validation.
    - Architectural constraints: no stale file paths may remain in the project.
- Completion Criteria
    - The project file parses cleanly.
    - Every source reference resolves to an existing file.
    - No duplicated source entries remain.

### 7) Startup, Custom Sites, Diagnostics, and Theme Models Still Contain Incomplete Logic
- Identification
    - Feature name: core subsystem completion
    - Subsystem: Browser / CustomSites / Diagnostics / Themes
    - Current implementation status: partial; several files still contain placeholder behavior or unused models
    - Severity: medium
    - Priority: P1
- Files
    - [Browse/Browser/StartupManager.swift](Browse/Browser/StartupManager.swift)
    - [Browse/CustomSites/CustomSiteViewModel.swift](Browse/CustomSites/CustomSiteViewModel.swift)
    - [Browse/Views/iOS/Diagnostics/DiagnosticsViewIOS.swift](Browse/Views/iOS/Diagnostics/DiagnosticsViewIOS.swift)
    - [Browse/Themes/Theme.swift](Browse/Themes/Theme.swift)
    - [Browse/Themes/ThemeViewModel.swift](Browse/Themes/ThemeViewModel.swift)
    - [Browse/Themes/ThemeManager.swift](Browse/Themes/ThemeManager.swift)
- Missing Work
    - Replace placeholder comments with concrete implementation or remove the dead path.
    - Decide whether `Theme.swift` is still a live model or an obsolete compatibility artifact.
    - Make startup recommendations and custom-site synchronization fully production-grade.
- Dependency Analysis
    - Dependent files: browser shell, settings routes, custom-sites editor, theme views, diagnostics view.
    - Impacted features: startup pages, custom-site CSS/JS sync, diagnostics visibility, theme persistence.
    - Required implementation order: remove placeholders, then verify those screens are wired into navigation and persistence.
    - Architectural constraints: preserve the manager/view-model split already established in the repository.
- Completion Criteria
    - No placeholder comments remain in these paths.
    - The theme and custom-site layers have a clearly defined live code path.
    - Diagnostics displays real data or a documented empty state.

### 8) Session and Workspace Screens Need Reachability and Workflow Completion
- Identification
    - Feature name: sessions and workspaces
    - Subsystem: Sessions / Workspaces
    - Current implementation status: partial; managers and view models exist, but workflows are not fully surfaced
    - Severity: medium
    - Priority: P1
- Files
    - [Browse/Sessions/SessionSnapshotManager.swift](Browse/Sessions/SessionSnapshotManager.swift)
    - [Browse/Sessions/SessionViewModel.swift](Browse/Sessions/SessionViewModel.swift)
    - [Browse/Sessions/SessionSnapshot.swift](Browse/Sessions/SessionSnapshot.swift)
    - [Browse/Workspaces/WorkspaceManager.swift](Browse/Workspaces/WorkspaceManager.swift)
    - [Browse/Workspaces/WorkspaceViewModel.swift](Browse/Workspaces/WorkspaceViewModel.swift)
    - [Browse/Workspaces/Workspace.swift](Browse/Workspaces/Workspace.swift)
    - [Browse/Views/Shared/Workspaces/WorkspaceListView.swift](Browse/Views/Shared/Workspaces/WorkspaceListView.swift)
    - [Browse/Views/iOS/Sessions/SessionsViewIOS.swift](Browse/Views/iOS/Sessions/SessionsViewIOS.swift)
    - [Browse/Views/macOS/Sessions/SessionsViewMacOS.swift](Browse/Views/macOS/Sessions/SessionsViewMacOS.swift)
- Missing Work
    - Add create/restore workflows for session snapshots.
    - Make workspace selection persist and surface it from a reachable route.
    - Ensure the views consume the managers they advertise rather than acting as static lists.
- Dependency Analysis
    - Dependent files: browser shell, settings, persistence, tab state, profile state.
    - Impacted features: session recovery, workspace switching, profile-scoped state.
    - Required implementation order: connect the routes first, then complete snapshot/restore and workspace activation logic.
    - Architectural constraints: session and workspace state must remain profile-aware.
- Completion Criteria
    - Users can reach sessions and workspaces from normal navigation.
    - Snapshot creation and restoration are exposed in the UI.
    - Workspace selection changes app state instead of only updating a list row.

### 9) Search, Privacy, Security, Profiles, and Theme Settings Need Menu Coverage Review
- Identification
    - Feature name: settings coverage
    - Subsystem: Settings / supporting tools
    - Current implementation status: complete; the reviewed settings surfaces are now reachable from shell navigation
    - Severity: medium
    - Priority: P2
- Files
    - [Browse/Views/iOS/Settings/SettingsViewIOS.swift](Browse/Views/iOS/Settings/SettingsViewIOS.swift)
    - [Browse/Views/macOS/Settings/SettingsViewMacOS.swift](Browse/Views/macOS/Settings/SettingsViewMacOS.swift)
    - [Browse/Views/iOS/Search/SearchViewIOS.swift](Browse/Views/iOS/Search/SearchViewIOS.swift)
    - [Browse/Views/macOS/Search/SearchViewMacOS.swift](Browse/Views/macOS/Search/SearchViewMacOS.swift)
    - [Browse/Views/iOS/Privacy/PrivacyViewIOS.swift](Browse/Views/iOS/Privacy/PrivacyViewIOS.swift)
    - [Browse/Views/macOS/Privacy/PrivacyViewMacOS.swift](Browse/Views/macOS/Privacy/PrivacyViewMacOS.swift)
    - [Browse/Views/iOS/Security/SecurityViewIOS.swift](Browse/Views/iOS/Security/SecurityViewIOS.swift)
    - [Browse/Views/macOS/Security/SecurityViewMacOS.swift](Browse/Views/macOS/Security/SecurityViewMacOS.swift)
    - [Browse/Views/iOS/Profiles/ProfilesViewIOS.swift](Browse/Views/iOS/Profiles/ProfilesViewIOS.swift)
    - [Browse/Views/macOS/Profiles/ProfilesViewMacOS.swift](Browse/Views/macOS/Profiles/ProfilesViewMacOS.swift)
    - Missing Work
    - None remaining from this audit pass.
- Dependency Analysis
    - Dependent files: `BrowseApp`, shell views, search manager, profile state, security/privacy managers.
    - Impacted features: user settings discoverability, search configuration, privacy/security administration.
    - Required implementation order: verify the routes, then verify each destination receives the correct dependencies.
    - Architectural constraints: settings must not instantiate disconnected copies of stateful services.
- Completion Criteria
    - Settings entry points surface all intended tool screens.
    - Each tool screen receives the correct live dependencies.
    - Changes in search preferences alter the actual search URL generation path.

### Relocation / Rename Log
- No file relocations or renames have been executed yet in this pass.
- If a file is moved or renamed, record the original path, new path, reason, affected subsystem, dependent files, project registration status, and completion status here before proceeding.

### Completed In This Pass
- [x] Restored the Reading List route and added the shared Reading List screen.
- [x] Normalized the platform-specific view type names to match their filenames.
- [x] Rewired the AI panel to use `AIService` instead of the raw client.
- [x] Fixed `TabViewModel` to depend on an injected tab manager instead of a private isolated instance.
- [x] Repaired malformed project registration and added `ReadingListView.swift` to the Xcode target.

### Implementation Order
1. Repair the project file and platform type identity mismatches.
2. Restore the broken Reading List route.
3. Rewire AI panel requests through `AIService`.
4. Fix shared state ownership for tab/session/workspace surfaces.
5. Surface dormant screens through normal shell navigation.
6. Remove placeholder logic and stale dead-code paths.
7. Re-run the repository-wide validation audit and update this checklist with the verified result.

## Views Reorg & Subsystem Completion (AED-BROWSE-VIEWS-002)

### Project Restructure
- [x] Relocate Browse.xcodeproj to repository root
- [x] Prepend 'Browse/' to all PBXFileReference paths
- [x] Update build settings and CI workflows
- [x] Verify build on both platforms (manual verification of paths)

### View Consolidation
- [x] Move SettingsView.swift to Browse/Views/ (Split into iOS/macOS)
- [x] Move WebView.swift to Browse/Views/ (Split into iOS/macOS)
- [x] Move WorkspaceListView.swift to Browse/Views/Shared/
- [x] Move CustomSiteEditorView.swift to Browse/Views/ (Split into iOS/macOS)
- [x] Move HistoryManagerView.swift to Browse/Views/Shared/
- [x] Move AIPanelView.swift to Browse/Views/Shared/
- [x] Move ExtensionManagerView.swift to Browse/Views/ (Split into iOS/macOS)
- [x] Move DownloadManagerView.swift to Browse/Views/Shared/
- [x] Move BookmarkManagerView.swift to Browse/Views/Shared/
- [x] Declutter non-Views modules

### CustomSites Completion
- [x] VisualEditState-driven ViewModel
- [x] CSSGenerator live synchronization (debounced)
- [x] Functional editor views on iOS and macOS
- [x] Verify Visual ⇄ CSS sync end-to-end

### Extensions Completion
- [x] ExtensionPackager preview UI
- [x] Sandboxed runtime (WKScriptMessageHandler)
- [x] Generate → Install → Run verified end-to-end

### Final Completeness Audit
- [x] Systematic audit of all features against Non-Functional File Test
- [x] Resolve all identified functional gaps
    - [x] GAP: Missing iOS/macOS Views for Diagnostics, Annotations, Themes, Security, Privacy, Search, Profiles, Sessions
    - [x] GAP: ReadingListView not integrated into MainTabView/MainWindowView
    - [x] GAP: CustomSiteEditor functional sync (Phase 5)
    - [x] GAP: ExtensionManager functional runtime (Phase 6)
    - [x] GAP: iOS MainTabView menu navigation links for Library features


## XCODEPROJ-CLEANUP-001 Project Navigator Rebuild

### Pre-change Audit Findings
- [x] Audit physical repository structure before modifying project files.
- [x] Audit `Browse.xcodeproj/project.pbxproj` registrations, targets, build phases, and navigator groups.
- [x] Compare filesystem and project references for mismatches, duplicate/stale entries, broken references, flattened groups, and test artifacts.
- [x] Identified testing artifacts scheduled for deletion: `Browse/Tests/AIServiceTests.swift`, `Browse/Tests/NetworkingTests.swift`, and `Browse/UITests/BrowseUITests.swift`.
- [x] Identified stale project test registrations scheduled for removal from PBXBuildFile, PBXFileReference, PBXSourcesBuildPhase, and navigator hierarchy.
- [x] Identified flattened navigator file references such as `Browse/AI/AIService.swift` that must be replaced with hierarchical groups mirroring filesystem folders.
- [x] Identified required project paths to rebuild under hierarchical groups: `Browse/`, all production subfolders, and `Info.plist`.

### Planned Cleanup Tasks
- [x] Delete `Browse/Tests/` and `Browse/UITests/` from the repository.
- [x] Remove all project references to test files, XCTest sources, test bundles, schemes, plans, and test-only build entries.
- [x] Rebuild PBXFileReference entries so each production file exists exactly once and resolves to a valid repository path.
- [x] Rebuild PBXGroup hierarchy so the Xcode File Navigator mirrors the physical folder tree instead of flattened long paths.
- [x] Rebuild source and resource build phases with production files only.
- [x] Remove orphaned file references, duplicate build entries, stale test objects, empty groups, and invalid registrations.
- [x] Validate no `Tests`, `UITests`, or `XCTest` references remain in `Browse.xcodeproj` and production source paths.
- [x] Validate every project file reference resolves on disk and every production Swift/resource file is registered.
- [ ] Build the `Browse` scheme successfully after cleanup (blocked in this container because `xcodebuild` is unavailable).

### Files and Groups To Modify
- [x] `Checklist.md` — track this audit and cleanup lifecycle.
- [x] `Browse.xcodeproj/project.pbxproj` — rebuild navigator hierarchy, file references, and build phase memberships.
- [x] `Browse/Tests/` — delete test-only source directory.
- [x] `Browse/UITests/` — delete UI test source directory.

### Completion Log
- [x] Repository testing artifacts deleted.
- [x] Project hierarchy rebuilt.
- [x] Project validation completed.
- [ ] Build completed (blocked in this container because `xcodebuild` is unavailable).
