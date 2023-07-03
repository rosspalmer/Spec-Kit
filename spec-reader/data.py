
from typing import List


class CPU:

    def __init__(self, unit_id: str, model_name: str, total_cpu_count: str, cores_per_socket: str,
                 sockets: str, max_mhz: float, min_mhz: float):
        self.unit_id = unit_id
        self.model_name = model_name
        self.total_cpu_count = total_cpu_count
        self.cores_per_socket = cores_per_socket
        self.sockets = sockets
        self.max_mhz = max_mhz
        self.min_mhz = min_mhz


class RAM:

    def __init__(self, unit_id: str, handle: str, size: str, speed: str, form_factor: str, ram_type: str):
        self.handle = handle
        self.size = size
        self.speed = speed
        self.form_factor = form_factor
        self.ram_type = ram_type


class HardwareSpec:

    def __init__(self, unit_id: str, cpu: CPU, ram: List[RAM]):
        self.unit_id = unit_id
        self.cpu = cpu
        self.ram = ram
