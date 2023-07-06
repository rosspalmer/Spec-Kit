
from typing import List

from sqlalchemy import String
from sqlalchemy.orm import DeclarativeBase
from sqlalchemy.orm import Mapped
from sqlalchemy.orm import mapped_column


class SqlBase(DeclarativeBase):
    pass


class CPU(SqlBase):

    __tablename__ = "cpu"

    unit_id: Mapped[str] = mapped_column(primary_key=True)
    part_id: Mapped[int]
    model_name: Mapped[str]
    total_cpu_count: Mapped[int]
    cores_per_socket: Mapped[int]
    sockets: Mapped[int]
    max_mhz: Mapped[float]
    min_mhz: Mapped[float]


class CPUParts(SqlBase):

    __tablename__ = "cpu_parts"

    part_id: Mapped[int] = mapped_column(autoincrement=True)
    model_name: Mapped[str]


class RAM(SqlBase):

    __tablename__ = "ram"

    unit_id: Mapped[str] = mapped_column(primary_key=True)
    array_handle: Mapped[str] = mapped_column(primary_key=True)
    ram_handle: Mapped[str] = mapped_column(primary_key=True)
    part_id: Mapped[int]
    manufacturer: Mapped[str]
    part_number: Mapped[str]
    size_mb: Mapped[int]
    speed_mts: Mapped[int]
    form_factor: Mapped[str]
    ram_type: Mapped[str]


class RAMPart(SqlBase):

    __tablename__ = "ram_parts"

