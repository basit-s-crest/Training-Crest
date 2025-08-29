from sqlalchemy.orm import Session
import schemas , models , security
from fastapi import Depends , HTTPException , status
from jose import JWTError, jwt 
from database import SessionLocal
from fastapi.security import OAuth2PasswordBearer


from dotenv import load_dotenv  
import os


load_dotenv()
SECRET_KEY = os.getenv("JWT_SECRET")
ALGORITHM = os.getenv("ALGORITHM")


oauth2_scheme = OAuth2PasswordBearer(tokenUrl="users/login")


def create_user(db: Session, user: schemas.UserCreate):
    hashed_pw = security.hash_password(user.password)
    db_user = models.User(username=user.username, email=user.email, hashed_password=hashed_pw)
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_db():
    db = SessionLocal()
    try:
        yield db 
    finally:
        db.close()

def get_user_by_username(db: Session, username: str):   
    return db.query(models.User).filter(models.User.username == username).first()


def authenticate_user(db: Session, username: str, password: str):
    user = get_user_by_username(db, username)
    if not user or not security.verify_password(password, user.hashed_password):
        return None
    return user

async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    print("🔑 Token received:", token)  # DEBUG
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            raise credentials_exception
        print("👉 Decoded username from JWT:", username)   # DEBUG
        if username is None:
            raise HTTPException(status_code=401, detail="Token missing username")
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

    user = get_user_by_username(db, username=username)
    if user is None:
        raise HTTPException(status_code=404, detail="User not found2")  # your current error
    return user


