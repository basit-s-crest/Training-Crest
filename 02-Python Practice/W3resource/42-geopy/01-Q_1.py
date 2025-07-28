# from geopy.geocoders import Nominatim
# geolocator = Nominatim(user_agent="your_name_geopy_app")
# ladd1 = "27488 Stanford Avenue, North Dakota"
# print("Location address:",ladd1)
# location = geolocator.geocode(ladd1)
# print("Street address, street name: ")
# print(location.address)


from geopy.geocoders import Nominatim

# Initialize the geocoder with a valid user agent
geolocator = Nominatim(user_agent="basit_geopy_app")

# Define your address
address = "Navsari, Gujarat"

# Get location data
location = geolocator.geocode(address)

# Display results
if location:
    print("Full Address:", location.address)
    print("Latitude:", location.latitude)
    print("Longitude:", location.longitude)
else:
    print("Location not found")
