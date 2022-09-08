import redis

r = redis.Redis(host='localhost', port=3030, db=0)

r.set('name', 'hello')