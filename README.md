# Spec-Kit
Fedora based shell script library for analyzing hardware. Common unix 
CLI tools are used to pull hardware information to be saved as structured 
text files. These files are archived into zip files with the specified 
computer ID as the file name.

## Specification CLI Tools

The list of tools is based off a Red Hat System Administration article:

https://www.redhat.com/sysadmin/linux-system-info-commands

- `lscpu --json`: CPU information
- `lsblk --json`: Attached block (disk+) devices
- `lspci --vm`: PCI interfaces
- `dmidecode -t memory`: Memory component information
- `dmidecode -t bios`: BIOS status
- `dmidecode -t system`: System information
