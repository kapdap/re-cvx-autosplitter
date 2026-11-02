# LiveSplit

Engine behavior affecting this splitter.

## Quirks

### Disconnected polling

When no supported emulator is running, the CPU sits at a constant ~5% with two or more `state()` blocks. It drops once [`TryConnect`](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/ASL/ASLScript.cs#L224-L234) attaches to a process. Expected behavior.

Each tick runs [`TryConnect`](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/ASL/ASLScript.cs#L224-L234) while detached. It issues one [`Process.GetProcessesByName`](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/ASL/ASLScript.cs#L232) plus start-time ordering per `state()` name. Cost scales with declared names.

Connected cost is zero. The blocks declare no values, so only the matched descriptor refreshes over an empty definition list.

No script fix exists. No script block runs while detached. Tick rate accepts writes only from attached blocks. One lookup per emulator is inherent to multi-emulator support.
