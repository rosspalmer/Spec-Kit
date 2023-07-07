
from data_model import CPU, RAM

from json import load
import os
import re
from typing import List
from zipfile import ZipFile


class SpecZipFile:

    def __init__(self, file_path: str):

        self.unit_id = re.search("/([\\w-]+).zip", file_path).group(1)

        with ZipFile(file_path, 'r') as self.zip:

            file_root = f"{self.unit_id}/{self.unit_id}"

            self.cpu: CPU = self.read_cpu_file(f"{file_root}_lscpu.json")
            self.rams: List[RAM] = self.read_memory_file(f"{file_root}_dmidecode_memory.txt")

    def read_cpu_file(self, file_name: str) -> CPU:

        with self.zip.open(file_name) as cpu_file:
            cpu_data = load(cpu_file)['lscpu']
            cpu_dict = dict(map(lambda x: (x['field'][:-1], x['data']), cpu_data))

            return CPU(
                unit_id=self.unit_id,
                part_id=-1,
                model_name=cpu_dict['Model name'],
                total_cpu_count=cpu_dict['CPU(s)'],
                cores_per_socket=cpu_dict['Core(s) per socket'],
                sockets=cpu_dict['Socket(s)'],
                max_mhz=cpu_dict['CPU max MHz'],
                min_mhz=cpu_dict['CPU min MHz']
            )

    def read_memory_file(self, file_path: str) -> List[RAM]:

        with self.zip.open(file_path) as memory_file:

            ram_data = []
            current_ram = dict()
            handle = None

            for lineBytes in memory_file:

                line = bytes.decode(lineBytes, 'utf-8')

                handle_match = re.search("^Handle 0x([0-9A-F]+),", line)

                # Run row checks to se
                if handle_match is not None:

                    if handle is not None:
                        current_ram['Handle'] = handle
                        ram_data.append(current_ram)
                        current_ram = dict()

                    handle = handle_match.group(1)

                else:
                    data_match = re.search("^\t([A-Za-z ]+):\\s(.+$)", line)
                    if data_match is not None:
                        current_ram[data_match.group(1)] = data_match.group(2)

        only_installed = filter(lambda x: 'Array Handle' in x and x['Size'] != 'No Module Installed', ram_data)

        ram = map(lambda x: RAM(
            unit_id=self.unit_id,
            array_handle=x['Array Handle'],
            ram_handle=x['Handle'],
            part_id=-1,
            manufacturer=x['Manufacturer'],
            part_number=x['Part Number'],
            size_mb=self.parse_size_string(x['Size']),
            speed_mts=self.parse_speed_string(x['Speed']),
            form_factor=x['Form Factor'],
            ram_type=x['Type']
        ), only_installed)

        return list(ram)

    @staticmethod
    def parse_size_string(size: str) -> int:

        match = re.search("^(\\d+) (GB|MB)$", size)
        if match is None:
            raise Exception(f"Size string {size} is not supported")
        else:

            value = int(match.group(1))
            unit = match.group(2)

            if unit == "MB":
                return value
            elif unit == "GB":
                return 1000 * value

    @staticmethod
    def parse_speed_string(speed: str) -> int:

        match = re.search("^(\\d+) MT/s$", speed)
        if match is None:
            raise Exception(f"Speed string {speed} is not supported")
        else:
            return int(match.group(1))


def read_folder(folder_path: str) -> List[SpecZipFile]:

    spec_zips = []

    for filename in os.scandir(folder_path):
        if filename.is_file() and filename.name.endswith('.zip'):
            spec_zips.append(SpecZipFile(filename.path))

    return spec_zips
