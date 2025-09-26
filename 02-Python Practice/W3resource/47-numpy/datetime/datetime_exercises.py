
import numpy as np

# Finding the number of weekdays in March 2017 using numpy's busday_count function
# '2017-03' indicates the start of the period (March 2017)
# '2017-04' indicates the end of the period (April 2017), but this day is not counted
# The function calculates the number of weekdays (excluding weekends) between the provided dates
print("Number of weekdays in March 2017:")
print(np.busday_count('2017-03', '2017-04')) 
