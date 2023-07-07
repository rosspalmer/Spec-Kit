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

    def _get_part_columns(self, value_table: str) -> List[str]:

        parts_table = self.parts_tables[value_table]
        parts_columns = []

        with Session(self.engine) as session:

            results = session.execute(text(SqlStatements.get_columns(parts_table)))

            for column in results:
                column_name = column[1]
                if column_name != 'part_id':
                    parts_columns.append(column_name)

        return parts_columns

    def _refresh_part_tables(self):

        with Session(self.engine) as session:
            for value_table, parts_table in self.parts_tables.items():
                part_id_columns = self._get_part_columns(value_table)
                session.execute(text(SqlStatements.refresh_part_table(value_table, parts_table, part_id_columns)))

            session.commit()

    def _refresh_part_ids(self):

        with Session(self.engine) as session:
            for value_table, parts_table in self.parts_tables.items():

                part_id_columns = self._get_part_columns(value_table)
                results = session.execute(text(SqlStatements.get_part_id_definitions(parts_table, part_id_columns)))

                for row in results:
                    session.execute(text(SqlStatements.update_part_id(row, value_table, part_id_columns)))

            session.commit()


class SqlStatements:

    @staticmethod
    def refresh_part_table(values_table: str, parts_table: str, part_id_columns: List[str]) -> str:

        id_col_string = ', '.join(part_id_columns)

        query = f"""
        INSERT INTO {parts_table}
        SELECT DISTINCT null, {id_col_string} FROM (
            SELECT {id_col_string} FROM {values_table}
            LEFT OUTER JOIN {parts_table} USING ({id_col_string})
            WHERE {parts_table}.part_id IS NULL
        )
        """

        return query

    @staticmethod
    def get_columns(table: str) -> str:
        return f"PRAGMA table_info({table})"

    @staticmethod
    def get_part_id_definitions(parts_table: str, part_id_columns: List[str]) -> str:
        return f"SELECT part_id, {', '.join(part_id_columns)} FROM {parts_table}"

    @staticmethod
    def update_part_id(row, values_table: str,  parts_id_columns: List[str]) -> str:

        where_conditions = []
        for i, id_column in enumerate(parts_id_columns):
            where_conditions.append(f"{id_column} = '{row[1+i]}'")

        query = f"""
        UPDATE {values_table} SET part_id = {row[0]}
        WHERE {'AND '.join(where_conditions)}
        """

        return query
