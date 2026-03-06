# BaseViper iOS — Appium Performance Test Suite

A Python-based Appium test suite that measures and analyses performance when opening `ViewControllers` in the BaseViper iOS application.

## Directory Layout

```
tests/performance/
├── README.md                          ← This file
├── requirements.txt                   ← Python dependencies
├── conftest.py                        ← pytest fixtures (driver, reporter, baseline)
├── base_test.py                       ← Base test class with timing / memory / FPS helpers
├── test_view_controller_performance.py← All performance test scenarios
├── baselines/
│   └── performance_baselines.json     ← Threshold values per test scenario
├── reports/                           ← Auto-generated reports (git-ignored)
│   └── screenshots/                   ← Failure screenshots (git-ignored)
└── utils/
    ├── appium_driver.py               ← Appium driver factory
    ├── baseline.py                    ← Baseline comparison helpers
    ├── metrics.py                     ← Timing, memory and FPS utilities
    └── reporter.py                    ← Text and JSON report generation
```

---

## Prerequisites

| Tool | Version |
|------|---------|
| Python | 3.10+ |
| Xcode | 15+ |
| Appium | 2.x (`npm install -g appium`) |
| Appium XCUITest driver | latest (`appium driver install xcuitest`) |
| iOS Simulator | booted, matching `IOS_DEVICE_NAME` / `IOS_PLATFORM_VERSION` |

---

## Installation

```bash
# 1. (Recommended) Create and activate a virtual environment
python3 -m venv .venv
source .venv/bin/activate

# 2. Install Python dependencies
pip install -r tests/performance/requirements.txt

# 3. Build the BaseViper app for the simulator
xcodebuild \
    -project VIPER.xcodeproj \
    -scheme VIPER \
    -sdk iphonesimulator \
    -configuration Debug \
    build
```

---

## Configuration

All settings can be overridden with environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `APPIUM_SERVER_URL` | `http://127.0.0.1:4723` | Appium server URL |
| `IOS_DEVICE_NAME` | `iPhone 15` | Simulator / device name |
| `IOS_PLATFORM_VERSION` | `17.0` | iOS version string |
| `APP_BUNDLE_ID` | `com.remigio.VIPER` | App bundle identifier |
| `APP_PATH` | `~/Library/…/VIPER.app` | Path to the `.app` bundle |

Example:

```bash
export IOS_DEVICE_NAME="iPhone 14 Pro"
export IOS_PLATFORM_VERSION="16.4"
```

---

## Running the Tests

```bash
# Start the Appium server (in a separate terminal)
appium --port 4723

# Run all performance tests
cd tests/performance
pytest test_view_controller_performance.py -v

# Run a specific test class
pytest test_view_controller_performance.py::TestInitialViewControllerPerformance -v

# Run with an HTML report
pytest test_view_controller_performance.py -v --html=reports/pytest_report.html
```

---

## Test Scenarios

### `TestInitialViewControllerPerformance`
Measures cold-start time from app activation until `ExampleViewController` is fully interactive.  Repeated `ITERATIONS` (default 3) times.

### `TestViewControllerNavigationPerformance`
Measures the round-trip time for selecting a table-view cell (which triggers `ExamplePresenter.selectedItem` → `ExampleRouter.presentTest`) and dismissing the resulting alert.

### `TestConcurrentViewLoading`
Simulates rapid sequential app launches (5 iterations) to stress-test view initialisation and verify that load-time standard deviation stays below 1 second.

### `TestMemoryProfilingDuringViewLifecycle`
Samples resident memory before and after key lifecycle events.  On iOS simulators, memory info is not available from Appium; those assertions are automatically skipped.

### `TestViewLifecycleMethodTiming`
Approximates the combined execution time of `viewDidLoad()` and `viewWillAppear()` by measuring from `activateApp` until the first interactive UI element appears.

---

## Performance Baselines

Thresholds are stored in `baselines/performance_baselines.json`.  Update them as the app evolves:

```json
{
  "initial_view_controller_load": {
    "max_load_time_seconds": 3.0,
    "max_memory_mb": 30.0,
    "min_fps": 55.0
  }
}
```

Supported keys per scenario:

| Key | Unit | Meaning |
|-----|------|---------|
| `max_load_time_seconds` | seconds | Upper bound on load time |
| `max_memory_mb` | MB | Upper bound on memory delta |
| `min_fps` | frames/s | Lower bound on FPS |

---

## Generated Reports

After each test run two reports are written to `reports/`:

* **`performance_report_<timestamp>.txt`** — human-readable summary table.
* **`performance_report_<timestamp>.json`** — machine-readable metrics for CI integration.

Failure screenshots are saved to `reports/screenshots/`.

---

## Interpreting Results

| Metric | What it tells you |
|--------|------------------|
| `avg_load_time` | Typical user-perceived latency for the scenario |
| `stddev_load_time` | Consistency — high values suggest environmental noise or a regression |
| `avg_memory_mb` | Memory growth per lifecycle event |
| `avg_fps` | Rendering smoothness (real devices only) |

A test failure means one of:

1. A metric exceeded a **baseline threshold** → update the threshold if intentional, or investigate the regression.
2. A hard-coded limit was breached (e.g. `> 5 s` for lifecycle proxy tests) → the app is unusually slow.
3. The Appium session could not interact with the element in time → check the simulator/device state.
