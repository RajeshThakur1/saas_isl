from flask_restx import Namespace, fields


class NullableString(fields.String):
    __schema_type__ = ['string', 'null']
    __schema_example__ = "null/string"


class NullableInteger(fields.Integer):
    __schema_type__ = ['integer', 'null']
    __schema_example__ = 0


class NullableList(fields.List):
    __schema_type__ = ['list', 'null']
    __schema_example__ = []


class AuthDto:
    api = Namespace('auth', description='authentiction related operations')
    user_auth = api.model(
        'auth_details', {
            'email':
            fields.String(required=True, description='The email address'),
            'password':
            fields.String(required=True, description='The user password '),
            'login_request':
            fields.String(required=True, description='User Role ')
        })

    merchant_auth = api.model(
        'auth_details', {
            'email':
            fields.String(required=True, description='The email address'),
            'password':
            fields.String(required=True, description='The merchant password '),
            'login_request':
            fields.String(required=True, description='User Role ')
        })
    user_pass=api.model(
        'auth_forget',{
            'user_email':
            fields.String(required=True,description='The email address'),
            'login_request':
            fields.String(required=True,description='User Role')

            })

    user_newpass=api.model(
        'auth_email',{
            'newpassword':
            fields.String(required=True,description='newPassword'),
            'confirmpassword':
            fields.String(required=True,description='forgetPassword'),
            'login_request':
            fields.String(required=True,description='forgetPassword'),
            'otp':
            fields.String(required=True,description='forgetPassword'),
            'user_email':
            fields.String(required=True,description='forgetPassword')
            })

    create_sup = api.model(
        'create_sup',{
            'email': fields.String(required=True,
                                   description='user email address'),
            'name': fields.String(description='user username', required = True),
            'password': fields.String(required=True,
                                      description='user password'),
            'phone': fields.String(description='user Identifier', required = True),
            'master_password' : fields.String(required = True)
        
        
        }
    )
