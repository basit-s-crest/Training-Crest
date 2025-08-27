from database import Base 
from sqlalchemy import Column , Integer , Boolean , String , ForeignKey
from sqlalchemy.orm import relationship

class Todo(Base):
    __tablename__ = 'todos'

    id = Column(Integer , primary_key=True , index=True)
    title = Column(String)
    description = Column(String)
    priority = Column(Integer)
    complete = Column(Boolean)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="todos")

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    #mobile_number = Column(String(15), nullable=True)

    todos = relationship("Todo", back_populates="owner")