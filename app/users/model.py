from sqlalchemy.exc import SQLAlchemyError
from werkzeug.security import generate_password_hash, check_password_hash

from app import db


class UserAuth(db.Model):
    __tablename__ = 'user_auth'
    id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(32), index=True)
    password_hash = db.Column(db.String(64))
    user_auth = db.relationship('UserInfo', backref=db.backref('parent'))

    def __init__(self, user_name, password_hash):
        self.user_name = user_name
        self.password_hash = password_hash

    def __str__(self):
        return "UserAuth(id='%s')" % self.id

    def set_password(self, password):
        return generate_password_hash(password)

    def check_password(self, password_hash, password):
        return check_password_hash(password_hash, password)

    def add(self, user):
        db.session.add(user)
        return session_commit()

    def update(self):
        return session_commit()

    def delete(self, user_id):
        self.query.filter_by(user_id=user_id).delete()
        return session_commit()


class UserInfo(db.Model):
    __tablename__ = 'user_info'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.String(128), db.ForeignKey('user_auth.id'))
    nickname = db.Column(db.String(32))
    avatar = db.Column(db.String(128))
    gender = db.Column(db.Integer)
    mobile = db.Column(db.Integer)
    birthday = db.Column(db.DateTime)
    create_time = db.Column(db.DateTime)
    login_time = db.Column(db.DateTime)

    def add(self, user):
        db.session.add(user)
        return session_commit()

    def update(self):
        return session_commit()

    def getByUserId(self, user_id):
        return self.query.filter_by(user_id=user_id).first()

    def getById(self, user_id):
        return self.query.filter_by(id=user_id).first()


def session_commit():
    try:
        db.session.commit()
    except SQLAlchemyError as e:
        db.session.rollback()
        reason = str(e)
        return reason
