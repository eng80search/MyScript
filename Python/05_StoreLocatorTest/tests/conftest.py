import pytest
from playwright.sync_api import BrowserType
from typing import Dict


@pytest.fixture(autouse=True)
def context(
    browser_type: BrowserType,
    browser_type_launch_args: Dict,
    browser_context_args: Dict
):
    context = browser_type.launch_persistent_context("", **{
        **browser_type_launch_args,
        **browser_context_args,
        "viewport": {'width': 1920, 'height': 1080},
        "args":  ['--window-position=-9,0'],
    })
    yield context
    context.close()

