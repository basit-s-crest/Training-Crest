from pydantic import BaseModel , EmailStr


class TodoBase(BaseModel):
    title : str
    description : str
    priority : int
    complete : bool = False
    owner_id : int


class TodoCreate(TodoBase):
    pass

class TodoUpdate(BaseModel):
    title : str | None = None
    description : str | None = None
    priority : int | None = None
    complete : bool | None = None

class TodoOut(TodoBase):
    id : int


    class config:
        orm_mode  = True

class UserBase(BaseModel):
    username: str
    email: EmailStr

class UserCreate(UserBase):
    password: str

class UserOut(UserBase):
    id: int
    class Config:
        orm_mode = True


class Token(BaseModel):
    access_token: str
    token_type: str