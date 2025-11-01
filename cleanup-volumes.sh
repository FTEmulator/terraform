#!/bin/bash
echo "=== Cleanup Persistent Volumes ==="
echo ""
echo "This script will delete all data in the persistent volumes used by the applications."
echo "WARNING: This will delete ALL database and application data"
echo ""
read -p "Are you sure? (type 'y' to continue): " confirmacion

if [ "$confirmacion" != "y" ]; then
    echo "Operation canceled."
    exit 1
fi

echo ""
echo "Deleting data from volumes..."

# Delete PostgreSQL data
if [ -d "/mnt/postgres" ]; then
    echo "  - Deleting /mnt/postgres..."
    sudo rm -rf /mnt/postgres/*
fi

# Delete Auth data (includes Redis)
if [ -d "/mnt/auth" ]; then
    echo "  - Deleting /mnt/auth..."
    sudo rm -rf /mnt/auth/*
fi

# Delete Profile data
if [ -d "/mnt/profile" ]; then
    echo "  - Deleting /mnt/profile..."
    sudo rm -rf /mnt/profile/*
fi

# Delete API data
if [ -d "/mnt/api" ]; then
    echo "  - Deleting /mnt/api..."
    sudo rm -rf /mnt/api/*
fi

# Delete Website data
if [ -d "/mnt/website" ]; then
    echo "  - Deleting /mnt/website..."
    sudo rm -rf /mnt/website/*
fi

echo ""
echo "=== Cleanup completed ==="
echo ""
echo "Now you can run: terraform apply"
