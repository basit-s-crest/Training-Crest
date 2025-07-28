import requests
from bs4 import BeautifulSoup
url = 'https://www.python.org/'
reqs = requests.get(url)
soup = BeautifulSoup(reqs.text, 'lxml')
print("title")
print(soup.title)
print("title text")
print(soup.title.text)
print("Parent content of the title:")
print(soup.title.parent)
