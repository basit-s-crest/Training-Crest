from fastapi import FastAPI , HTTPException
import os
import json
from model import Book
from typing import List 


app = FastAPI()

# database = os.path.join("data_base.JSON")

def load_books()->List[Book]:
    if not os.path.exists("data_base.JSON"):
        return []
    
    with open("data_base.JSON", 'r') as f:
        data =  json.load(f)
        return [Book(**b) for b in data] 


def save_books(books: List[Book]):
    with open("data_base.JSON", "w") as f:
        json.dump([b.dict() for b in books], f, indent=2)

        




@app.get("/")
def root_func():
    return "It's Working!!!"

@app.get("/books" , response_model = List[Book])
def all_book():
    return load_books()

@app.get("/books/{book_id}" , response_model = Book)
def book_by_id(book_id):
    books = load_books()
    for book in books:
        if book.id == book_id:
            return book

@app.post("/books",response_model = Book)
def add_books(book:Book):
    books = load_books()
    for b in books:
        if b.id == book.id:
            raise HTTPException(status_code=400, detail="Book ID already exists")
    
    books.append(book)
    save_books(books)
    return book


@app.delete("/books/{book_id}")
def delete_book(book_id : str):
    books = load_books()
    new_books = [book for book in books if book_id != book.id]
    if len(new_books) == len(books):
        raise HTTPException(status_code=404, detail="Book not found")
    save_books(new_books)
    return {f"Book id : {book_id} deleted successfully!"}

@app.put("/books/{book_id}", response_model=Book)
def update_book(book_id: str, updated: Book):
    books = load_books()
    for i, book in enumerate(books):
        if book.id == book_id:
            books[i] = updated
            save_books(books)
            return updated
    raise HTTPException(status_code=404, detail="Book not found")