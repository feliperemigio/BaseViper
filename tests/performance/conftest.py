"""
pytest configuration and fixtures for the BaseViper performance test suite.

This module is automatically loaded by pytest when running tests inside the
``tests/performance/`` directory.  It adds the package root to ``sys.path``
so that ``from utils.xxx import ...`` works without an editable install.
"""

import sys
import os

import pytest

# Make the ``tests/performance`` directory importable as a package root so
# that relative imports (``from utils.xxx import ...``) resolve correctly
# regardless of the directory from which pytest is invoked.
_PERF_DIR = os.path.dirname(__file__)
if _PERF_DIR not in sys.path:
    sys.path.insert(0, _PERF_DIR)

from utils.appium_driver import create_driver  # noqa: E402
from utils.baseline import PerformanceBaseline  # noqa: E402
from utils.reporter import PerformanceReporter  # noqa: E402


# ---------------------------------------------------------------------------
# Session-scoped fixtures
# ---------------------------------------------------------------------------


@pytest.fixture(scope="session")
def performance_reporter():
    """Shared :class:`~utils.reporter.PerformanceReporter` for the whole session.

    Text and JSON reports are written when the session ends.
    """
    reporter = PerformanceReporter()
    yield reporter
    try:
        text_path = reporter.write_text_report()
        json_path = reporter.write_json_report()
        print(f"\nPerformance reports written:\n  {text_path}\n  {json_path}")
    except Exception as exc:  # noqa: BLE001
        print(f"Warning: could not write performance reports: {exc}")


@pytest.fixture(scope="session")
def performance_baseline():
    """Shared :class:`~utils.baseline.PerformanceBaseline` for the whole session."""
    return PerformanceBaseline()


# ---------------------------------------------------------------------------
# Function-scoped fixtures
# ---------------------------------------------------------------------------


@pytest.fixture()
def appium_driver():
    """Provide a fresh Appium driver for a single test, then quit it.

    Yields:
        An active ``appium.webdriver.Remote`` session pointed at the BaseViper
        app on an iOS simulator or device.
    """
    driver = create_driver()
    yield driver
    try:
        driver.quit()
    except Exception:  # noqa: BLE001
        pass


@pytest.fixture()
def app_driver(appium_driver):
    """Alias for :func:`appium_driver` that waits for the app to settle."""
    import time

    time.sleep(1.5)
    return appium_driver
