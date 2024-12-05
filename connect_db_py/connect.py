import sys
import psycopg2

def execute_sql_from_file(filename, connection):
    """Execute SQL statements from a given file."""
    with open(filename, 'r') as file:
        sql = file.read()  
        try:
            with connection.cursor() as cursor:
                cursor.execute(sql)
                connection.commit()  
                print(f"Executed {filename} successfully.")
        except Exception as e:
            print(f"Error executing {filename}: {e}")
            connection.rollback()

def connect_to_db():
    connection = None
    try:
        host = "dpg-ct8hb7m8ii6s73cagva0-a.singapore-postgres.render.com"
        database = "remote_pg_db_xyxj"
        user = "root"
        password = "eJ9m3lrxnqZcO3AghKiapvthnGI0tuFj"
        port = "5432"

        connection = psycopg2.connect(
            host=host,
            database=database,
            user=user,
            password=password,
            port=port
        )
        print("Connection successful")

        with connection.cursor() as cursor:
            cursor.execute("SELECT 'Test query successful!' AS message;")
            print(cursor.fetchone()[0])

        return connection  

    except Exception as e:
        print(f"Error: {e}")
        return None  

if __name__ == "__main__":
    connection = connect_to_db()
    if connection:
        execute_sql_from_file("../bookstore_sql/create_db.sql", connection)
