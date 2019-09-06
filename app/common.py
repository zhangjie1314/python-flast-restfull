from flask import jsonify
import datetime


def make_response_ok(data=None):
    """
    请求成功返回的结果
    :param data:
    :return:
    """
    resp = {'code': 0, 'msg': 'success'}
    if data:
        resp['data'] = data
    return jsonify(resp)


def make_response_error(code, msg):
    """
    请求失败返回的结果
    :param code:
    :param msg:
    :return:
    """
    resp = {'code': code, 'msg': msg}
    return jsonify(resp)


def fromt_time(date, str):
    """
    格式化时间格式
    :param time: 时间
    :param str: 格式
    :return: String
    """
    if date is None:
        return ''
    return datetime.datetime.strftime(date, str)
