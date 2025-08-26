from sqlalchemy.orm import Session
from fastapi import APIRouter, Depends , HTTPException
import models , schemas , crud
from typing import List
from database import SessionLocal


router = APIRouter(
    prefix="/todos",
    tags=["todos"]
)


def get_db():
    db = SessionLocal()
    try:
        yield db 
    finally:
        db.close()


@router.post("/" , response_model=schemas.TodoOut)
def add_todo(todo : schemas.TodoCreate , db : Session = Depends(get_db)):
    return crud.create_todo(db=db , todo=todo)

@router.get("/" , response_model=List[schemas.TodoOut])
def read_todos(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return crud.get_todos(db=db, skip=skip, limit=limit)

@router.get("/{todo_id}", response_model=schemas.TodoOut)
def read_todo(todo_id : int , db : Session = Depends(get_db)):
    return crud.get_todo(db=db , id=todo_id)

@router.put("/{todo_id}", response_model=schemas.TodoOut)
def update_todo(todo_id: int, todo: schemas.TodoUpdate, db: Session = Depends(get_db)):
    updated_todo = crud.update_todo(db, todo_id, todo)
    if not updated_todo:
        raise HTTPException(status_code=404, detail="Todo not found")
    return updated_todo

@router.delete("/{todo_id}", response_model=schemas.TodoOut)
def delete_todo(todo_id : int , db : Session = Depends(get_db)):
    deleted_todo = crud.delete_todo(db=db , id=todo_id)
    if not delete_todo:
        raise HTTPException(status_code=404 , detail="Todo not available")
    return deleted_todo