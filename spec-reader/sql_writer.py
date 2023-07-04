import os.path
import sqlite3

from data_model import SqlBase
from zip_reader import read_folder

from sqlalchemy import create_engine
from sqlalchemy.orm import Session


class SqlWriter:

    def __init__(self, sqlite_path: str):

        if not os.path.exists(sqlite_path):
            con = sqlite3.connect(sqlite_path)
            con.close()

        self.engine = create_engine(f"sqlite:///{sqlite_path}")
        SqlBase.metadata.create_all(self.engine, checkfirst=True)

    def add_folder(self, folder_path: str):

        unit_files = read_folder(folder_path)

        with Session(self.engine) as session:

            for spec in unit_files:
                session.add(spec.cpu)
                session.add_all(spec.rams)

            session.commit()
