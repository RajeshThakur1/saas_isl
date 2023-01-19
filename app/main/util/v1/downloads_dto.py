from flask_restx import Namespace, fields


class DownloadDto:
    api = Namespace('Downloads', description='downloads releated operation')
