"""
Appium driver configuration for iOS performance testing of the BaseViper app.
"""

import os
from appium import webdriver
from appium.options import XCUITestOptions


# Default values that can be overridden via environment variables
APPIUM_SERVER_URL = os.environ.get("APPIUM_SERVER_URL", "http://127.0.0.1:4723")
IOS_DEVICE_NAME = os.environ.get("IOS_DEVICE_NAME", "iPhone 15")
IOS_PLATFORM_VERSION = os.environ.get("IOS_PLATFORM_VERSION", "17.0")
APP_BUNDLE_ID = os.environ.get("APP_BUNDLE_ID", "com.remigio.VIPER")
APP_PATH = os.environ.get(
    "APP_PATH",
    os.path.join(
        os.path.expanduser("~"),
        "Library",
        "Developer",
        "Xcode",
        "DerivedData",
        "VIPER-*",
        "Build",
        "Products",
        "Debug-iphonesimulator",
        "VIPER.app",
    ),
)
AUTOMATION_NAME = "XCUITest"
NEW_COMMAND_TIMEOUT = 120


def create_driver() -> webdriver.Remote:
    """Create and return a configured Appium WebDriver for iOS testing.

    The driver is configured to run against the BaseViper iOS app using the
    XCUITest automation engine.  All settings can be overridden via the
    environment variables documented at the top of this module.

    Returns:
        A connected ``appium.webdriver.Remote`` instance ready for testing.

    Raises:
        Exception: If the Appium server is unreachable or the application
            cannot be launched on the target simulator/device.
    """
    options = XCUITestOptions()
    options.platform_name = "iOS"
    options.device_name = IOS_DEVICE_NAME
    options.platform_version = IOS_PLATFORM_VERSION
    options.app = APP_PATH
    options.bundle_id = APP_BUNDLE_ID
    options.automation_name = AUTOMATION_NAME
    options.new_command_timeout = NEW_COMMAND_TIMEOUT

    # Improve stability and reduce unnecessary resets between tests
    options.no_reset = False
    options.full_reset = False

    # Allow Appium to handle alerts automatically so they don't block tests
    options.auto_accept_alerts = True

    driver = webdriver.Remote(APPIUM_SERVER_URL, options=options)
    return driver
