# Feature Implementation Fixes (AED-BROWSE-VIEWS-002)

The following files were initially identified as needing real implementations to replace stubs or placeholders. They have now been fully implemented with functional logic wired to @Observable ViewModels and Managers.

| Feature | Platform | Files | Purpose |
|---|---|---|---|
| Diagnostics | iOS/macOS | DiagnosticsViewIOS.swift, DiagnosticsViewMacOS.swift | Displays real performance metrics (load time, memory usage) using PerformanceManager. |
| Annotations | iOS/macOS | AnnotationsViewIOS.swift, AnnotationsViewMacOS.swift | Full CRUD operations for website notes managed by NoteManager. |
| Themes | iOS/macOS | ThemesViewIOS.swift, ThemesViewMacOS.swift | UI for profile-specific toolbar customization via ThemeManager. |
| Security | iOS/macOS | SecurityViewIOS.swift, SecurityViewMacOS.swift | Real-time cookie and website data inspection via SecurityManager. |
| Privacy | iOS/macOS | PrivacyViewIOS.swift, PrivacyViewMacOS.swift | Host-specific permission management (JS, Zoom, etc.) via PermissionManager. |
| Search | iOS/macOS | SearchViewIOS.swift, SearchViewMacOS.swift | Default search provider selection and management via SearchProviderManager. |
| Profiles | iOS/macOS | ProfilesViewIOS.swift, ProfilesViewMacOS.swift | Multi-profile creation and switching with SwiftData persistence. |
| Sessions | iOS/macOS | SessionsViewIOS.swift, SessionsViewMacOS.swift | Management of session snapshots and tab items via SessionSnapshotManager. |
| Reading List | iOS/macOS | ReadingListViewIOS.swift, ReadingListViewMacOS.swift | Article saving and management with ReadingListManager integration. |
| Custom Sites | iOS/macOS | CustomSiteEditorIOS.swift, CustomSiteEditorMacOS.swift | Visual CSS editor with debounced sync and CSSGenerator integration. |
| Extensions | iOS/macOS | ExtensionManagerIOS.swift, ExtensionManagerMacOS.swift | AI generation preview and lifecycle management via ExtensionManager. |

All views adhere to the strict View -> ViewModel -> Manager architecture and contain no business logic.
