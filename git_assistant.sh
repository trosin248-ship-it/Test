#!/bin/bash

# Цвета для красивого вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода заголовка
print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════╗"
    echo "║           GIT АССИСТЕНТ             ║"
    echo "║     Автоматизация работы с Git      ║"
    echo "╚══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Функция для проверки Git репозитория
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo -e "${RED}❌ Это не Git репозиторий!${NC}"
        echo "Сначала выполните: git init"
        return 1
    fi
    return 0
}

# Функция для показа статуса
show_status() {
    echo -e "${YELLOW}=== ТЕКУЩИЙ СТАТУС ===${NC}"
    git status
}

# Функция для добавления файлов
add_files() {
    echo -e "${YELLOW}=== ДОБАВЛЕНИЕ ФАЙЛОВ ===${NC}"
    echo "1. Добавить все файлы"
    echo "2. Добавить конкретный файл"
    echo "3. Вернуться назад"
    
    read -p "Выберите вариант [1-3]: " add_choice
    
    case $add_choice in
        1)
            git add .
            echo -e "${GREEN}✅ Все файлы добавлены!${NC}"
            ;;
        2)
            echo "Доступные файлы:"
            git status --porcelain | grep -E '^\?\?'
            read -p "Введите имя файла: " filename
            git add "$filename"
            echo -e "${GREEN}✅ Файл '$filename' добавлен!${NC}"
            ;;
        3)
            return
            ;;
        *)
            echo -e "${RED}❌ Неверный выбор!${NC}"
            ;;
    esac
}

# Функция для создания коммита
make_commit() {
    echo -e "${YELLOW}=== СОЗДАНИЕ КОММИТА ===${NC}"
    
    # Показываем изменения
    echo "Изменения для коммита:"
    git status --short
    
    if git diff --cached --quiet && git diff --quiet; then
        echo -e "${YELLOW}⚠️ Нет изменений для коммита${NC}"
        return
    fi
    
    read -p "Введите сообщение коммита: " message
    
    if [ -z "$message" ]; then
        message="Автоматический коммит $(date '+%Y-%m-%d %H:%M:%S')"
    fi
    
    git commit -m "$message"
    echo -e "${GREEN}✅ Коммит создан!${NC}"
}

# Функция для работы с ветками
branch_management() {
    echo -e "${YELLOW}=== УПРАВЛЕНИЕ ВЕТКАМИ ===${NC}"
    echo "1. Создать новую ветку"
    echo "2. Переключиться на ветку"
    echo "3. Показать все ветки"
    echo "4. Удалить ветку"
    echo "5. Вернуться назад"
    
    read -p "Выберите вариант [1-5]: " branch_choice
    
    case $branch_choice in
        1)
            read -p "Введите имя новой ветки: " new_branch
            git checkout -b "$new_branch"
            echo -e "${GREEN}✅ Ветка '$new_branch' создана!${NC}"
            ;;
        2)
            echo "Доступные ветки:"
            git branch
            read -p "Введите имя ветки: " switch_branch
            git checkout "$switch_branch"
            ;;
        3)
            echo -e "${YELLOW}=== ВЕТКИ ===${NC}"
            git branch -a
            ;;
        4)
            echo "Доступные ветки:"
            git branch
            read -p "Введите имя ветки для удаления: " delete_branch
            git branch -d "$delete_branch"
            ;;
        5)
            return
            ;;
        *)
            echo -e "${RED}❌ Неверный выбор!${NC}"
            ;;
    esac
}

# Функция для отправки на GitHub
push_to_github() {
    echo -e "${YELLOW}=== ОТПРАВКА НА GITHUB ===${NC}"
    
    # Проверяем есть ли remote
    if ! git remote get-url origin > /dev/null 2>&1; then
        echo -e "${YELLOW}⚠️ Не настроен remote origin${NC}"
        read -p "Хотите добавить? [y/N]: " add_remote
        if [[ $add_remote == "y" || $add_remote == "Y" ]]; then
            read -p "Введите URL репозитория: " repo_url
            git remote add origin "$repo_url"
        else
            return
        fi
    fi
    
    current_branch=$(git branch --show-current)
    echo "Отправка ветки: $current_branch"
    
    git push origin "$current_branch"
    echo -e "${GREEN}✅ Изменения отправлены!${NC}"
}

# Функция для показа истории
show_history() {
    echo -e "${YELLOW}=== ИСТОРИЯ КОММИТОВ ===${NC}"
    git log --oneline --graph --all -10
}

# Главное меню
main_menu() {
    while true; do
        clear
        print_header
        
        echo -e "${GREEN}Текущая ветка:${NC} $(git branch --show-current 2>/dev/null || echo 'не определена')"
        echo -e "${GREEN}Текущая папка:${NC} $(pwd)"
        echo ""
        
        echo "1. 📊 Проверить статус"
        echo "2. 📁 Добавить файлы"
        echo "3. 💾 Сделать коммит"
        echo "4. 🌿 Управление ветками"
        echo "5. 🚀 Отправить на GitHub"
        echo "6. 📜 История коммитов"
        echo "7. 🔄 Получить обновления (pull)"
        echo "8. 🗂️  Показать файлы проекта"
        echo "9. 🚪 Выйти"
        echo ""
        
        read -p "Выберите действие [1-9]: " main_choice
        
        case $main_choice in
            1)
                show_status
                ;;
            2)
                add_files
                ;;
            3)
                make_commit
                ;;
            4)
                branch_management
                ;;
            5)
                push_to_github
                ;;
            6)
                show_history
                ;;
            7)
                echo -e "${YELLOW}=== ПОЛУЧЕНИЕ ОБНОВЛЕНИЙ ===${NC}"
                git pull origin main
                ;;
            8)
                echo -e "${YELLOW}=== ФАЙЛЫ ПРОЕКТА ===${NC}"
                find . -type f -name "*.sh" -o -name "*.py" -o -name "*.md" -o -name "*.txt" | head -20
                ;;
            9)
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

# Запуск скрипта
clear
if check_git_repo; then
    main_menu
else
    echo -e "${RED}Запустите скрипт в папке Git репозитория!${NC}"
    exit 1
fi
