BALL KUN RIDER FARM DATA COLLECTOR v0.3.0
===========================================

Added Manual Data Picker:
- Press MANUAL PICK to open a searchable list of client-visible Instances.
- Press Scan/Refresh to rebuild the list.
- Tap one item at a time to export its metadata and descendant tree.
- Exports are saved separately under BALL_KUN_Dump/<map>_<PlaceId>/manual/.
- Search supports Instance name, ClassName, and full path.
- Manual exports include hierarchy, visible properties, values, attributes, and tags.

Safety and limitations:
- Metadata-only inspection of Instances visible to the local client.
- Does not invoke RemoteEvents/RemoteFunctions or replay requests.
- Does not bypass Roblox source protections or decompile protected third-party scripts.
- Script Activity Monitor continues to report script names/classes/paths only.
- Use only in experiences and code you own or are authorized to inspect.

Existing features:
- Script Activity Monitor metadata
- Workspace, GUI, vehicle, NPC, prompt, value, and remote-name/path scans
- Tagged snapshots and per-module dump files

Usage:
1. Run the Lua file in an authorized test experience.
2. Press MANUAL PICK.
3. Search or scroll, then tap an Instance to export it individually.
4. Find output under BALL_KUN_Dump/<map>_<PlaceId>/manual/.


AI Map Analyzer (v0.3.0):
- Press AI ANALYZE to rescan client-visible Instances and calculate explainable keyword/class scores.
- Groups likely Farm, Job, Shop, Vehicle, Reward, and Spawn objects.
- Counts prompts, GUI objects, values, vehicle seats, remotes (metadata only), and positioned objects.
- Exports ranked candidates with confidence hints, paths, positions, and nearest prompt distance to ai/*.txt and ai/*.json.
- This is local heuristic analysis, not a trained/cloud AI model; confidence is a ranking hint, not proof.
- Take snapshots after opening dynamic GUI panels to include newly visible state.
- No remote invocation, traffic interception, protected-source extraction, or server-data access.
