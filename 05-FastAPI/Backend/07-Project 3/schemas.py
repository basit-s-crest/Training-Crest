from pydantic import BaseModel, EmailStr, Field, validator


class TodoBase(BaseModel):
    title: str
    description: str
    priority: int = Field(..., ge=1, le=5)
    complete: bool = False

    @validator('priority')
    def validate_priority(cls, v):
        if not 1 <= v <= 5:
            raise ValueError('Priority must be between 1 and 5')
        return v


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