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

build_reporter() {
    echo "=== Сборка Docker-образа для аналитика ==="
    docker build -t data_reporter_image "$PROJECT_DIR/reporter"
}

run_reporter() {
    echo "=== Запуск аналитика ==="

    if [ ! -f "$PROJECT_DIR/data/data.csv" ]; then
        echo "Ошибка: Файл $PROJECT_DIR/data/data.csv не найден"
        echo "Сначала сгенерируйте данные с помощью ./run.sh run_generator"
        exit 1
    fi

    docker run --rm -v "$PROJECT_DIR/data:/data" data_reporter_image
    
    echo "Отчет сгенерирован в data/report.html"
}

case "$1" in
    build_generator)   build_generator ;;
    run_generator)     run_generator ;;
    create_local_data) create_local_data ;;
    build_reporter)    build_reporter ;;
    run_reporter)      run_reporter ;;
    *)
        echo "Использование: $0 {build_generator|run_generator|create_local_data|build_reporter|run_reporter}"
        exit 1
        ;;
esac