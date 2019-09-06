import datetime

# 数据库参数
DB_USER = 'root'
DB_PASSWORD = '12345678'
DB_HOST = 'localhost'
DB_DB = 'test'
DEBUG = True

# 项目设置
PORT = 3333
HOST = "localhost"
SECRET_KEY = "my text py"

# JWT 基础设置
JWT_SECRET_KEY = 'ejoyst'
JWT_HEADER_NAME = 'Token'
JWT_HEADER_TYPE = ''
JWT_EXPIRES = datetime.timedelta(days=7)

# SQLAlchemy 设置
SQLALCHEMY_TRACK_MODIFICATIONS = False
SQLALCHEMY_DATABASE_URI = 'mysql+pymysql://' + DB_USER + ':' + DB_PASSWORD + '@' + DB_HOST + '/' + DB_DB