import urllib3
def make_https_request_with_verification():
    # Define the HTTPS URL with SSL/TLS verification enabled
    secure_url = 'https://www.example.com'

    try:
        # Create a PoolManager instance with SSL/TLS verification enabled
        with urllib3.PoolManager() as http:
            # Make an HTTPS GET request with SSL/TLS verification enabled
            response = http.request('GET', secure_url)

            # Check if the request was successful (status code 200)
            if response.status == 200:
                print("Secure HTTPS Request Successful:")
                print(response.data.decode('utf-8'))
            else:
                print(f"Error: Unable to fetch data. Status Code: {response.status}")

    except urllib3.exceptions.RequestError as e:
        print(f"Error: {e}")

make_https_request_with_verification()