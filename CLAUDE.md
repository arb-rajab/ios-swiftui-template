# Notes for Claude Code sessions on this repo

## A Linux sandbox cannot build, run or test Swift
There is no Xcode, Swift toolchain, `swift`, `xcodebuild` or `xcodegen` there. Do not try variations of those
commands. `.github/workflows/ci.yml` (`macos-15`) is the only place this code is compiled: check that job's result
instead of claiming the code builds because it reads correctly.

## No trailing commas in Swift parameter or argument lists
Strip them from multi-line function declarations and call argument lists (array and dictionary literals may keep
them). Newer toolchains may accept them, but unless you can actually compile, do not assume it.

## No committed .xcodeproj
`project.yml` (XcodeGen) generates it and `.gitignore` excludes it. A new file in an existing directory needs no
`project.yml` change (paths are directory globs); only a new top-level source directory does.

## Adding a GraphQL operation
Follow the existing shape: a plain `struct` wrapping a `GraphQLClient`, one method per operation, an inline nested
`Response: Decodable` per method. Cross-check field and argument names against the backend schema directly: no
schema introspection or codegen is wired up.

## The push payload contract lives in two repos
`Push/NotificationPayload.swift` (the `itemId` custom key) must stay in sync with the backend's APNs payload builder.
Nothing enforces this across repos, so grep both before changing either.

## Simulator, CI and real devices
- A Simulator cannot receive a real Apple-delivered push; `xcrun simctl push` can inject a crafted payload on a Mac.
- Real end-to-end push delivery can only be verified on a physical device with real credentials.
- Keychain tests need at least ad-hoc signing (`CODE_SIGN_IDENTITY: "-"` in `project.yml`), otherwise
  `errSecMissingEntitlement` (-34018). Do not pass `CODE_SIGNING_ALLOWED=NO` to `xcodebuild`.
- Do not override `PRODUCT_NAME` away from the target name: it breaks the unit-test `TEST_HOST` derivation.
- Pick the Simulator from `xcrun simctl list devices available -j` (name and OS paired), as `ci.yml` does.

## Project memory
Durable context goes in `docs/project-memory/`.
