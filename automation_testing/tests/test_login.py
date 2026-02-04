from selenium.webdriver.common.by import By
from utils.browser_setup import get_driver
import time

driver = get_driver()

try:
    driver.get("https://the-internet.herokuapp.com/login")

    driver.find_element(By.ID, "username").send_keys("tomsmith")
    driver.find_element(By.ID, "password").send_keys("SuperSecretPassword!")
    driver.find_element(By.CSS_SELECTOR, "button[type='submit']").click()

    time.sleep(2)
    msg = driver.find_element(By.ID, "flash").text
    assert "secure area" in msg.lower()
    print("Login Test Passed")

finally:
    driver.quit()