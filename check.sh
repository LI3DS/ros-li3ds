#!/bin/bash
if docker volume ls | grep -q $1; then
    echo "found"
fi
