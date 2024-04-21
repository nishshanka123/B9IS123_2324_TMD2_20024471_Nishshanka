import mysql.connector
import click
from flask import Flask 
from flask import current_app, g
from mysql.connector import errorcode

def get_db_connection():
  try:
    dims_db_con = mysql.connector.connect(
      host = "localhost",
      user = "root",
      password = "password",
      database = "DIMS",
      port = "8080"
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
       
db_con = get_db_connection()
print(db_con)

'''
import mysql.connector
from mysql.connector import errorcode

try:
  cnx = mysql.connector.connect(user='nishshanka', password='malsara',
                                database='employ')
except mysql.connector.Error as err:
  if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
    print("Something is wrong with your user name or password")
  elif err.errno == errorcode.ER_BAD_DB_ERROR:
    print("Database does not exist")
  else:
    print("error", err)
else:
  cnx.close()
'''