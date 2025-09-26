import pandas as pd
import numpy as np

# Create sample movie data
movies_data = {
    'title': ['The Matrix', 'Inception', 'Interstellar', 'The Dark Knight', 'Pulp Fiction'],
    'year': [1999, 2010, 2014, 2008, 1994],
    'rating': [8.7, 8.8, 8.6, 9.0, 8.9],
    'genre': ['Sci-Fi', 'Sci-Fi', 'Sci-Fi', 'Action', 'Crime'],
    'director': ['Wachowski', 'Nolan', 'Nolan', 'Nolan', 'Tarantino']
}
df = pd.DataFrame(movies_data)

print("Movie Database:")
print(df)

# Analysis queries
print("\n1. Movies by director:")
director_counts = df.groupby('director').size()
print(director_counts)

print("\n2. Average rating by genre:")
genre_ratings = df.groupby('genre')['rating'].mean()
print(genre_ratings)

print("\n3. Highest rated movie:")
best_movie = df.loc[df['rating'].idxmax()]
print(best_movie)

print("\n4. Movies after 2000:")
modern_movies = df[df['year'] > 2000]
print(modern_movies)