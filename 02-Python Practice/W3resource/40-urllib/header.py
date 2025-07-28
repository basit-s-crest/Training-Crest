
import urllib3

def logging_request_hook(response, *args, **kwargs):
   
    print(f"Received response with status code: {response.status}")
    print(f"Response Headers: {response.headers}")

def make_sample_request():
    
    http = urllib3.PoolManager()

    
    sample_url = 'https://www.example.com'

    try:
        
        response = http.request('GET', sample_url, headers={'User-Agent': 'Custom User Agent'},
                                preload_content=False, retries=False)
        logging_request_hook(response)
        
        if response.status == 200:
            print("Request Successful:")
            print(response.data.decode('utf-8'))
        else:
            print(f"Error: Unable to fetch data. Status Code: {response.status}")

    except urllib3.exceptions.RequestError as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    
    make_sample_request()
