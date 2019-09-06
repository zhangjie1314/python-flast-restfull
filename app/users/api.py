import datetime
from typing import Dict, Any, Union

from flask import request
from flask_jwt_simple import jwt_required, get_jwt_identity, create_jwt
from app import common
from app.users.model import UserAuth, UserInfo


def init_api(app):
    @app.route('/register', methods=['POST'])
    def register():
        """
        用户注册
        :return: json
        """
        username = request.json.get('username')
        password = request.json.get('password')
        repassword = request.json.get('repassword')

        # 检查用户名是否被占用
        isUser = UserAuth.query.filter_by(user_name=username).first()
        if isUser is not None:
            return common.make_response_error(-1, '该用户已存在！')

        # 密码校验
        if password != repassword:
            return common.make_response_error(-1, '两次密码输入不一致，请检查！')

        # 插入数据
        user = UserAuth(user_name=username, password_hash=UserAuth.set_password(UserAuth, password))
        UserAuth.add(UserAuth, user)
        user_info = UserInfo(user_id=user.id, nickname=username, create_time=datetime.datetime.now(), login_time=datetime.datetime.now())
        uiresult = UserInfo.add(UserInfo, user_info)
        print(uiresult)
        # 判断插入结果
        if user.id:
            data = {
                'user_id': user.id,
                'nickname': user_info.nickname,
                'avatar': user_info.avatar,
                'gender': user_info.gender,
                'mobile': user_info.mobile,
                'birthday': common.fromt_time(user_info.birthday, '%Y-%m-%d'),
                'create_time': common.fromt_time(user_info.create_time, '%Y-%m-%d %H:%M:%S'),
                'login_time': common.fromt_time(user_info.login_time, '%Y-%m-%d %H:%M:%S')
            }
            print(data)
            return common.make_response_ok(data=data)
        else:
            return common.make_response_error(-1, '用户注册失败！')

    @app.route('/login', methods=['POST'])
    def login():
        if not request.is_json:
            return common.make_response_error(-1, '请使用json传输数据！')

        params = request.get_json()
        username = params.get('username', None)
        password = params.get('password', None)

        if not username:
            return common.make_response_error(-1, '用户名不能为空！')
        if not password:
            return common.make_response_error(-1, '密码不能为空！')

        ua_info = UserAuth.query.filter_by(user_name=username).first()
        if ua_info is None:
            return common.make_response_error(-1, '用户不存在！')

        # 找到用户后获取用户信息表数据
        user_info = UserInfo.getByUserId(UserInfo, ua_info.id)
        if UserAuth.check_password(UserAuth, password_hash=ua_info.password_hash, password=password):
            login_time = datetime.datetime.now()
            user_info.login_time = login_time
            UserInfo.update(UserInfo)
        else:
            return common.make_response_error(-1, '密码不正确！')

        data = {
            'token': 'Bearer ' + create_jwt(identity=ua_info.id),
            'user_info': user_info
        }

        return common.make_response_ok(data=data)

    @app.route('/user')
    @jwt_required
    def get():
        """
        获取用户信息
        :return: json
        """
        user_info = UserInfo.getByUserId(UserInfo, get_jwt_identity())
        data = {
            'user_id': user_info.user_id,
            'nickname': user_info.nickname,
            'avatar': user_info.avatar,
            'gender': user_info.gender,
            'mobile': user_info.mobile,
            'birthday': common.fromt_time(user_info.birthday, '%Y-%m-%d'),
            'create_time': common.fromt_time(user_info.create_time, '%Y-%m-%d %H:%M:%S'),
            'login_time': common.fromt_time(user_info.login_time, '%Y-%m-%d %H:%M:%S')
        }
        return common.make_response_ok(data)
