from sqlalchemy import create_engine , text
from sqlalchemy.orm import declarative_base , sessionmaker
from dotenv import load_dotenv
import os
from config import settings

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")



engine = create_engine(settings.DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def test_connection():
    try:
        with engine.connect() as connection:
            result = connection.execute(text("SELECT 1"))
            print("Database connected successfully:", result.scalar())
    except Exception as e:
        print("Database connection failed:", str(e))


if __name__ == "__main__":
    test_connection()