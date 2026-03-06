"""
Base test class with performance measurement utilities.

All concrete performance test classes should inherit from
:class:`BasePerformanceTest` rather than directly from ``unittest.TestCase`` or
the pytest base.  The class wires up:

* Appium driver lifecycle (create before each test, quit after each test).
* Convenience wrappers for timing, memory sampling, and FPS sampling.
* Automatic screenshot capture on test failure.
* Integration with :class:`~utils.reporter.PerformanceReporter` and
  :class:`~utils.baseline.PerformanceBaseline`.
"""

import os
import time
import unittest

from utils.appium_driver import create_driver
from utils.baseline import PerformanceBaseline
from utils.metrics import (
    PerformanceSample,
    Timer,
    measure_fps,
    measure_memory_mb,
)
from utils.reporter import PerformanceReporter

_SCREENSHOT_DIR = os.path.join(os.path.dirname(__file__), "reports", "screenshots")


class BasePerformanceTest(unittest.TestCase):
    """Base class for Appium iOS performance tests.

    Subclasses can override :attr:`ITERATIONS` to control how many times a
    single scenario is repeated when using :meth:`measure_repeated`.

    Class-level attributes
    ----------------------
    reporter : PerformanceReporter
        Shared reporter instance that accumulates samples across all tests in
        the class.  A text and JSON report are written in
        :meth:`tearDownClass`.
    baseline : PerformanceBaseline
        Loaded baseline thresholds used by :meth:`assert_within_baseline`.
    """

    ITERATIONS: int = 3
    reporter: PerformanceReporter
    baseline: PerformanceBaseline

    @classmethod
    def setUpClass(cls) -> None:
        super().setUpClass()
        cls.reporter = PerformanceReporter()
        cls.baseline = PerformanceBaseline()

    @classmethod
    def tearDownClass(cls) -> None:
        try:
            text_path = cls.reporter.write_text_report()
            json_path = cls.reporter.write_json_report()
            print(f"\nPerformance reports written:\n  {text_path}\n  {json_path}")
        except Exception as exc:  # noqa: BLE001
            print(f"Warning: could not write performance reports: {exc}")
        super().tearDownClass()

    def setUp(self) -> None:
        """Create a fresh Appium driver before each test method."""
        self.driver = create_driver()
        # Give the app a moment to settle after launch
        time.sleep(1.5)

    def tearDown(self) -> None:
        """Capture a screenshot on failure then quit the driver."""
        if self._outcome and not self._outcome.success:
            self._capture_screenshot_on_failure()
        try:
            self.driver.quit()
        except Exception:  # noqa: BLE001
            pass

    # ------------------------------------------------------------------
    # Measurement helpers
    # ------------------------------------------------------------------

    def measure_load_time(
        self, action, label: str, *, capture_memory: bool = True, capture_fps: bool = True
    ) -> PerformanceSample:
        """Execute *action*, measure its duration, and return a :class:`PerformanceSample`.

        The sample is automatically recorded in :attr:`reporter`.

        Args:
            action: Zero-argument callable representing the UI action to time.
            label: Human-readable name for this measurement (used in reports).
            capture_memory: Whether to sample resident memory after the action.
            capture_fps: Whether to sample FPS after the action.

        Returns:
            The :class:`PerformanceSample` created for this measurement.
        """
        memory_before = measure_memory_mb(self.driver)

        with Timer() as t:
            action()

        memory_after = measure_memory_mb(self.driver) if capture_memory else None
        fps = measure_fps(self.driver) if capture_fps else None

        # Use the delta when before/after memory is available; otherwise use
        # the post-action snapshot.
        if memory_before is not None and memory_after is not None:
            memory_mb = memory_after - memory_before
        else:
            memory_mb = memory_after

        sample = PerformanceSample(
            label=label,
            load_time_seconds=t.elapsed,
            memory_mb=memory_mb,
            fps=fps,
        )
        self.reporter.record(sample)
        return sample

    def measure_repeated(
        self,
        action,
        label: str,
        *,
        iterations: Optional[int] = None,
        capture_memory: bool = True,
        capture_fps: bool = True,
    ) -> "list[PerformanceSample]":
        """Repeat *action* :attr:`ITERATIONS` times and collect samples.

        Args:
            action: Zero-argument callable to time.
            label: Human-readable label used in reports.
            iterations: Override :attr:`ITERATIONS` for this call.
            capture_memory: Whether to sample resident memory for each run.
            capture_fps: Whether to sample FPS for each run.

        Returns:
            List of :class:`PerformanceSample` objects, one per iteration.
        """
        n = iterations if iterations is not None else self.ITERATIONS
        samples = []
        for _ in range(n):
            sample = self.measure_load_time(
                action,
                label,
                capture_memory=capture_memory,
                capture_fps=capture_fps,
            )
            samples.append(sample)
        return samples

    def assert_within_baseline(
        self,
        test_name: str,
        sample: PerformanceSample,
    ) -> None:
        """Assert that *sample* metrics do not exceed their baseline thresholds.

        Args:
            test_name: Key in ``baselines/performance_baselines.json``.
            sample: The performance sample to validate.

        Raises:
            AssertionError: If any metric exceeds its threshold.
        """
        self.baseline.assert_all(
            test_name,
            load_time_seconds=sample.load_time_seconds,
            memory_mb=sample.memory_mb,
            fps=sample.fps,
        )

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    def _capture_screenshot_on_failure(self) -> None:
        """Save a PNG screenshot to the reports/screenshots directory."""
        os.makedirs(_SCREENSHOT_DIR, exist_ok=True)
        timestamp = time.strftime("%Y%m%d_%H%M%S")
        test_name = self.id().replace(".", "_")
        path = os.path.join(_SCREENSHOT_DIR, f"{test_name}_{timestamp}.png")
        try:
            self.driver.save_screenshot(path)
            print(f"\nFailure screenshot saved: {path}")
        except Exception as exc:  # noqa: BLE001
            print(f"Warning: could not capture screenshot: {exc}")
