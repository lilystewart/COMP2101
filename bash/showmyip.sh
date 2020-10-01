#!/bin/bash
ip a s ens33 | grep -w inet | awk '{print $2}'
