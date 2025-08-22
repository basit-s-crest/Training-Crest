from pydantic import BaseModel , Field
from typing import Optional

class Book(BaseModel):
    id: Optional[int] = None  
    title: str = Field(max_length=150)
    author: str = Field(max_length=150)
    category: str = Field(min_length=1 , max_length=100) 
    pages : int = Field(gt = 0 , lt = 1000)

    model_config = {
    "json_schema_extra": {
        "example": {
            "title": "A new book",
            "author": "codingwithroby",
            "description": "A new description of a book",
            "rating": 5
        }
    }}
