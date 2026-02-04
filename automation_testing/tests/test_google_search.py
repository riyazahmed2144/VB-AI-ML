from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from utils.browser_setup import get_driver
import time

driver = get_driver()

try:
    driver.get("https://www.google.com")

    search = driver.find_element(By.NAME, "q")
    search.send_keys("Selenium automation testing")
    search.send_keys(Keys.RETURN)

    time.sleep(3)
    assert "Selenium" in driver.title
    print("Google Search Test Passed")

finally:
    driver.quit()