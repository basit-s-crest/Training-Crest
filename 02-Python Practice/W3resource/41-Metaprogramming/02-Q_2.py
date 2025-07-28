## dynamically adding methods to class in python 

def add_method(cls, method_name, method):

    setattr(cls,method_name,method)

class Myclass:
    pass

def new_method(self):
    return f"Hello I got added dynamically"

add_method(Myclass,'new_method', new_method)

m1 = Myclass()
print(m1.new_method())