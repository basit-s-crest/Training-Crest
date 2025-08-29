// API endpoints
const API_URL = '/api';  // Changed to relative URL

// Authentication functions
async function login(e) {
    e.preventDefault();
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    try {
        console.log('Attempting login for user:', username); // Debug log

        const formData = new URLSearchParams();
        formData.append('username', username);
        formData.append('password', password);

        const response = await fetch(`${API_URL}/users/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        });

        console.log('Login response status:', response.status); // Debug log
        
        const data = await response.json();
        console.log('Login response data:', data); // Debug log

        if (response.ok) {
            const token = data.access_token;
            console.log('Received token:', token); // Debug log

            // Store the token in localStorage
            localStorage.setItem('token', token);

            // Set the token in the cookie with proper attributes
            document.cookie = `access_token=${token}; path=/; secure; samesite=strict`;

            console.log('Token stored, redirecting to /todos'); // Debug log
            window.location.href = '/todos';
        } else {
            alert('Login failed: ' + (data.detail || 'Unknown error'));
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
            window.location.href = '/';
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
    document.cookie = 'access_token=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT;';
    window.location.href = '/';
}

// Todo functions
async function fetchTodos() {
    try {
        const token = localStorage.getItem('token');
        console.log('Fetching todos with token:', token); // Debug log

        const response = await fetch(`${API_URL}/todos/`, {
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });
        
        console.log('Todos response status:', response.status); // Debug log
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
    try {
        const title = document.getElementById('todoTitle').value;
        const description = document.getElementById('todoDescription').value;
        const priority = parseInt(document.getElementById('todoPriority').value);

        if (!title || !description || !priority) {
            alert('Please fill in all fields');
            return;
        }

        if (priority < 1 || priority > 5) {
            alert('Priority must be between 1 and 5');
            return;
        }

        const todoData = {
            title,
            description,
            priority,
            complete: false
        };

        console.log('Sending todo data:', todoData); // Debug log

        const token = localStorage.getItem('token');
        if (!token) {
            alert('You are not logged in. Please log in again.');
            window.location.href = '/';
            return;
        }

        const response = await fetch(`${API_URL}/todos/`, {
            method: 'POST',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(todoData)
        });

        const data = await response.json();
        console.log('Server response:', data); // Debug log

        if (response.ok) {
            const modal = bootstrap.Modal.getInstance(document.getElementById('addTodoModal'));
            modal.hide();
            document.getElementById('todoForm').reset();
            await fetchTodos();
            // Show success message
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-success alert-dismissible fade show';
            alertDiv.innerHTML = `
                <strong>Success!</strong> Todo created successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            document.querySelector('.container').insertBefore(alertDiv, document.querySelector('.row'));
            setTimeout(() => alertDiv.remove(), 3000);
        } else {
            throw new Error(data.detail || 'Failed to create todo');
        }
    } catch (error) {
        console.error('Error creating todo:', error);
        alert(error.message || 'Failed to create todo. Please try again.');
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
            <div class="card todo-card priority-${todo.priority} shadow-sm ${todo.complete ? 'bg-light border-success' : ''}">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-start mb-2">
                        <h5 class="card-title mb-0 ${todo.complete ? 'text-decoration-line-through' : ''}">${todo.title}</h5>
                        <div class="btn-group">
                            <button class="btn btn-link text-primary p-0 me-2" onclick="openEditModal(${JSON.stringify(todo).replace(/"/g, '&quot;')})">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn btn-link ${todo.complete ? 'text-success' : 'text-warning'} p-0 me-2" 
                                onclick="toggleTodoComplete(${todo.id}, ${!todo.complete})" 
                                title="${todo.complete ? 'Mark as Incomplete' : 'Mark as Complete'}">
                                <i class="fas ${todo.complete ? 'fa-check-circle' : 'fa-clock'}"></i>
                            </button>
                            <button class="btn btn-link text-danger delete-btn p-0" onclick="deleteTodo(${todo.id})">
                                <i class="fas fa-trash"></i>
                            </button>
                        </div>
                    </div>
                    <p class="card-text text-muted ${todo.complete ? 'text-decoration-line-through' : ''}">${todo.description}</p>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <div class="d-flex align-items-center">
                            <span class="priority-badge bg-${getPriorityColor(todo.priority)}">
                                Priority: ${todo.priority}
                            </span>
                            ${todo.complete ? 
                                '<span class="badge bg-success ms-2"><i class="fas fa-check me-1"></i>Completed</span>' :
                                '<span class="badge bg-warning ms-2"><i class="fas fa-clock me-1"></i>Pending</span>'
                            }
                        </div>
                    </div>
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

// Function to open edit modal with todo data
function openEditModal(todo) {
    document.getElementById('editTodoId').value = todo.id;
    document.getElementById('editTodoTitle').value = todo.title;
    document.getElementById('editTodoDescription').value = todo.description;
    document.getElementById('editTodoPriority').value = todo.priority;
    document.getElementById('editTodoComplete').checked = todo.complete;
    
    const editModal = new bootstrap.Modal(document.getElementById('editTodoModal'));
    editModal.show();
}

// Function to toggle todo completion status
async function toggleTodoComplete(todoId, complete) {
    try {
        const token = localStorage.getItem('token');
        if (!token) {
            alert('You are not logged in. Please log in again.');
            window.location.href = '/';
            return;
        }

        const response = await fetch(`${API_URL}/todos/${todoId}`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ complete: complete })
        });

        if (response.ok) {
            await fetchTodos();
            // Show success message
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-success alert-dismissible fade show';
            alertDiv.innerHTML = `
                <strong>Success!</strong> Todo marked as ${complete ? 'completed' : 'incomplete'}.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            document.querySelector('.container').insertBefore(alertDiv, document.querySelector('.row'));
            setTimeout(() => alertDiv.remove(), 3000);
        } else {
            throw new Error('Failed to update todo status');
        }
    } catch (error) {
        console.error('Error updating todo status:', error);
        alert(error.message || 'Failed to update todo status. Please try again.');
    }
}

// Function to update todo
async function updateTodo() {
    try {
        const todoId = document.getElementById('editTodoId').value;
        const priority = parseInt(document.getElementById('editTodoPriority').value);
        
        if (priority < 1 || priority > 5) {
            alert('Priority must be between 1 and 5');
            return;
        }

        const todoData = {
            title: document.getElementById('editTodoTitle').value,
            description: document.getElementById('editTodoDescription').value,
            priority: priority,
            complete: document.getElementById('editTodoComplete').checked
        };

        const token = localStorage.getItem('token');
        if (!token) {
            alert('You are not logged in. Please log in again.');
            window.location.href = '/';
            return;
        }

        console.log('Updating todo:', todoId, todoData); // Debug log

        const response = await fetch(`${API_URL}/todos/${todoId}`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(todoData)
        });

        const data = await response.json();
        console.log('Server response:', data); // Debug log

        if (response.ok) {
            const modal = bootstrap.Modal.getInstance(document.getElementById('editTodoModal'));
            modal.hide();
            await fetchTodos();
            
            // Show success message
            const alertDiv = document.createElement('div');
            alertDiv.className = 'alert alert-success alert-dismissible fade show';
            alertDiv.innerHTML = `
                <strong>Success!</strong> Todo updated successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            document.querySelector('.container').insertBefore(alertDiv, document.querySelector('.row'));
            setTimeout(() => alertDiv.remove(), 3000);
        } else {
            throw new Error(data.detail || 'Failed to update todo');
        }
    } catch (error) {
        console.error('Error updating todo:', error);
        alert(error.message || 'Failed to update todo. Please try again.');
    }
}

// Event Listeners
document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', login);
    }

    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', register);
    }

    if (window.location.href.includes('/todos')) {
        fetchTodos();
    }
});
