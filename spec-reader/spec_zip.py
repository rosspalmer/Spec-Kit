
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

            return CPU(self.unit_id, cpu_dict['Model name'], cpu_dict['CPU(s)'],
                       cpu_dict['Core(s) per socket'], cpu_dict['Socket(s)'],
                       cpu_dict['CPU max MHz'], cpu_dict['CPU min MHz'])

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

        ram = map(lambda x: RAM(self.unit_id, x['Handle'], x['Size'], x['Speed'], x['Form Factor'], x['Type']), only_installed)

        return list(ram)
