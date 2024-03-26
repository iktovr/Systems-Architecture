import pandas as pd
from sqlalchemy import create_engine, text
engine = create_engine("postgresql://stud:stud@127.0.0.1:5432/archdb", echo = True)

with engine.connect() as con:
    con.execute(text('DROP TABLE IF EXISTS "User"'))
    con.execute(text('''\
CREATE TABLE "User" (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(256) NOT NULL,
    last_name VARCHAR(256) NOT NULL,
    login VARCHAR(256)  NULL,
    password VARCHAR(256)  NULL,
    email VARCHAR(256) NULL,
    title VARCHAR(1024) NULL
)'''))
    con.commit()

df = pd.read_json("ExportJson.json")
df.to_sql("User", con=engine, if_exists = 'append', index=False)