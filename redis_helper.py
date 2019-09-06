# coding=utf-8

import redis
import json
import datetime

pool = redis.ConnectionPool(host='127.0.0.1', port=6379)


class CJsonEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, datetime.datetime):
            return o.strftime('%Y-%m-%d %H:%M:%S')
        elif isinstance(o, datetime.date):
            return o.strftime('%Y-%m-%d')
        else:
            return json.JSONEncoder.default(self, o)


class Redis:
    @staticmethod
    def connect(db=0):
        r = redis.Redis(connection_pool=pool, db=db)
        return r

    # 将内存数据二进制通过序列号转为文本流，再存入redis
    @staticmethod
    def set(r, key: str, data, ex=None):
        r.set(key, json.dumps(data, cls=CJsonEncoder), ex=ex)

    # 将文本流从redis中读取并反序列化，返回
    @staticmethod
    def get(r, key: str):
        data = r.get(key)
        if data is None:
            return None

        return json.loads(data)