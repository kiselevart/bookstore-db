import sys
import psycopg2

print("Python executable:", sys.executable)
print("psycopg2 location:", psycopg2.__file__)


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

    except Exception as e:
        print(f"Error: {e}")
    finally:
        if connection:
            connection.close()
            print("Connection closed")

if __name__ == "__main__":
    connect_to_db()