import random

def get_random_number():
    return random.randint(0, 100)

def handler(event, context):
    print(get_random_number())