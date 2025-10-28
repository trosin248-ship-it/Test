#!/bin/bash

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════╗"
    echo "║               GIT MASTER FIXED              ║"  
    echo "║         Оптимизирован для Windows           ║"
    echo "╚══════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_info() {
    echo -e "${GREEN}Текущая ветка:${NC} $(git branch --show-current 2>/dev/null || echo 'не определена')"
    echo -e "${GREEN}Текущая папка:${NC} $(pwd)"
    echo ""
}

check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Это не Git репозиторий!${NC}"
        return 1
    fi
    return 0
}

# Упрощенные и надежные функции
basic_operations() {
    while true; do
        echo -e "${YELLOW}=== ОСНОВНЫЕ ОПЕРАЦИИ ===${NC}"
        echo "1. 📊 Статус репозитория"
        echo "2. 📁 Добавить файлы"
        echo "3. 💾 Создать коммит" 
        echo "4. 📜 История коммитов"
        echo "5. 🔄 Сравнить изменения (diff)"
        echo "6. 🗑️ Отменить добавление файлов"
        echo "7. ↩️ Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1) 
                git status
                ;;
            2) 
                echo "1. Добавить все файлы"
                echo "2. Добавить конкретный файл"
                read -p "Выберите: " add_choice
                case $add_choice in
                    1) 
                        git add .
                        echo -e "${GREEN}✅ Все файлы добавлены!${NC}"
                        ;;
                    2) 
                        echo "Файлы в папке:"
                        ls -la | grep "^-" | head -10
                        read -p "Имя файла: " filename
                        git add "$filename"
                        echo -e "${GREEN}✅ Файл '$filename' добавлен!${NC}"
                        ;;
                esac
                ;;
            3)
                echo "Изменения для коммита:"
                git status --short
                read -p "Сообщение коммита: " msg
                git commit -m "$msg"
                echo -e "${GREEN}✅ Коммит создан!${NC}"
                ;;
            4)
                echo "1. Краткая история (10 последних)"
                echo "2. Подробная история (5 последних)"
                read -p "Выберите: " hist_choice
                case $hist_choice in
                    1) git log --oneline -10 ;;
                    2) git log -5 ;;
                esac
                ;;
            5)
                git diff
                ;;
            6)
                echo "Добавленные файлы:"
                git status --short
                read -p "Имя файла для отмены (или Enter для всех): " filename
                if [ -z "$filename" ]; then
                    git reset HEAD
                    echo -e "${GREEN}✅ Все файлы убраны из индекса!${NC}"
                else
                    git reset HEAD "$filename"
                    echo -e "${GREEN}✅ Файл '$filename' убран из индекса!${NC}"
                fi
                ;;
            7) break ;;
            *) echo -e "${RED}❌ Неверный выбор!${NC}" ;;
        esac
        echo && read -p "Нажмите Enter чтобы продолжить..."
    done
}

branch_operations() {
    while true; do
        echo -e "${YELLOW}=== УПРАВЛЕНИЕ ВЕТКАМИ ===${NC}"
        echo "1. 🌿 Создать ветку"
        echo "2. 🔄 Переключиться на ветку" 
        echo "3. 📋 Список веток"
        echo "4. 🗑️ Удалить ветку"
        echo "5. ↩️ Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1) 
                read -p "Имя новой ветки: " branch_name
                git checkout -b "$branch_name"
                echo -e "${GREEN}✅ Ветка '$branch_name' создана!${NC}"
                ;;
            2)
                echo "Доступные ветки:"
                git branch
                read -p "Имя ветки: " branch_name
                git checkout "$branch_name"
                ;;
            3)
                echo -e "${GREEN}Локальные ветки:${NC}"
                git branch
                echo -e "${GREEN}Удаленные ветки:${NC}" 
                git branch -r
                ;;
            4)
                echo "Доступные ветки:"
                git branch
                read -p "Имя ветки для удаления: " branch_name
                git branch -d "$branch_name"
                ;;
            5) break ;;
            *) echo -e "${RED}❌ Неверный выбор!${NC}" ;;
        esac
        echo && read -p "Нажмите Enter чтобы продолжить..."
    done
}

remote_operations() {
    while true; do
        echo -e "${YELLOW}=== РАБОТА С GITHUB ===${NC}"
        echo "1. 📡 Проверить подключение"
        echo "2. 🚀 Отправить изменения (push)"
        echo "3. 📥 Получить обновления (pull)" 
        echo "4. ↩️ Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1) 
                git remote -v
                echo ""
                echo -e "Проверка подключения к GitHub..."
                ssh -T git@github.com
                ;;
            2)
                current_branch=$(git branch --show-current)
                echo "Текущая ветка: $current_branch"
                git push origin "$current_branch"
                ;;
            3)
                current_branch=$(git branch --show-current) 
                echo "Текущая ветка: $current_branch"
                git pull origin "$current_branch"
                ;;
            4) break ;;
            *) echo -e "${RED}❌ Неверный выбор!${NC}" ;;
        esac
        echo && read -p "Нажмите Enter чтобы продолжить..."
    done
}

quick_actions() {
    while true; do
        echo -e "${YELLOW}=== БЫСТРЫЕ ДЕЙСТВИЯ ===${NC}"
        echo "1. 🚀 Статус + Добавить + Коммит + Пуш"
        echo "2. 🔄 Обновить ветку из GitHub"
        echo "3. 🆕 Создать feature ветку"
        echo "4. 📊 Показать статистику"
        echo "5. ↩️ Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1)
                echo "=== АВТОМАТИЧЕСКИЙ WORKFLOW ==="
                git status
                echo ""
                git add .
                read -p "Сообщение коммита: " msg
                git commit -m "$msg"
                git push origin $(git branch --show-current)
                echo -e "${GREEN}✅ Весь workflow выполнен!${NC}"
                ;;
            2)
                current_branch=$(git branch --show-current)
                echo "Обновление ветки: $current_branch"
                git pull origin "$current_branch"
                ;;
            3)
                read -p "Имя feature (без 'feature/'): " feature_name
                git checkout -b "feature/$feature_name"
                ;;
            4)
                echo "=== СТАТИСТИКА РЕПОЗИТОРИЯ ==="
                echo "Количество коммитов: $(git rev-list --count HEAD)"
                echo "Последний коммит: $(git log -1 --format=%cd --date=short)"
                echo "Автор: $(git log -1 --format=%an)"
                echo "Размер .git: $(du -sh .git | cut -f1)"
                ;;
            5) break ;;
            *) echo -e "${RED}❌ Неверный выбор!${NC}" ;;
        esac
        echo && read -p "Нажмите Enter чтобы продолжить..."
    done
}

main_menu() {
    while true; do
        print_header
        show_info
        
        echo -e "${PURPLE}=== ГЛАВНОЕ МЕНЮ ===${NC}"
        echo "1. 📝 Основные операции"
        echo "2. 🌿 Управление ветками" 
        echo "3. 📡 Работа с GitHub"
        echo "4. ⚡ Быстрые действия"
        echo "5. 🚪 Выход"
        echo ""
        
        read -p "Выберите категорию [1-5]: " main_choice
        
        case $main_choice in
            1) basic_operations ;;
            2) branch_operations ;;
            3) remote_operations ;;
            4) quick_actions ;;
            5)
                echo -e "${GREEN}👋 До свидания!${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}❌ Неверный выбор!${NC}"
                ;;
        esac
        
        echo ""
        read -p "Нажмите Enter чтобы продолжить..."
    done
}

# Запуск
if check_git_repo; then
    main_menu
else
    echo -e "${RED}Запустите скрипт в папке Git репозитория!${NC}"
    echo "Сначала выполните: git init"
    exit 1
fi
