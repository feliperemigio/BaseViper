"""
Performance tests for opening ViewControllers in the BaseViper iOS app.

Each test class targets a specific aspect of view-controller lifecycle
performance.  Tests are written using the standard ``unittest.TestCase`` API
(compatible with pytest) and inherit from :class:`~base_test.BasePerformanceTest`
to get driver management, timing helpers, and baseline assertions for free.

Running these tests requires:

* A running Appium server (``appium`` CLI or Appium Desktop).
* A booted iOS simulator or connected real device.
* The BaseViper app installed on the target device/simulator.

See ``README.md`` for full setup instructions.
"""

import time
import unittest

from appium.webdriver.common.appiumby import AppiumBy

from base_test import BasePerformanceTest
from utils.metrics import aggregate, measure_fps, measure_memory_mb, PerformanceSample


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

_TABLE_VIEW_ACCESSIBILITY_ID = "tableView"


def _wait_for_element(driver, locator, value, timeout: float = 10.0):
    """Poll for an element until it appears or *timeout* elapses.

    Args:
        driver: Active Appium driver.
        locator: Appium ``By`` strategy (e.g. ``AppiumBy.ACCESSIBILITY_ID``).
        value: The locator value to search for.
        timeout: Maximum seconds to wait.

    Returns:
        The first matching element.

    Raises:
        TimeoutError: If the element does not appear within *timeout* seconds.
    """
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        elements = driver.find_elements(locator, value)
        if elements:
            return elements[0]
        time.sleep(0.2)
    raise TimeoutError(
        f"Element ({locator}='{value}') did not appear within {timeout}s."
    )


# ---------------------------------------------------------------------------
# Test: Initial ExampleViewController load
# ---------------------------------------------------------------------------


class TestInitialViewControllerPerformance(BasePerformanceTest):
    """Measure the time taken for ExampleViewController to become interactive.

    The test re-launches the app for each iteration so that every measurement
    reflects a cold-start scenario.
    """

    def _launch_and_wait(self) -> None:
        """Terminate the app, relaunch it, and wait until the table view appears."""
        self.driver.terminate_app(self.driver.capabilities.get("bundleId", "com.remigio.VIPER"))
        time.sleep(0.5)
        self.driver.activate_app(self.driver.capabilities.get("bundleId", "com.remigio.VIPER"))
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

    def test_initial_view_controller_load_performance(self) -> None:
        """ExampleViewController must appear within the baseline threshold.

        The test is repeated :attr:`ITERATIONS` times.  Each iteration
        terminates and relaunches the app to simulate a fresh launch.  The
        average load time and memory delta are asserted against the configured
        baselines.
        """
        samples = self.measure_repeated(self._launch_and_wait, "initial_view_controller_load")

        metrics = aggregate(samples)
        print(
            f"\n[initial_view_controller_load] avg={metrics.avg_load_time:.3f}s "
            f"min={metrics.min_load_time:.3f}s max={metrics.max_load_time:.3f}s"
        )

        # Assert each individual sample so a single slow run is flagged
        for sample in samples:
            self.assert_within_baseline("initial_view_controller_load", sample)

    def test_view_controller_renders_table(self) -> None:
        """ExampleViewController must display a table view cell after launch."""
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")
        cells = self.driver.find_elements(AppiumBy.CLASS_NAME, "XCUIElementTypeCell")
        self.assertGreater(len(cells), 0, "Table view should contain at least one cell.")


# ---------------------------------------------------------------------------
# Test: Navigation performance
# ---------------------------------------------------------------------------


class TestViewControllerNavigationPerformance(BasePerformanceTest):
    """Measure the time taken to navigate into and back from a presented screen.

    ``ExampleViewController`` presents an ``UIAlertController`` when a table
    row is selected.  We measure the end-to-end time from tap to the alert
    being visible and from dismissal to the table being visible again.
    """

    def _tap_first_cell(self) -> None:
        """Tap the first cell in the table view."""
        cell = _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeCell")
        cell.click()

    def _dismiss_alert(self) -> None:
        """Dismiss the presented alert by tapping its 'OK' button."""
        ok_button = _wait_for_element(self.driver, AppiumBy.ACCESSIBILITY_ID, "OK")
        ok_button.click()

    def _navigate_and_dismiss(self) -> None:
        """Tap a cell (triggering presentation) then dismiss the alert."""
        self._tap_first_cell()
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeAlert")
        self._dismiss_alert()
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

    def test_view_controller_navigation_performance(self) -> None:
        """Navigation round-trip must complete within the baseline threshold."""
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

        samples = self.measure_repeated(
            self._navigate_and_dismiss, "view_controller_navigation"
        )

        metrics = aggregate(samples)
        print(
            f"\n[view_controller_navigation] avg={metrics.avg_load_time:.3f}s "
            f"min={metrics.min_load_time:.3f}s max={metrics.max_load_time:.3f}s"
        )

        for sample in samples:
            self.assert_within_baseline("view_controller_navigation", sample)

    def test_alert_appears_after_cell_tap(self) -> None:
        """Tapping a table cell must present an alert controller."""
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")
        self._tap_first_cell()
        alert = _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeAlert")
        self.assertIsNotNone(alert, "Alert controller should appear after cell tap.")


# ---------------------------------------------------------------------------
# Test: Concurrent view loading
# ---------------------------------------------------------------------------


class TestConcurrentViewLoading(BasePerformanceTest):
    """Simulate rapid consecutive launches to stress-test view initialisation.

    Rather than true thread-level concurrency (which is not possible from a
    single Appium client), this test replicates *rapid sequential* launches in
    close succession to stress-test the view initialisation path.
    """

    ITERATIONS = 5

    def _rapid_launch(self) -> None:
        """Terminate and relaunch the app, waiting for the table to appear."""
        bundle_id = self.driver.capabilities.get("bundleId", "com.remigio.VIPER")
        self.driver.terminate_app(bundle_id)
        self.driver.activate_app(bundle_id)
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

    def test_concurrent_view_loading_performance(self) -> None:
        """Repeated rapid launches must each complete within the baseline threshold."""
        samples = self.measure_repeated(
            self._rapid_launch, "concurrent_view_loading", iterations=self.ITERATIONS
        )

        metrics = aggregate(samples)
        print(
            f"\n[concurrent_view_loading] avg={metrics.avg_load_time:.3f}s "
            f"stddev={metrics.stddev_load_time:.3f}s"
        )

        for sample in samples:
            self.assert_within_baseline("concurrent_view_loading", sample)

    def test_load_time_consistency(self) -> None:
        """Standard deviation of load times must be below 1 second."""
        samples = self.measure_repeated(
            self._rapid_launch, "load_time_consistency", iterations=self.ITERATIONS
        )
        metrics = aggregate(samples)
        self.assertLess(
            metrics.stddev_load_time,
            1.0,
            f"Load time standard deviation {metrics.stddev_load_time:.3f}s is too high.",
        )


# ---------------------------------------------------------------------------
# Test: Memory profiling
# ---------------------------------------------------------------------------


class TestMemoryProfilingDuringViewLifecycle(BasePerformanceTest):
    """Profile memory usage across the view controller lifecycle.

    Memory values are only available on real devices.  On simulators the
    memory fields in :class:`~utils.metrics.PerformanceSample` will be ``None``
    and the assertions are skipped automatically.
    """

    def test_memory_during_initial_load(self) -> None:
        """Memory usage during the initial load must not exceed the baseline."""
        bundle_id = self.driver.capabilities.get("bundleId", "com.remigio.VIPER")

        def _relaunch():
            self.driver.terminate_app(bundle_id)
            self.driver.activate_app(bundle_id)
            _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

        sample = self.measure_load_time(_relaunch, "memory_initial_load")
        self.assert_within_baseline("memory_initial_load", sample)

    def test_memory_stable_after_navigation(self) -> None:
        """Memory usage should not grow significantly after repeated navigation.

        Each navigate-and-dismiss cycle is sampled.  The memory of the last
        sample must not exceed the baseline for this scenario.
        """
        _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

        def _cycle():
            cell = _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeCell")
            cell.click()
            _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeAlert")
            ok_btn = _wait_for_element(self.driver, AppiumBy.ACCESSIBILITY_ID, "OK")
            ok_btn.click()
            _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

        samples = self.measure_repeated(_cycle, "memory_navigation_stability")
        last_sample = samples[-1]
        self.assert_within_baseline("memory_navigation_stability", last_sample)

    def test_no_memory_leak_across_launches(self) -> None:
        """Memory usage must not grow monotonically across repeated launches.

        A strict monotonic increase in memory is treated as a potential leak.
        This check is skipped when memory info is unavailable (simulator).
        """
        bundle_id = self.driver.capabilities.get("bundleId", "com.remigio.VIPER")

        def _relaunch():
            self.driver.terminate_app(bundle_id)
            self.driver.activate_app(bundle_id)
            _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")

        samples = self.measure_repeated(
            _relaunch, "memory_leak_check", iterations=4
        )

        memory_values = [s.memory_mb for s in samples if s.memory_mb is not None]
        if len(memory_values) < 2:
            self.skipTest("Memory info unavailable on this device/simulator.")

        is_monotonically_increasing = all(
            memory_values[i] < memory_values[i + 1]
            for i in range(len(memory_values) - 1)
        )
        self.assertFalse(
            is_monotonically_increasing,
            "Memory usage grew on every consecutive launch — possible memory leak.",
        )


# ---------------------------------------------------------------------------
# Test: viewDidLoad / viewWillAppear timing
# ---------------------------------------------------------------------------


class TestViewLifecycleMethodTiming(BasePerformanceTest):
    """Approximate the execution time of ``viewDidLoad()`` and ``viewWillAppear()``.

    Because the Appium client cannot directly hook into Swift lifecycle methods,
    we approximate timing by measuring the interval between app activation and
    the appearance of the first interactive element — which is a proxy for
    the combined ``viewDidLoad`` + ``viewWillAppear`` + layout pass duration.
    """

    def _measure_lifecycle(self, label: str) -> PerformanceSample:
        """Relaunch the app and time until the table view cell is visible."""
        bundle_id = self.driver.capabilities.get("bundleId", "com.remigio.VIPER")

        def _action():
            self.driver.terminate_app(bundle_id)
            self.driver.activate_app(bundle_id)
            _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeCell")

        return self.measure_load_time(_action, label)

    def test_view_did_load_proxy_performance(self) -> None:
        """Proxy for ``viewDidLoad()`` must complete within the baseline threshold."""
        sample = self._measure_lifecycle("view_did_load_proxy")
        self.assert_within_baseline("view_did_load_proxy", sample)
        self.assertLess(
            sample.load_time_seconds,
            5.0,
            "viewDidLoad proxy time exceeded the 5-second hard limit.",
        )

    def test_view_will_appear_proxy_performance(self) -> None:
        """Proxy for ``viewWillAppear()`` must complete within the baseline threshold.

        We approximate ``viewWillAppear`` as the time from app activation until
        the table is fully rendered and interactive (indicated by the presence
        of at least one visible cell).
        """
        bundle_id = self.driver.capabilities.get("bundleId", "com.remigio.VIPER")

        def _action():
            self.driver.terminate_app(bundle_id)
            self.driver.activate_app(bundle_id)
            # Wait for the table view to be both visible and populated
            _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeTable")
            cells = self.driver.find_elements(AppiumBy.CLASS_NAME, "XCUIElementTypeCell")
            if not cells:
                raise AssertionError("Table rendered but no cells found.")

        sample = self.measure_load_time(_action, "view_will_appear_proxy")
        self.assert_within_baseline("view_will_appear_proxy", sample)
        self.assertLess(
            sample.load_time_seconds,
            5.0,
            "viewWillAppear proxy time exceeded the 5-second hard limit.",
        )

    def test_repeated_view_lifecycle_consistency(self) -> None:
        """Repeated lifecycle measurements must be consistent (low std dev)."""
        bundle_id = self.driver.capabilities.get("bundleId", "com.remigio.VIPER")

        def _action():
            self.driver.terminate_app(bundle_id)
            self.driver.activate_app(bundle_id)
            _wait_for_element(self.driver, AppiumBy.CLASS_NAME, "XCUIElementTypeCell")

        samples = self.measure_repeated(_action, "lifecycle_consistency")
        metrics = aggregate(samples)
        self.assertLess(
            metrics.stddev_load_time,
            1.0,
            f"Lifecycle timing std dev {metrics.stddev_load_time:.3f}s is too variable.",
        )


if __name__ == "__main__":
    unittest.main()
