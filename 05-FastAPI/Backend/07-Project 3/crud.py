from sqlalchemy.orm import Session
import models , schemas


def create_todo(db : Session , todo : schemas.TodoCreate):
    db_todo = models.Todos(
        title=todo.title,
        description=todo.description,
        priority=todo.priority,
        complete=todo.complete
    )

    db.add(db_todo)
    db.commit()
    db.refresh(db_todo)
    return db_todo



def get_todos(db : Session , skip:int = 0 , limit:int = 10):
    return db.query(models.Todos).offset(skip).limit(limit).all()


def get_todo(db : Session , id : int):
    return db.query(models.Todos).filter(models.Todos.id == id ).first()

def update_todo(db  : Session , id : int , update_data : schemas.TodoUpdate):
    db_todo = get_todo(db, id)
    if not db_todo:
        return None
    for key, value in update_data.dict(exclude_unset=True).items():
        setattr(db_todo, key, value)
    db.commit()
    db.refresh(db_todo)
    return db_todo

def delete_todo(db:Session , id : int):
    db_todo = get_todo(db , id)
    if not db_todo:
        return None
    db.delete(db_todo)
    db.commit()
    return db_todo