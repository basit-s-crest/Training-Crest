## metaprogrammimg 

class upperattr(type):
    def __new__(cls , name , bases , dict):

        updated_re = {}
        for name , value in dict.items():
            if not name.startswith('__'):
                updated_re[name.upper()] = value
            else:
                updated_re[name] = value
        
        return super().__new__(cls,name,bases,updated_re)

class Myclass(metaclass = upperattr):
    foo = 'bar'
    baz = 'qux'


print(hasattr(Myclass, 'foo'))  
print(hasattr(Myclass, 'FOO'))  
print(Myclass.FOO)

