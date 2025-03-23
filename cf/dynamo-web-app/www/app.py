import logging
from flask import Flask
from flask import render_template, request
from dynamo import DynamoDb

app = Flask(__name__)

dynamo_db = DynamoDb()
log = logging.getLogger(__name__)

@app.route('/get')
def get_key():
    key = request.args.get('key')
    if key:
        try:
            value = dynamo_db.get_key(key)
            item = {"key": key, "value": value}
            return render_template('display_item.html', item=item)
        except Exception as e:
            log.error(e)
            return {'error': 'Key not found'}
    else:
        return render_template('get.html')

@app.route('/put', methods=['GET'])
def put_key_get():
    return render_template('put_item.html')

@app.route('/put', methods=['POST'])
def put_key_post():
    key = request.form.get('key')
    value = request.form.get('value')
    if key:
        try:
            item = {"key": key, "value": value}
            dynamo_db.put_key(key, value)
            return render_template('put_item.html', dictionary=item)
        except Exception as e:
            log.error(e)
            return {'error': 'Failed to put key'}
    else:
        return {'error': 'Did not provide key!'}

@app.route('/')
@app.route('/list')
def list_keys():
    return render_template('list.html', items=dynamo_db.list_keys(100))
