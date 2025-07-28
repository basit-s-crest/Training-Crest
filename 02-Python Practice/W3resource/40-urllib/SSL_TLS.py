import urllib3
def make_https_request_with_verification():
 
    secure_url = 'https://www.example.com'

    try:
        
        with urllib3.PoolManager() as http:
            
            response = http.request('GET', secure_url)

            
            if response.status == 200:
                print("Secure HTTPS Request Successful:")
                print(response.data.decode('utf-8'))
            else:
                print(f"Error: Unable to fetch data. Status Code: {response.status}")

    except urllib3.exceptions.RequestError as e:
        print(f"Error: {e}")

make_https_request_with_verification()