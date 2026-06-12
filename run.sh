#!/bin/bash

set -Eeuo pipefail

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)"

build_generator() {
    echo "=== Сборка Docker-образа для генератора ==="
    docker build -t data_generator_image "$PROJECT_DIR/generator"
}

run_generator() {
    echo "=== Запуск генератора ==="
    mkdir -p "$PROJECT_DIR/data"
    
    docker run --rm -v "$PROJECT_DIR/data:/data" data_generator_image
    
    echo "Файл успешно сгенерирован в data/data.csv"
}

create_local_data() {
    echo "=== Локальная отладка (без Docker) ==="
    mkdir -p "$PROJECT_DIR/local_data"
    
    python3 "$PROJECT_DIR/generator/generate.py" "$PROJECT_DIR/local_data"
    
    echo "Файл успешно сгенерирован в local_data/data.csv"
}

case "$1" in
    build_generator)   build_generator ;;
    run_generator)     run_generator ;;
    create_local_data) create_local_data ;;
    *)
        echo "Использование: $0 {build_generator|run_generator|create_local_data}"
        exit 1
        ;;
esac