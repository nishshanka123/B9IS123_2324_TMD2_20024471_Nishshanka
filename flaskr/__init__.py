from flask import Flask, render_template, g, jsonify
from . import db
import secrets
import json
import string
from .db import get_db

def generate_secret_key(length=32):
    alphabet = string.ascii_letters + string.digits + '!@#$%^&*()-=_+'
    return ''.join(secrets.choice(alphabet) for _ in range(length))

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = generate_secret_key()

    app.config['MYSQL_HOST'] = 'localhost'
    app.config['MYSQL_USER'] = 'dbs'
    app.config['MYSQL_PASSWORD'] = 'password'
    app.config['MYSQL_DB'] = 'DIMS'

    # Initialize the database
    #db.init_app(app)

    @app.route('/')
    def index():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM Scanners")
        data = cursor.fetchall()
        cursor.close()
        return render_template('index.html', data=data)
        #return data
    
    @app.route('/manage-devices')
    def manageDevices():
        return render_template('manage-devices.html')
    
    @app.route('/users')
    def manageUsers():
        return render_template('manage-users.html')
    
    @app.route('/generateReports')
    def generateReports():
        return render_template('generate-reports.html')
    
    @app.route('/settings')
    def settings():
        return render_template('settings.html')
    
    @app.route('/api/data')
    def get_data():
        student_data = fetch_scanner_data()
        Results=[]
        for row in student_data: #Format the Output Results and add to return string
            Result={}
            Result['Type']=row[1].replace('\n',' ')
            Result['Status']=row[2]
            Result['ID']=row[0]
            Results.append(Result)
        response={'Results':Results, 'count':len(Results)}
        json_data=app.response_class(
            response=json.dumps(response),
            status=200,
            mimetype='application/json'
        )
        return json_data
    
    def fetch_scanner_data():
        db = get_db()
        cursor = db.cursor()
        cursor.execute("SELECT * FROM Scanners")
        data = cursor.fetchall()
        cursor.close()

        return data

    '''@app.route('/insert', methods=['POST'])
    def insert():
        db = get_db()
        cursor = db.cursor()
        # Retrieve data from the request and insert into the database
        cursor.close()
        
        if record:
            session['loggedin'] = True
            session['username'] = username
            return redirect(url_for('index'))
        else:
            msg = 'Incorrect Password or username.'
            return render_template('login.html', msg=msg)
    else:
        return render_template("login.html")
    
@app.route('/index', methods=['GET'])
def index():
    if 'loggedin' in session:
        return render_template('index.html', username=session['username'])
    else:
        return redirect(url_for('login'))

@app.route('/manage-devices')
def manageDevices():
    device_data = [
        {'name': 'Device 1', 'type': 'Type 1'},
        {'name': 'Device 2', 'type': 'Type 2'},
    ]
    return render_template('manage-devices.html')

@app.route('/manage-users')
def manageUsers():
    return render_template('manage-users.html')

@app.route('/generate-reports')
def generateReports():
    return render_template('generate-reports.html')

@app.route('/settings')
def settings():
    return render_template('settings.html')

@app.route('/logout')
def logout():
    return render_template('login.html')


if __name__ == "__main__":
    app.run(host='127.0.0.1', port='8080')
