# Threading

This file explains why this splitter uses background threads, what each thread does, and how starts and splits are triggered on the UI thread.

## Purpose

LiveSplit ticks on the UI thread about every 15 ms, often slower under load ([timer setup](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/Component.cs#L48-L51)). A heavy layout can stall the splitter because the same thread handles both the tick and the layout ([tick handling](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/Component.cs#L98-L103)). Stalls of 1 to 2 seconds have been observed.

That caused two failures.

- Delayed splits. A split or start happens on time but the UI only sees it on the next tick.
- Missed door loads. A short load can occur entirely inside one UI stall, so that load time never gets subtracted and the timer overcounts.

The fix uses a producer and a consumer. A background reader constantly polls game memory to save each split to a shared queue and track load removal time. The UI thread then replays that queue in order, one entry per tick, so nothing is lost during UI stalls.

## Functions

- Reader producer that saves split and start states.
- UI consumer that replays saved states in order with at most one start or split per tick.
- Logger that measures loads and phases without firing starts or splits.

## Queue

The queue is the only link between the reader and the UI.

- The reader is the single producer and adds a trigger state on detection.
- The UI is the single consumer and takes the oldest trigger first.
- Split game time comes from the trigger state.

The queue keeps the history, so a room transition between UI stalls is still tracked with accurate timing.

## Reader

The reader runs a single producer loop for splits and starts.

Every pass reads complete game state, tracks load removal time, and queues split or start states with the correct time.

## UI replay

Each `update` tick clears the pending start and split flags, then takes the oldest state from the queue.

Each queued state is checked as a start or split trigger, sets the appropriate flag, and updates `current.time` to the state time, so when `split` or `start` fires, the accurate time is recorded.

## High-resolution timer

High-resolution mode is an optional experimental Windows timer used by both background threads. It fires every 1 ms instead of the standard 15 ms. The game updates at 60 TPS or about 16 ms, so the faster timer is generally unnecessary.

## References

- [Scriptable Auto Splitter timer setup](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/Component.cs#L48-L53) - 15 ms tick, note that it often takes about 30 ms, timer disabled during the tick.
- [Scriptable Auto Splitter tick handling](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/Component.cs#L98-L103) - timer disabled for the tick while the script updates.
- [Scriptable Auto Splitter update order](https://github.com/LiveSplit/LiveSplit.ScriptableAutoSplit/blob/master/src/LiveSplit.ScriptableAutoSplit/ASL/ASLScript.cs#L311-L365) - update, then loading and game time, then reset or split during a run, then start when no run is active.
- [Main timer game time state](https://github.com/LiveSplit/LiveSplit/blob/master/src/LiveSplit.Core/Model/LiveSplitState.cs#L203-L214) - how reported game time becomes loading time.
- [Main timer actions](https://github.com/LiveSplit/LiveSplit/blob/master/src/LiveSplit.Core/Model/TimerModel.cs#L33-L56) - how start, game time init, and split change the timer.
