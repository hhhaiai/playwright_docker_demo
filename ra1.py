from playwright.sync_api import sync_playwright

def scrape_duckduckgo_ai():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context()
        page = context.new_page()
        
        try:
            # 访问页面
            page.goto("https://duckduckgo.com/?q=DuckDuckGo+AI+Chat&ia=chat&duckai=1")
            
            # 点击 Get Started 按钮
            get_started_button_xpath = '//*[@id="react-layout"]/div/div[2]/main/div/div/div[2]/div/button'
            page.wait_for_selector(get_started_button_xpath)
            page.click(get_started_button_xpath)
            
            # 等待所有模型加载完成
            page.wait_for_function(
                "document.querySelectorAll('ul[role=\"radiogroup\"] > li').length > 0"
            )
            
            # 解析模型信息
            models_info = extract_models_info(page)
            
        except Exception as e:
            print(f"发生错误: {e}")
        finally:
            browser.close()
        
        return models_info

def extract_models_info(page):
    models_info = {}
    models = page.query_selector_all('ul[role="radiogroup"] > li')
    
    for model in models:
        # 使用更精确的选择器
        name_element = model.query_selector('.J58ouJfofMIxA2Ukt6lA')
        description_element = model.query_selector('.tDjqHxDUIeGL37tpvoSI')
        value = model.query_selector('input').get_attribute('value')
        
        if name_element:
            name = name_element.inner_text()
            description = description_element.inner_text() if description_element else ""
            models_info[name] = {
                "value": value,
                "description": description
            }
    return models_info

# 测试代码
if __name__ == "__main__":
    result = scrape_duckduckgo_ai()
    for model_name, info in result.items():
        print(f"\n模型: {model_name}")
        print(f"值: {info['value']}")
        print(f"描述: {info['description']}")