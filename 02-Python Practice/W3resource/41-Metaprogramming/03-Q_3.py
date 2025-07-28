def adding_function_dynamically(name,defination):
    scope = {}
    exec(f"def {name}():\n   {defination}", {}, scope)
    return scope[name]

name = 'dynamic_function'
body = "print('Hello, dynamically created function')"

dynamic_func = adding_function_dynamically(name,body)

dynamic_func()