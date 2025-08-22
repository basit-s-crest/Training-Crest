from fastapi import FastAPI , HTTPException , Path , Query
import os , json
from model import Book
from typing import List
from starlette  import status

app = FastAPI()


# def load_books()->List[Book]:
#     if not os.path.exists("data_base.JSON"):
#         return []
    
#     with open("data_base.JSON", 'r') as f:
#         data =  json.load(f)
#         return [Book(**b) for b in data] 


# def save_books(books: List[Book]):
#     with open("data_base.JSON", "w") as f:
#         json.dump([b.dict() for b in books], f, indent=2)


def read_books()->List[Book]:
    with open("database.JSON", "r") as f:
        data = json.load(f)
        return [Book(**b) for b in data]  # as we using pydantic we need to convert data into proper dict format

def save_books(books:List[Book]):
    with open("database.JSON", "w") as f:
        json.dump([b.dict() for b in books],f,indent=2)


    


@app.get("/")
async def root():
    return f"Home Page!!!"


@app.get("/books" , response_model = List[Book]  , status_code=status.HTTP_200_OK)
async def books():
    return read_books()

@app.get("/books/a/{author}", response_model = Book)
async def book_by_id( author : str , category : str):
    all_books = read_books()
    for book in all_books:
        if book.author == author and book.category == category:
            return book
    raise HTTPException(status_code=400 , detail="Required book not found")

@app.get("/books/{book_id}" , response_model = Book)
def book_by_id(book_id:int = Path(gt = 0)):
    books = read_books()
    for book in books:
        if book.id == int(book_id):
            return book
    raise HTTPException(status_code=400, detail="Book Id not matched")

@app.get("/books/")
async def read_book_by_rating(book_rating: int = Query(gt=0, lt=6)):
    books_to_return = []
    BOOKS = read_books()
    for book in BOOKS:
        if book.rating == book_rating:
            books_to_return.append(book)
    return books_to_return


@app.post("/books/",response_model = Book)
def inserting_book(data : Book):
    current_books = read_books()
    if len(current_books) > 0 : 
        data.id = current_books[-1].id + 1
    else :
        data.id = 1
    
    current_books.append(data)
    save_books(current_books)
    return data


