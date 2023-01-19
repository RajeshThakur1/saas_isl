from flask_restx  import Namespace, fields

class CronDto:
    api = Namespace('System Cron Jobs',
                description='Cron Triggered Operations')
    
    create_mis_report = api.model(
        'create_mis_report', {
            'date' : fields.Date(required=True, description='Current Date')
        }
    )
    