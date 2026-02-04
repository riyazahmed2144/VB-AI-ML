from selenium.webdriver.common.by import By
from utils.browser_setup import get_driver
import time

driver = get_driver()

try:
    driver.get("https://example.com")
    driver.find_element(By.TAG_NAME, "a").click()
    time.sleep(2)

    assert "iana" in driver.current_url
    print("Navigation Test Passed")

finally:
    driver.quit()