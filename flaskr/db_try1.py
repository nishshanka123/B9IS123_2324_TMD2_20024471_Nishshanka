import mysql.connector
import click
from flask import Flask 
from flask import current_app, g

'''
def get_db_connection():
  try:
    dims_db_con = mysql.connector.connect(
      host = "127.0.0.1",
      user = "nishshanka",
      password = "malsara",
      database = "DIMS",
      port = "3306"
    )
    dims_cursor = dims_db_con.cursor()

  except mysql.connector.Error as err:
    if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
        print("Access Denied")
    elif err.errno == errorcode.ER_BAD_DB_ERROR:
        print("database doesn't exist")
    else:
        print(err)

  return dims_db_con
    
'''

# Function to connect to MySQL database
def get_db_connection():
  # uses the 'g' object to store the databases connectivity for handling the
  # DB queries, g is a special object used to handle the request in Flask
    if 'dims_db_con' not in g:
        g.dims_db_con = mysql.connector.connect(
        host="localhost",
        user="root",
        password="yash@1999",
        database="DIMS"
    )
    g.cursor = g.dims_db_con.cursor(dictionary=True)
    
    return g.dims_db_con, g.cursor

# Function to close database connection
#@app.teardown_appcontext
def close_db_connection(e=None):
    dims_db_con = g.pop('dims_db_con', None)
    if dims_db_con is not None:
        dims_db_con.close()

# Example route to query data from MySQL
#@app.route('/query')
def query_data():
    dims_db_con, cursor = get_db_connection()
    db_query = "SELECT * FROM test";
    cursor.execute(db_query)
    data = cursor.fetchall()
    return str(data)

def init_db():
    dims_db_con = get_db_connection()
    #query_data()

@click.command('init-db')
def init_db_command():
    """Clear the existing data and create new tables."""
    init_db()
    click.echo('Initialized the database.')
    result = query_data()
    click.echo(result)

def init_app(app):
    app.teardown_appcontext(close_db_connection)
    app.cli.add_command(init_db_command)

