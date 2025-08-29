from sqlalchemy.orm import Session
import models , schemas
import auth
from fastapi import Depends
from typing import Annotated

user_dependency = Annotated[schemas.UserOut, Depends(auth.get_current_user)]

user = Depends(auth.get_current_user)
def create_todo(db : Session , todo : schemas.TodoCreate ,owner_id : int):
    db_todo = models.Todo(
        title=todo.title,
        description=todo.description,
        priority=todo.priority,
        complete=todo.complete,
        owner_id=owner_id
    )

    db.add(db_todo)
    db.commit()
    db.refresh(db_todo)
    return db_todo



def get_todos(db : Session , owner_id : int , skip:int = 0 , limit:int = 10):
    return (
        db.query(models.Todo).
        filter(models.Todo.owner_id == owner_id).
        offset(skip).
        limit(limit).
        all()
    )


def get_todo(db : Session , id : int , owner_id : int):
    return (db.query(models.Todo)
            .filter(models.Todo.id == id )
            .filter(models.Todo.owner_id == owner_id)
            .first()
    )

def update_todo(db: Session, id: int, owner_id: int, update_data: schemas.TodoUpdate):
    db_todo = get_todo(db, id, owner_id)
    if not db_todo:
        return None
    for key, value in update_data.dict(exclude_unset=True).items():
        setattr(db_todo, key, value)
    db.commit()
    db.refresh(db_todo)
    return db_todo

def delete_todo(db:Session , id : int , owner_id : int):
    db_todo = get_todo(db , id , owner_id)
    if not db_todo:
        return None
    db.delete(db_todo)
    db.commit()
    return db_todo