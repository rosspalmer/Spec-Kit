
import read

example = read.read_memory_file("/home/ross/repo/Spec-Kit/test-data/r1n05_dmidecode_memory.txt")

for line in example:
    print(f'Handle = {line.handle}')
    print(f'Size = {line.size}')
    print(f'Speed = {line.speed}')
    print(f'Form Factor = {line.form_factor}')
    print(f'RAM Type = {line.ram_type}')
    print()


example2 = read.read_cpu_file("/home/ross/repo/Spec-Kit/test-data/r1n05_lscpu.json")