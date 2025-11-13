#!/bin/bash

# Универсальный Git помощник на русском языке
echo "=========================================="
echo "   🚀 УНИВЕРСАЛЬНЫЙ GIT ПОМОЩНИК"
echo "=========================================="

# Функция проверки Git репозитория
check_git_repo() {
    if [ ! -d ".git" ]; then
        echo "❌ Это не Git репозиторий"
        return 1
    fi
    return 0
}

# Функция проверки статуса
check_status() {
    if check_git_repo; then
        echo "📊 ПРОВЕРКА СТАТУСА РЕПОЗИТОРИЯ..."
        git status
    fi
}

# Функция показа веток
show_branches() {
    if check_git_repo; then
        echo "🌿 ВЕТКИ РЕПОЗИТОРИЯ:"
        echo "Локальные ветки:"
        git branch
        echo ""
        echo "Удаленные ветки:"
        git branch -r
    fi
}

# Функция добавления и коммита
add_commit() {
    if check_git_repo; then
        echo "💾 ДОБАВЛЕНИЕ И КОММИТ ИЗМЕНЕНИЙ..."
        echo "Измененные файлы:"
        git status --short
        
        read -p "Добавить все файлы? (y/n): " add_all
        if [ "$add_all" = "y" ]; then
            git add .
        else
            read -p "Укажите файлы для добавления: " files
            git add $files
        fi
        
        read -p "Введите сообщение коммита: " message
        git commit -m "$message"
        echo "✅ КОММИТ СОЗДАН!"
    fi
}

# Функция отправки изменений
push_changes() {
    if check_git_repo; then
        echo "🚀 ОТПРАВКА ИЗМЕНЕНИЙ НА СЕРВЕР..."
        current_branch=$(git branch --show-current)
        echo "Текущая ветка: $current_branch"
        
        git push origin $current_branch
        echo "✅ ИЗМЕНЕНИЯ ОТПРАВЛЕНЫ!"
    fi
}

# Функция загрузки изменений
pull_changes() {
    if check_git_repo; then
        echo "📥 ЗАГРУЗКА ИЗМЕНЕНИЙ С СЕРВЕРА..."
        current_branch=$(git branch --show-current)
        echo "Текущая ветка: $current_branch"
        
        git pull origin $current_branch
        echo "✅ ИЗМЕНЕНИЯ ЗАГРУЖЕНЫ!"
    fi
}

# Функция создания ветки
create_branch() {
    if check_git_repo; then
        read -p "Введите название новой ветки: " new_branch
        git checkout -b $new_branch
        echo "✅ ВЕТКА '$new_branch' СОЗДАНА И АКТИВИРОВАНА!"
    fi
}

# Функция переключения ветки
switch_branch() {
    if check_git_repo; then
        echo "Доступные ветки:"
        git branch
        read -p "Введите название ветки для переключения: " branch_name
        git checkout $branch_name
        echo "✅ ПЕРЕКЛЮЧЕНО НА ВЕТКУ '$branch_name'!"
    fi
}

# Функция настройки удаленного репозитория
setup_remote() {
    if check_git_repo; then
        read -p "Введите URL удаленного репозитория: " repo_url
        git remote add origin $repo_url
        echo "✅ УДАЛЕННЫЙ РЕПОЗИТОРИЙ НАСТРОЕН!"
    fi
}

# Функция смены директории
change_directory() {
    echo "📁 СМЕНА РАБОЧЕЙ ДИРЕКТОРИИ..."
    echo "Текущая папка: $(pwd)"
    echo ""
    
    read -p "Введите путь к новой папке: " new_dir
    
    if [ -d "$new_dir" ]; then
        cd "$new_dir"
        echo "✅ ПЕРЕШЛИ В ПАПКУ: $(pwd)"
        
        if [ -d ".git" ]; then
            echo "🎉 Обнаружен Git репозиторий!"
            check_status
        else
            echo "⚠️  В этой папке нет Git репозитория"
            read -p "Инициализировать новый репозиторий? (y/n): " init_repo
            if [ "$init_repo" = "y" ]; then
                git init
                echo "✅ НОВЫЙ GIT РЕПОЗИТОРИЙ СОЗДАН!"
            fi
        fi
    else
        echo "❌ ПАПКА НЕ СУЩЕСТВУЕТ: $new_dir"
    fi
}

# Функция создания папки
create_directory() {
    read -p "Введите название новой папки: " dir_name
    mkdir -p "$dir_name"
    echo "✅ ПАПКА '$dir_name' СОЗДАНА!"
    
    read -p "Перейти в созданную папку? (y/n): " go_there
    if [ "$go_there" = "y" ]; then
        cd "$dir_name"
        echo "✅ ПЕРЕШЛИ В ПАПКУ: $(pwd)"
    fi
}

# Функция настройки SSH
setup_ssh() {
    echo "🔑 НАСТРОЙКА SSH КЛЮЧА ДЛЯ GITHUB"
    
    # Создание директории если нет
    mkdir -p ~/.ssh
    chmod 700 ~/.ssh

    echo "🔐 СОЗДАНИЕ НОВОГО SSH КЛЮЧА..."
    ssh-keygen -t ed25519 -C "github_$(whoami)@$(hostname)" -f ~/.ssh/id_ed25519 -N ""

    echo "🚀 ЗАПУСК SSH-АГЕНТА..."
    eval "$(ssh-agent -s)"

    echo "➕ ДОБАВЛЕНИЕ КЛЮЧА..."
    ssh-add ~/.ssh/id_ed25519

    echo ""
    echo "📋 ВАШ ПУБЛИЧНЫЙ КЛЮЧ (скопируйте ВСЮ строку):"
    echo "=========================================="
    cat ~/.ssh/id_ed25519.pub
    echo "=========================================="

    echo ""
    echo "📝 ИНСТРУКЦИЯ ДЛЯ GITHUB:"
    echo "1. Откройте https://github.com/settings/ssh"
    echo "2. Нажмите 'New SSH key'"
    echo "3. В поле 'Title' введите: Мой компьютер"
    echo "4. В поле 'Key' вставьте скопированный ключ"
    echo "5. Нажмите 'Add SSH key'"
}

# Функция диагностики проблем
diagnose_issues() {
    echo "🔍 ДИАГНОСТИКА GIT ПРОБЛЕМ"
    
    echo "1. Проверка Git репозитория..."
    if check_git_repo; then
        echo "✅ Git репозиторий обнаружен"
    else
        echo "❌ Не Git репозиторий"
        return
    fi
    
    echo ""
    echo "2. Проверка удаленных репозиториев..."
    git remote -v
    
    echo ""
    echo "3. Проверка веток..."
    git branch -a
    
    echo ""
    echo "4. Проверка статуса..."
    git status
    
    echo ""
    echo "5. Проверка SSH подключения (если настроено)..."
    if git remote -v | grep -q "@"; then
        ssh -T git@github.com
    fi
}

# Функция показа истории коммитов
show_history() {
    if check_git_repo; then
        echo "📜 ИСТОРИЯ КОММИТОВ (последние 10):"
        git log --oneline -10
    fi
}

# Функция показа файлов
show_files() {
    echo "📁 ФАЙЛЫ В ПАПКЕ:"
    ls -la
}

# Главное меню
main_menu() {
    while true; do
        echo ""
        echo "📍 ТЕКУЩАЯ ПАПКА: $(pwd)"
        if check_git_repo; then
            echo "🌿 ТЕКУЩАЯ ВЕТКА: $(git branch --show-current)"
        fi
        echo ""
        echo "🎯 ГЛАВНОЕ МЕНЮ:"
        echo "1.  Проверить статус Git"
        echo "2.  Показать все ветки"
        echo "3.  Показать историю коммитов"
        echo "4.  Показать файлы в папке"
        echo "5.  Добавить и закоммитить изменения"
        echo "6.  Отправить изменения на сервер"
        echo "7.  Загрузить изменения с сервера"
        echo "8.  Создать новую ветку"
        echo "9.  Переключить ветку"
        echo "10. Настроить удаленный репозиторий"
        echo "11. Сменить рабочую папку"
        echo "12. Создать новую папку"
        echo "13. Настроить SSH ключ"
        echo "14. Диагностика проблем"
        echo "15. Выйти"
        echo ""
        
        read -p "Ваш выбор (1-15): " choice
        
        case $choice in
            1) check_status ;;
            2) show_branches ;;
            3) show_history ;;
            4) show_files ;;
            5) add_commit ;;
            6) push_changes ;;
            7) pull_changes ;;
            8) create_branch ;;
            9) switch_branch ;;
            10) setup_remote ;;
            11) change_directory ;;
            12) create_directory ;;
            13) setup_ssh ;;
            14) diagnose_issues ;;
            15) 
                echo "👋 ДО СВИДАНИЯ!"
                exit 0
                ;;
            *) 
                echo "❌ НЕПРАВИЛЬНЫЙ ВЫБОР!"
                ;;
        esac
    done
}

# Запуск главного меню
main_menu
