from database import engine 
from fastapi import FastAPI 
from models import Base
from routers import users , todos

app = FastAPI()


Base.metadata.create_all(bind=engine)


app.include_router(users.router)
app.include_router(todos.router)




