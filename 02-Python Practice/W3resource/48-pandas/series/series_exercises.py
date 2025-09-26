from datetime import datetime
date1 = datetime(year=2020, month=12, day=25)
print("Date from a given year, month, day:")
print(date1)
from dateutil import parser
date2 = parser.parse("1st of January, 2021")
print("\nDate from a given string formats:")
print(date2)
