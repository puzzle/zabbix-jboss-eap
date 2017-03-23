#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

java -jar ${SCRIPT_DIR}/lib/JMXDiscovery-0.0.1.jar "$@"
