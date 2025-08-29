from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os
from database import Base
from main import app
from routers.todos import get_db
from auth import get_current_user
from fastapi.testclient import TestClient
from fastapi import status
from models import Todo, User
import pytest

load_dotenv()
TEST_DATABASE_URL = os.getenv("TEST_DATABASE_URL")

engine = create_engine(TEST_DATABASE_URL, echo=True)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Drop and recreate schema for a clean test DB
Base.metadata.drop_all(bind=engine)
Base.metadata.create_all(bind=engine)


def override_get_db():
    try:
        db = TestingSessionLocal()
        yield db
    finally:
        db.close()


app.dependency_overrides[get_db] = override_get_db

client = TestClient(app)


@pytest.fixture(scope="function")
def test_user():
    """Create a temporary user for todos"""
    db = TestingSessionLocal()
    user = User(
        username="testuser",
        email="test@example.com",
        hashed_password="fakepassword"
    )
    db.add(user)
    db.commit()
    db.refresh(user)

    # override dependency to return this *User object*
    def _override_get_current_user():
        return user

    app.dependency_overrides[get_current_user] = _override_get_current_user

    yield user

    # cleanup
    db.query(User).filter(User.id == user.id).delete()
    db.commit()
    db.close()


@pytest.fixture(scope="function")
def test_todo(test_user):
    """Create a temporary todo linked to test_user"""
    db = TestingSessionLocal()
    todo = Todo(
        title="Test Todo",
        description="This is a test todo",
        priority=5,
        complete=False,
        owner_id=test_user.id
    )
    db.add(todo)
    db.commit()
    db.refresh(todo)
    yield todo
    # cleanup
    db.query(Todo).filter(Todo.id == todo.id).delete()
    db.commit()
    db.close()


def test_read_all_authenticated_empty(test_user):
    """When no todos exist, should return empty list"""
    response = client.get("/todos/")
    assert response.status_code == 200
    assert response.json() == []


def test_read_all_authenticated_with_todo(test_todo):
    """When a todo exists, it should return it"""
    response = client.get("/todos/")
    assert response.status_code == status.HTTP_200_OK
    data = response.json()
    assert len(data) == 1
    assert data[0]["title"] == "Test Todo"
    assert data[0]["description"] == "This is a test todo"
    assert data[0]["priority"] == 5
    assert data[0]["complete"] is False
    assert data[0]["owner_id"] == test_todo.owner_id


def test_read_one_authenticated_not_found(test_todo):
    """When a todo does not exist, should return 404"""
    response = client.get("/todos/9999")
    assert response.status_code == status.HTTP_404_NOT_FOUND
    assert response.json() == {"detail": "Todo not found"}