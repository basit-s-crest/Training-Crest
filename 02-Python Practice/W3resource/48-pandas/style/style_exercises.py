import pandas as pd
import numpy as np

# Create sample DataFrame
df = pd.DataFrame({
    'Name': ['John', 'Emma', 'Alex', 'Sarah'],
    'Score': [85, 92, 78, 95],
    'Grade': ['B', 'A', 'C', 'A']
})

# Apply styles to DataFrame
styled_df = df.style\
    .highlight_max('Score', color='lightgreen')\
    .highlight_min('Score', color='lightcoral')\
    .set_properties(**{'background-color': 'lightyellow',
                      'border-color': 'black',
                      'border-style': 'solid',
                      'border-width': '1px'})

print("Original DataFrame:")
print(df)
print("\nNote: Styled DataFrame will be visible in notebook environment")