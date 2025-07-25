def add_logging(func):
    def wrapper(*args, **kwargs):
       
        print(f"Calling {func.__name__} with args: {args}, kwargs: {kwargs}")
        

        result = func(*args, **kwargs)

        print(f"{func.__name__} returned: {result}")
        

        return result
    return wrapper


@add_logging
def add_numbers(x, y):
    return x + y


result = add_numbers(200, 300)
print("Result:", result)
