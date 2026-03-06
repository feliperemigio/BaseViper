"""
Performance metrics collection utilities.

Provides helpers for measuring load times, sampling memory usage and FPS, and
aggregating raw samples into descriptive statistics.
"""

import statistics
import time
from dataclasses import dataclass, field
from typing import List, Optional


@dataclass
class PerformanceSample:
    """A single performance observation captured during a test."""

    label: str
    load_time_seconds: float
    memory_mb: Optional[float] = None
    fps: Optional[float] = None
    timestamp: float = field(default_factory=time.time)


@dataclass
class AggregatedMetrics:
    """Descriptive statistics computed from a list of :class:`PerformanceSample` objects."""

    label: str
    count: int
    min_load_time: float
    max_load_time: float
    avg_load_time: float
    stddev_load_time: float
    min_memory_mb: Optional[float]
    max_memory_mb: Optional[float]
    avg_memory_mb: Optional[float]
    min_fps: Optional[float]
    max_fps: Optional[float]
    avg_fps: Optional[float]


def aggregate(samples: List[PerformanceSample]) -> AggregatedMetrics:
    """Aggregate a list of performance samples into descriptive statistics.

    Args:
        samples: Non-empty list of :class:`PerformanceSample` instances that
            all share the same ``label``.

    Returns:
        An :class:`AggregatedMetrics` instance summarising the samples.

    Raises:
        ValueError: If *samples* is empty.
    """
    if not samples:
        raise ValueError("Cannot aggregate an empty list of samples.")

    load_times = [s.load_time_seconds for s in samples]
    memory_values = [s.memory_mb for s in samples if s.memory_mb is not None]
    fps_values = [s.fps for s in samples if s.fps is not None]

    stddev = statistics.stdev(load_times) if len(load_times) > 1 else 0.0

    return AggregatedMetrics(
        label=samples[0].label,
        count=len(samples),
        min_load_time=min(load_times),
        max_load_time=max(load_times),
        avg_load_time=statistics.mean(load_times),
        stddev_load_time=stddev,
        min_memory_mb=min(memory_values) if memory_values else None,
        max_memory_mb=max(memory_values) if memory_values else None,
        avg_memory_mb=statistics.mean(memory_values) if memory_values else None,
        min_fps=min(fps_values) if fps_values else None,
        max_fps=max(fps_values) if fps_values else None,
        avg_fps=statistics.mean(fps_values) if fps_values else None,
    )


class Timer:
    """Simple context-manager stopwatch.

    Usage::

        with Timer() as t:
            do_something()
        print(t.elapsed)
    """

    def __init__(self) -> None:
        self._start: float = 0.0
        self.elapsed: float = 0.0

    def __enter__(self) -> "Timer":
        self._start = time.perf_counter()
        return self

    def __exit__(self, *_) -> None:
        self.elapsed = time.perf_counter() - self._start


def measure_memory_mb(driver) -> Optional[float]:
    """Return the resident memory usage (in MB) of the app under test.

    The memory value is retrieved via Appium's ``mobile: getMemoryInfo``
    command, which is only available when targeting a real device with the
    XCUITest driver.  On simulators the command may not be supported; in that
    case ``None`` is returned so that callers can treat memory metrics as
    optional.

    Args:
        driver: An active Appium WebDriver session.

    Returns:
        Memory usage in megabytes, or ``None`` if unavailable.
    """
    try:
        info = driver.execute_script("mobile: getMemoryInfo")
        if info and "appPhysicalMemory" in info:
            return info["appPhysicalMemory"] / (1024 * 1024)
    except Exception:
        pass
    return None


def measure_fps(driver) -> Optional[float]:
    """Return the current frames-per-second reported by the app under test.

    FPS is retrieved via Appium's ``mobile: getFPS`` execute script command.
    The value is only available on real devices; ``None`` is returned when the
    command is unsupported (e.g., on simulators).

    Args:
        driver: An active Appium WebDriver session.

    Returns:
        Frames per second as a float, or ``None`` if unavailable.
    """
    try:
        result = driver.execute_script("mobile: getFPS")
        if result is not None:
            return float(result)
    except Exception:
        pass
    return None
