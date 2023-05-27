import json
import threading
from time import sleep
import requests
from languages import supportLanguages
import random
import calendar
import time
import hashlib
import os
from pathlib import Path

baseUrl = 'https://api.translasion.com/v2/translate'

headers = {'APP-KEY': 'aa466fe2a01b', "PACKAGE-NAME": "com.zaz.translate",
           "API-KEY": "eb298ebd8ac6c5c6c34d0fab40b871dc",
           "PACKAGE-SIGN": "ebd663baf5c6e7e4139675407b8216914bca417a",
           "Content-Type": "application/json; charset=UTF-8"}

appKey = '9570819f7483'


def string_to_md5(string):
    md5_val = hashlib.md5(string.encode('utf8')).hexdigest()
    return md5_val


def translate_single(language):
    print("start translate:" + language)

    my_file = Path('intl_' + language + '.arb')
    origin_map = {}
    if my_file.exists():
        f = open(my_file, 'r')
        json_str = f.read()
        origin_map = json.loads(json_str)
    resultMap = {}
    for key, value in items:
        current_GMT = time.gmtime()

        time_stamp = calendar.timegm(current_GMT)

        nonce = str(random.randint(1000,9999))

        secret = "ff031bc5-21bd-1ca9-e67d-b2258d8932fb"

        #print(time_stamp)
        sig = string_to_md5(appKey + '&' + language  + '&'+ str(time_stamp) + '&' + secret + '&' + nonce)

        #print(sig)
        
        requestData = {'from': 'en', 'app_key': appKey, 'to': language, 'sig': sig,
                    'nonce': nonce, "timestamp": time_stamp}

        # 如果是词典，考虑是占位符
        if type(value).__name__ == 'dict':
            resultMap[key] = value
            continue
        if origin_map.__contains__(key):
            #如果以前存在的，不再翻译
            resultMap[key] = origin_map[key]
            continue

        requestData['text'] = value
        # print(requestData)
        sleep(random.randint(1, 3))

        try:
            print("start translate")
            response = requests.post(baseUrl, json=requestData, timeout=3)

            print(response.text)
            translated = json.loads(response.text).get('result').get('text')

            # print('value:' + translated)
            resultMap[key] = translated
        except:
            print("translate error")
            #resultMap[key] = value

    json_object = json.dumps(resultMap, ensure_ascii=False, indent=2)
    print(json_object)
    with open('intl_' + language + '.arb', 'w') as jsonFile:
        jsonFile.write(json_object)


with open('intl_en.arb', 'r') as f:
    data = json.load(f)

    items = data.items()


class myThread(threading.Thread):

    def __init__(self, language) -> None:
        threading.Thread.__init__(self=self)
        self.language = language

    def translate(self):
        translate_single(self.language)

    def run(self) -> None:
        print("run language:" + language)
        self.translate()


# test
#translate_single("zh")

list_len = len(supportLanguages)
middle_index = list_len // 2

for language in supportLanguages:
    try:
        translate_single(language)
    except:
        pass    
    sleep(4)
    # print("langugae:" + language)

    #sleep(20)
    #myThread(language=language).start()
    # threading.start_new_thread( translate, (language, ) )

# for language in supportLanguages[middle_index:]:
#     sleep(30)
#     myThread(language=language).start()