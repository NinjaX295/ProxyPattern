class Mydecorator:
    def __init__(AK,name,age,function):
        AK.name=name
        AK.age=age
        AK.function=function
#     print(f"Name of the person is {AK.name} and the age of the  {age}")

def add(a,b):
    return a + b

Mydecorator("Rajeev",19,add(3,4))
# /workspaces/MAIN2/python project/main.p