# AGENTS.md

This repo contains a LiveSplit autosplitter for Resident Evil / Biohazard: Code: Veronica. `recvx.asl` reads emulator memory to start the timer, trigger splits, and remove load time. ASL actions use C#.

These rules provide basic quality control for agent changes.

- ASL docs: https://github.com/LiveSplit/LiveSplit.AutoSplitters/blob/master/README.md
- LiveSplit source: https://github.com/LiveSplit/LiveSplit

## Editing `recvx.asl`

- Read nearby code first. Make the smallest in-place change. Leave unrelated code unchanged.
- Keep block order, settings IDs, helper names, and memory design. Retain every process state and emulator branch. Never remove emulator support.
- If a task needs a redesign or breaks these rules, explain the plan and wait for approval before coding.

## Names

- Keep existing names. For new locals and state fields, use descriptive `camelCase`, such as `basePointer`, `roomPtr`, and `doorsIndex`.
- Avoid opaque names and index tables such as `addr`, `lay`, `A_LEN`, `A_DOOR`, and `B_ROOM`. Prefer names such as `timePtr` and `doorFlagPtr`.
- Store cross-action state in `vars.*`. Name shared helpers in `PascalCase`, such as `vars.ReadState`. Do not shadow `vars.*` data.
- Keep state fields `killed`, `events`, `start`, and `split` unchanged.
- Setting IDs and process names are fixed contracts. Preserve exact names, such as `anySplits`, `FRT`, and `state("rpcs3")`.

### Final variable names

These names are final. Never rename them, including during cleanup or refactoring:

- Tracking: `vars.queue`, `vars.itemIndex`, `vars.killedIndex`, `vars.eventsIndex`, `vars.killedMap`, `vars.eventsMap`, `vars.killedItr`, `vars.eventsItr`, `last`.
- Process and export locals: `basept`, `marker`.
- Helper names: `CheckFlag` uses `idx` and `bit`; `CheckSplit` uses `cur` and `prev`; `UpdateDoorSplit` uses `id` and `prevId`.

## Formatting

- Use four spaces for indentation.
- Put ASL action braces and C# block braces for `if`, `switch`, `try`, and loops on the next line.
- Keep lambda braces after `=>`, as in `=> {`. Keep empty process declarations inline, as in `state("rpcs3") {}`.
- Keep one-line `return` and `continue` guards on one line.
- Put each setting, pointer entry, and route row on its own line.

## Code structure

- Keep every supported `state()` declaration at the top.
- Put trackers, Add/Reset helpers, byte helpers, and settings in `startup`.
- Put pointer locals, sync and queue state, product tables, routes, helpers, the reader thread, and initialization calls in `init`.
- Keep runtime order: `start`, `update`, `split`, `gameTime`, `isLoading`, `exit`, `shutdown`. `update` replays queued changes. `start` and `split` return flags. Keep `gameTime` and `isLoading` short.
- Use the existing shared-helper pattern: `vars.Name = (Func<...>)((...) => { ... })`. Keep helper names and signatures. Do not use bare `Func` or `Action` locals for shared helpers.
- Keep per-address memory reads, the existing reader thread, and the `SwapBytes`, `SwapBytesInt`, and `CheckFlag` helpers. Do not add block reads, decode layers, extra threads, new timing systems, P/Invoke, or `AppDomain` storage.

## Frozen actions

Never modify these ASL action blocks:

- `gameTime`
- `exit`
- `shutdown`
- `isLoading`
- `split`
- `start`

If one seems to need a change, rethink the approach first. It likely breaks the intended flow or pattern.
