#!/bin/bash
echo "=== МОЙ ПЕРВЫЙ BASH-СКРИПТ ==="
echo ""
echo "Текущая дата и время: $(date)"
echo "Пользователь: $(whoami)"
echo "Текущая папка: $(pwd)"
echo ""
echo "Создаю папку 'scripts_results'..."
mkdir -p scripts_results

echo "Создаю файл с текущей датой..."
current_date=$(date +"%Y-%m-%d_%H-%M-%S")
echo "Файл создан: $current_date" > "scripts_results/file_$current_date.txt"
echo ""
echo "Как вас зовут?"
read user_name
echo "Привет, $user_name!" >> "scripts_results/file_$current_date.txt"

echo "Скрипт завершен! Результаты в папке 'scripts_results'"
