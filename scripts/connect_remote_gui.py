#!/usr/bin/env python3

import argparse

# Parse input arguments
parser = argparse.ArgumentParser(description='Connect a rogue GUI to a remote server. The server application' \
                                 'must be already running before you try to connect a GUI to it.' \
                                 'The remote server is identify by the hostname where it is running and the port' \
                                 'number it is using. All application types have predefined port numbers, but you can'
                                 'also use an specific port number if needed.'
                                 )

parser.add_argument('--host', dest='host_name', type=str, default='localhost',
                    help='Hostname where the server application is running. Defaults to \'localhost\'.'
                    )

parser.add_argument('--slot', dest='slot_number', type=int, choices=[2,3,4,5,6,7],
                    help='Connect a GUI to pysmurf server running on a AMC carrier, located in this slot number.'\
                    'Ignored if option \"--port\" is used.'
                    )

parser.add_argument('--atca-monitor', action='store_true',
                    help='Connect a GUI to an atca_monitor rogue server. Ignored if options \"--slot\" or \"--port\" are used.'
                    )

parser.add_argument('--pcie', action='store_true',
                    help='Connect a GUI to a PCIe card rogue server. Ignored if options \"--slot\", \"--port\" \
                    or \"--atca-monitor\" are used.'
                    )

parser.add_argument('--port', type=int, dest='port_number',
                    help='Connect to a rogue application running on a non-predefined port number.'
                    )

args = parser.parse_args()

# Hostname where the remote server is running
host = args.host_name

# GUI window title
title=None

# Process the input option by priority:
# - port number,
# - pysmurf server running on a AMCc carrier,
# - atca-monitor rogue server, and
# - PCIe card rogue server
if args.port_number:
    port = args.port_number
    print(f'Starting a GUI on {host}:{port}')
elif args.slot_number:
    port = 9000 + 2*args.slot_number
    title=f'smurf_server_s{args.slot_number} ({host}:{port})'
    print(f'Starting a GUI for the server running on slot {args.slot_number} ({host}:{port})')
elif args.atca_monitor:
    port = 9100
    title=f'atca-monitor ({host}:{port})'
    print(f'Starting a GUI for the atca-monitor application ({host}:{port})')
elif args.pcie:
    port = 9102
    title=f'Pcie ({host}:{port})'
    print(f'Starting a GUI for the PCIe card application ({host}:{port})')
else:
    print(f'ERROR: Must choose an application type or a port number')
    exit(-1)

# Start the GUI here
import pyrogue.pydm
pyrogue.pydm.runPyDM(serverList=f'{host}:{port}',title=title)