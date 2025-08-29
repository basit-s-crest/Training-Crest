const API_URL = 'http://127.0.0.1:8000';

// Check if user is logged in
function checkAuth() {
    const token = localStorage.getItem('token');
    if (!token && !window.location.href.includes('login.html') && !window.location.href.includes('register.html')) {
        window.location.href = 'login.html';
    }
}

// Authentication functions
async function login(e) {
    e.preventDefault();
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    const formData = new FormData();
    formData.append('username', username);
    formData.append('password', password);

    try {
        const response = await fetch(`${API_URL}/users/login`, {
            method: 'POST',
            body: formData
        });
        const data = await response.json();
        if (response.ok) {
            localStorage.setItem('token', data.access_token);
            window.location.href = 'todos.html';
        } else {
            alert('Login failed: ' + data.detail);
        }
    } catch (error) {
        console.error('Login error:', error);
        alert('Login failed');
    }
}

async function register(e) {
    e.preventDefault();
    const username = document.getElementById('username').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;

    try {
        const response = await fetch(`${API_URL}/users/`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({ username, email, password })
        });
        const data = await response.json();
        if (response.ok) {
            window.location.href = 'login.html';
        } else {
            alert('Registration failed: ' + data.detail);
        }
    } catch (error) {
        console.error('Registration error:', error);
        alert('Registration failed');
    }
}

function logout() {
    localStorage.removeItem('token');
    window.location.href = 'login.html';
}

// Todo functions
async function fetchTodos() {
    try {
        const response = await fetch(`${API_URL}/todos/`, {
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`
            }
        });
        if (response.ok) {
            const todos = await response.json();
            displayTodos(todos);
        } else {
            logout();
        }
    } catch (error) {
        console.error('Error fetching todos:', error);
    }
}

async function createTodo() {
    const title = document.getElementById('todoTitle').value;
    const description = document.getElementById('todoDescription').value;
    const priority = parseInt(document.getElementById('todoPriority').value);

    const todoData = {
        title,
        description,
        priority,
        complete: false
    };

    try {
        const response = await fetch(`${API_URL}/todos/`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${localStorage.getItem('token')}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(todoData)
        });
        if (response.ok) {
            const modal = bootstrap.Modal.getInstance(document.getElementById('addTodoModal'));
            modal.hide();
            document.getElementById('todoForm').reset();
            fetchTodos();
        }
    } catch (error) {
        console.error('Error creating todo:', error);
        alert('Failed to create todo');
    }
}

async function deleteTodo(id) {
    if (confirm('Are you sure you want to delete this todo?')) {
        try {
            const response = await fetch(`${API_URL}/todos/${id}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${localStorage.getItem('token')}`
                }
            });
            if (response.ok) {
                fetchTodos();
            }
        } catch (error) {
            console.error('Error deleting todo:', error);
            alert('Failed to delete todo');
        }
    }
}

function displayTodos(todos) {
    const todoList = document.getElementById('todoList');
    if (!todoList) return;

    todoList.innerHTML = todos.map(todo => `
        <div class="col-md-6 col-lg-4">
            <div class="card todo-card priority-${todo.priority} shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <h5 class="card-title mb-0">${todo.title}</h5>
                        <button class="btn btn-link text-danger delete-btn p-0" onclick="deleteTodo(${todo.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                    <p class="card-text text-muted">${todo.description}</p>
                    <span class="priority-badge bg-${getPriorityColor(todo.priority)}">
                        Priority: ${todo.priority}
                    </span>
                </div>
            </div>
        </div>
    `).join('');
}

function getPriorityColor(priority) {
    switch(priority) {
        case 1: return 'success';
        case 2: return 'info';
        case 3: return 'warning';
        case 4: return 'orange';
        case 5: return 'danger';
        default: return 'primary';
    }
}

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    checkAuth();

    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', login);
    }

    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', register);
    }

    if (window.location.pathname.includes('todos.html')) {
        fetchTodos();
    }
});
