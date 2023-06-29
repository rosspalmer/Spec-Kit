
from data import CPU, RAM

from json import loads
import re
from typing import List


def read_cpu_file(file_path: str) -> CPU:

    with open(file_path) as cpu_file:
        cpu_data = loads(''.join(cpu_file.readlines()))['lscpu']
        cpu_dict = dict(map(lambda x: (x['field'][:-1], x['data']), cpu_data))

        CPU(cpu_dict['Model name'])

def read_memory_file(file_path: str) -> List[RAM]:

    with open(file_path) as memory_file:

        ram_data = []
        current_ram = dict()
        handle = None

        for line in memory_file:

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

    ram = map(lambda x: RAM(x['Handle'], x['Size'], x['Speed'], x['Form Factor'], x['Type']), only_installed)

    return list(ram)
