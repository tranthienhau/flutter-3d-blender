# Screenshot capture flow

Real captures from the iOS Simulator via an integration-test driver (no mockups).

## Steps

1. Boot the simulator:
   ```bash
   xcrun simctl boot "iPhone 17 Pro"
   open -a Simulator
   ```
2. Scaffold the iOS platform folder (lib-only project) and get dependencies:
   ```bash
   flutter create . --platforms=ios --project-name flutter_3d_blender
   flutter pub get
   ```
3. Drive the screenshot test:
   ```bash
   flutter drive \
     --driver test_driver/integration_test.dart \
     --target integration_test/screenshot_test.dart \
     -d "iPhone 17 Pro"
   ```
4. Build the demo GIF from the PNGs:
   ```bash
   cd screenshots
   ffmpeg -y -framerate 1 -pattern_type glob -i '*.png' \
     -vf "scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
     -loop 0 demo.gif
   ```

PNGs + `demo.gif` are written to `screenshots/` and embedded in `README.md`.

## How it works

- `test_driver/integration_test.dart` - `integrationDriver(onScreenshot:)` writes each PNG to `screenshots/<name>.png`.
- `integration_test/screenshot_test.dart` - pumps each screen directly inside a themed `ProviderScope` + `MaterialApp` (avoiding go_router and any heavy init), then calls `binding.convertFlutterSurfaceToImage()` + `binding.takeScreenshot('NN-name')` at each key view:
  - `01-home` - the `HomeScreen` pipeline overview (Blender to Flutter bullet list and actions).
  - `02-live-scene` - the `SceneScreen` running the custom GLSL fragment shader. Because it drives a continuous `Ticker` animation, the test uses fixed `tester.pump(Duration(milliseconds: 250))` steps instead of `pumpAndSettle` (which would hang on the always-on animation) to let the shader and perf overlay settle before the shot.
  - `03-gpu-budgets` - the `BudgetsScreen` with `perfProvider` overridden by a seeded in-budget `PerfSnapshot` (60 fps, 42180 triangles, 3 draw calls, 4 MB textures) so the panel renders real green in-budget metrics instead of an empty zero state.
