# Spec-Kit
Linux based shell script library for analyzing hardware. Common unix 
CLI tools are used to pull hardware information to be saved as structured 
text files. These files are archived into zip files with the specified 
computer ID as the file name.

## Running Spec-Kit

The main Spec-Kit "program" is a simple bash script which pulls spec information 
and archives the data by key for later review and analysis. The bash script
must be run with **root** permissions to gain full access to hardware information.

The example command below shows the arguments used to run the bash script:

`sudo sh <PATH_TO_REPO>/generated-specs.sh <PATH_TO_OUTPUT_FOLDER> <HARDWARE_KEY>`

The end result is a zip file generated at `<PATH_TO_OUTPUT_FOLDER>/<HARDWARE_KEY>.zip`

### Specification CLI Tools

The list of tools is based off a Red Hat System Administration article:

https://www.redhat.com/sysadmin/linux-system-info-commands

- `lscpu --json`: CPU information
- `lsblk --json`: Attached block (disk+) devices
- `lspci --vm`: PCI interfaces
- `dmidecode -t memory`: Memory component information
- `dmidecode -t bios`: BIOS status
- `dmidecode -t system`: System information

## Creating USB Tool

The benefit of the Spec-Kit tool is limited if only ulitized on a single machine,
the true purpose of this tool is for use anayzling a large block of unknown
computers. One method to achieve this is to build a bootable / persistable USB
thumbdrive which can used to easily gather specs from many machines.

TODO 
