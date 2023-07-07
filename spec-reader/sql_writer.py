import os.path
import sqlite3
from typing import List

from data_model import SqlBase
from zip_reader import read_folder

from sqlalchemy import create_engine, text
from sqlalchemy.orm import Session


class SqlWriter:

    def __init__(self, sqlite_path: str):

        self.parts_tables = {"cpu": "cpu_parts", "ram": "ram_parts"}

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

        self._refresh_part_tables()
        self._refresh_part_ids()

    def _refresh_part_tables(self):

        with Session(self.engine) as session:
            for value_table, parts_table in self.parts_tables:

                session.execute(text())

    def _refresh_part_ids(self):
        pass


class SqlStatements:

    @staticmethod
    def refresh_part_table(values_table: str, parts_table: str, parts_id_columns: List[str]) -> str:

        id_col_string = ', '.join(parts_id_columns)

        query = f"""
        INSERT INTO {values_table}
        SELECT DISTINCT {id_col_string} FROM (
            SELECT {id_col_string} FROM 
        )
        """

        return query
