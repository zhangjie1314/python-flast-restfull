import datetime
from app.users.model import UserAuth, UserInfo
from app import common

class Auth():
    @staticmethod
    def error_handler(e):
        print(e)
        return "Something bad happened", 400

    def authenticate(self, username, password):
        user_auth = UserAuth.query.filter_by(user_name=username).first()
        if user_auth is None:
            self.error_handler('找不到用户')
        else:
            # 找到用户后获取用户信息表数据
            user_info = UserInfo.getByUserId(UserInfo, user_auth.id)
            if UserAuth.check_password(UserAuth, password_hash=user_auth.password_hash, password=password):
                login_time = datetime.datetime.now()
                user_info.login_time = login_time
                UserInfo.update(UserInfo)
                return user_info
            else:
                self.error_handler('密码不正确')

    @staticmethod
    def identity(payload):
        id = payload['identity']
        return UserInfo.getById(UserInfo, id)
