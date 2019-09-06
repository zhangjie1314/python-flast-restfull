from flask import Flask, request
from flask_sqlalchemy import SQLAlchemy
from flask_jwt_simple import JWTManager

db = SQLAlchemy()


def create_app(config_filename):
    app = Flask(__name__)
    app.config.from_object(config_filename)

    @app.after_request
    def after_request(response):
        response.headers.add('Access-Control-Allow-Origin', '*')
        if request.method == 'OPTIONS':
            response.headers['Access-Control-Allow-Methods'] = 'DELETE, GET, POST, PUT'
            headers = request.headers.get('Access-Control-Request-Headers')
            if headers:
                response.headers['Access-Control-Allow-Headers'] = headers
        return response

    from app.auth.auths import Auth
    from app import common
    jwt = JWTManager(app)

    @jwt.expired_token_loader
    def expired_token_handle(error_string):
        return common.make_response_error(-1, '认证token已过期(%s)，请重新登陆！' % error_string)

    @jwt.invalid_token_loader
    def invalid_token_handle(error_string):
        return common.make_response_error(-1, '认证token无效(%s)！请重新登陆！' % error_string)

    @jwt.unauthorized_loader
    def invalid_token_handle(error_string):
        return common.make_response_error(-1, '认证token未经授权(%s)！请重新登陆！' % error_string)

    from app.users.model import db
    db.init_app(app)

    from app.users.api import init_api
    init_api(app)

    return app
