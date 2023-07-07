from sqlalchemy import create_engine

# from sql_writer import SqlWriter
#
# sql = SqlWriter("/home/ross/server-db/server.db")
# sql.add_folder("/home/ross/server-db/server-db")

from part_id import PartIds

f = "/home/ross/server-db/server.db"
p = PartIds(create_engine(f"sqlite:///{f}"))
