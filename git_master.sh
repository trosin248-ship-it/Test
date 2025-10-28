#!/bin/bash

# Цвета
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Функции
print_header() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║                  GIT MASTER ASSISTANT             ║"
    echo "║           Полный контроль над Git                 ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_info() {
    echo -e "${GREEN}Текущая ветка:${NC} $(git branch --show-current)"
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

# Основные категории
basic_operations() {
    while true; do
        echo -e "${YELLOW}=== ОСНОВНЫЕ ОПЕРАЦИИ ===${NC}"
        echo "1.  📊 Статус репозитория"
        echo "2.  📁 Добавить файлы"
        echo "3.  💾 Создать коммит"
        echo "4.  📜 История коммитов"
        echo "5.  🔄 Сравнить изменения (diff)"
        echo "6.  🗑️  Отменить изменения"
        echo "7.  📦 Создать архив"
        echo "8.  ↩️  Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1) git status ;;
            2) 
                echo "1. Добавить все"
                echo "2. Добавить конкретный файл"
                echo "3. Добавить с патчем"
                read -p "Выберите: " add_choice
                case $add_choice in
                    1) git add . ;;
                    2) 
                        ls -la
                        read -p "Имя файла: " f; git add "$f" 
                        ;;
                    3) git add -p ;;
                esac
                ;;
            3)
                git status --short
                read -p "Сообщение коммита: " msg
                git commit -m "$msg"
                ;;
            4)
                echo "1. Краткая история"
                echo "2. Подробная история"
                echo "3. История с графиком"
                read -p "Выберите: " hist_choice
                case $hist_choice in
                    1) git log --oneline -20 ;;
                    2) git log -10 ;;
                    3) git log --oneline --graph --all -15 ;;
                esac
                ;;
            5)
                echo "1. Diff рабочей директории"
                echo "2. Diff staged файлов"
                echo "3. Diff между коммитами"
                read -p "Выберите: " diff_choice
                case $diff_choice in
                    1) git diff ;;
                    2) git diff --staged ;;
                    3)
                        git log --oneline -10
                        read -p "Хэш коммита 1: " h1
                        read -p "Хэш коммита 2: " h2
                        git diff $h1 $h2
                        ;;
                esac
                ;;
            6)
                echo "1. Отменить добавление файла"
                echo "2. Отменить коммит (soft)"
                echo "3. Отменить коммит (hard)"
                echo "4. Восстановить файл"
                read -p "Выберите: " undo_choice
                case $undo_choice in
                    1) 
                        git status --short
                        read -p "Имя файла: " f; git reset "$f" 
                        ;;
                    2) git reset --soft HEAD~1 ;;
                    3) 
                        echo -e "${RED}⚠️ Это удалит изменения!${NC}"
                        read -p "Вы уверены? [y/N]: " confirm
                        [[ $confirm == "y" ]] && git reset --hard HEAD~1
                        ;;
                    4)
                        git log --oneline -10
                        read -p "Хэш коммита: " commit_hash
                        read -p "Имя файла: " filename
                        git checkout $commit_hash -- "$filename"
                        ;;
                esac
                ;;
            7) git archive --format=zip -o backup.zip HEAD ;;
            8) break ;;
            *) echo -e "${RED}Неверный выбор${NC}" ;;
        esac
        echo && read -p "Нажмите Enter..."
    done
}

branch_operations() {
    while true; do
        echo -e "${YELLOW}=== УПРАВЛЕНИЕ ВЕТКАМИ ===${NC}"
        echo "1.  🌿 Создать ветку"
        echo "2.  🔄 Переключиться на ветку"
        echo "3.  📋 Список веток"
        echo "4.  ✏️  Переименовать ветку"
        echo "5.  🗑️  Удалить ветку"
        echo "6.  🔀 Слияние веток"
        echo "7.  🏷️  Работа с тегами"
        echo "8.  ↩️  Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1) 
                read -p "Имя новой ветки: " branch_name
                git checkout -b "$branch_name"
                ;;
            2)
                git branch
                read -p "Имя ветки: " branch_name
                git checkout "$branch_name"
                ;;
            3)
                echo -e "${GREEN}Локальные ветки:${NC}"
                git branch
                echo -e "${GREEN}Удаленные ветки:${NC}"
                git branch -r
                echo -e "${GREEN}Все ветки:${NC}"
                git branch -a
                ;;
            4)
                git branch
                read -p "Текущее имя: " old_name
                read -p "Новое имя: " new_name
                git branch -m "$old_name" "$new_name"
                ;;
            5)
                git branch
                read -p "Имя ветки для удаления: " branch_name
                git branch -d "$branch_name"
                ;;
            6)
                echo "1. Merge (быстрое слияние)"
                echo "2. Rebase (перебазирование)"
                read -p "Выберите: " merge_choice
                git branch
                read -p "Имя ветки: " branch_name
                case $merge_choice in
                    1) git merge "$branch_name" ;;
                    2) git rebase "$branch_name" ;;
                esac
                ;;
            7)
                echo "1. Создать тег"
                echo "2. Список тегов"
                echo "3. Удалить тег"
                read -p "Выберите: " tag_choice
                case $tag_choice in
                    1) 
                        read -p "Имя тега: " tag_name
                        read -p "Сообщение: " tag_msg
                        git tag -a "$tag_name" -m "$tag_msg"
                        ;;
                    2) git tag -l ;;
                    3)
                        git tag -l
                        read -p "Имя тега: " tag_name
                        git tag -d "$tag_name"
                        ;;
                esac
                ;;
            8) break ;;
            *) echo -e "${RED}Неверный выбор${NC}" ;;
        esac
        echo && read -p "Нажмите Enter..."
    done
}

remote_operations() {
    while true; do
        echo -e "${YELLOW}=== РАБОТА С УДАЛЕННЫМ РЕПОЗИТОРИЕМ ===${NC}"
        echo "1.  📡 Проверить remote"
        echo "2.  ➕ Добавить remote"
        echo "3.  🚀 Push (отправить)"
        echo "4.  📥 Pull (получить)"
        echo "5.  📋 Fetch (загрузить)"
        echo "6.  🗑️  Удалить remote"
        echo "7.  👀 Просмотр удаленного repo"
        echo "8.  ↩️  Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1) git remote -v ;;
            2)
                read -p "Имя (обычно origin): " remote_name
                read -p "URL: " remote_url
                git remote add "$remote_name" "$remote_url"
                ;;
            3)
                git remote -v
                read -p "Remote имя: " remote_name
                read -p "Ветка: " branch_name
                git push "$remote_name" "$branch_name"
                ;;
            4)
                git remote -v
                read -p "Remote имя: " remote_name
                read -p "Ветка: " branch_name
                git pull "$remote_name" "$branch_name"
                ;;
            5) git fetch --all ;;
            6)
                git remote -v
                read -p "Имя remote для удаления: " remote_name
                git remote remove "$remote_name"
                ;;
            7)
                git remote -v
                read -p "Имя remote: " remote_name
                git remote show "$remote_name"
                ;;
            8) break ;;
            *) echo -e "${RED}Неверный выбор${NC}" ;;
        esac
        echo && read -p "Нажмите Enter..."
    done
}

advanced_operations() {
    while true; do
        echo -e "${YELLOW}=== ПРОДВИНУТЫЕ ОПЕРАЦИИ ===${NC}"
        echo "1.  🎭 Stash (временное сохранение)"
        echo "2.  🔍 Поиск в истории"
        echo "3.  🏗️  Субмодули"
        echo "4.  ⚙️  Конфигурация Git"
        echo "5.  🧹 Очистка репозитория"
        echo "6.  🗂️  Работа с поддиректориями"
        echo "7.  ↩️  Назад"
        
        read -p "Выберите: " choice
        
        case $choice in
            1)
                echo "1. Сохранить в stash"
                echo "2. Показать stash список"
                echo "3. Применить stash"
                echo "4. Удалить stash"
                read -p "Выберите: " stash_choice
                case $stash_choice in
                    1) 
                        read -p "Сообщение: " msg
                        git stash push -m "$msg"
                        ;;
                    2) git stash list ;;
                    3) 
                        git stash list
                        read -p "Номер stash: " num
                        git stash apply "stash@{$num}"
                        ;;
                    4)
                        git stash list
                        read -p "Номер stash: " num
                        git stash drop "stash@{$num}"
                        ;;
                esac
                ;;
            2)
                echo "1. Поиск по сообщению коммита"
                echo "2. Поиск по изменению в коде"
                echo "3. Поиск по автору"
                read -p "Выберите: " search_choice
                case $search_choice in
                    1) 
                        read -p "Текст для поиска: " text
                        git log --oneline --grep="$text"
                        ;;
                    2)
                        read -p "Текст в коде: " text
                        git log -p -S "$text"
                        ;;
                    3)
                        read -p "Имя автора: " author
                        git log --oneline --author="$author"
                        ;;
                esac
                ;;
            3)
                echo "1. Добавить субмодуль"
                echo "2. Инициализировать субмодули"
                echo "3. Обновить субмодули"
                read -p "Выберите: " sub_choice
                case $sub_choice in
                    1)
                        read -p "URL репозитория: " repo_url
                        read -p "Путь: " path
                        git submodule add "$repo_url" "$path"
                        ;;
                    2) git submodule init ;;
                    3) git submodule update ;;
                esac
                ;;
            4)
                echo "1. Показать конфиг"
                echo "2. Установить имя"
                echo "3. Установить email"
                echo "4. Установить редактор"
                read -p "Выберите: " config_choice
                case $config_choice in
                    1) git config --list ;;
                    2)
                        read -p "Имя пользователя: " name
                        git config --global user.name "$name"
                        ;;
                    3)
                        read -p "Email: " email
                        git config --global user.email "$email"
                        ;;
                    4)
                        echo "1. Vim"
                        echo "2. Nano"
                        echo "3. Code (VS Code)"
                        read -p "Выберите редактор: " editor_choice
                        case $editor_choice in
                            1) git config --global core.editor "vim" ;;
                            2) git config --global core.editor "nano" ;;
                            3) git config --global core.editor "code --wait" ;;
                        esac
                        ;;
                esac
                ;;
            5)
                echo -e "${RED}⚠️ Опасные операции!${NC}"
                echo "1. Очистить неотслеживаемые файлы"
                echo "2. Сбросить все изменения"
                read -p "Выберите: " clean_choice
                case $clean_choice in
                    1)
                        read -p "Вы уверены? [y/N]: " confirm
                        [[ $confirm == "y" ]] && git clean -fd
                        ;;
                    2)
                        echo -e "${RED}❌ Это удалит ВСЕ изменения!${NC}"
                        read -p "Точно уверены? [y/N]: " confirm
                        [[ $confirm == "y" ]] && git reset --hard && git clean -fd
                        ;;
                esac
                ;;
            6)
                echo "1. Показать дерево файлов"
                echo "2. Поиск файлов"
                read -p "Выберите: " dir_choice
                case $dir_choice in
                    1) 
                        find . -type f -name "*.sh" -o -name "*.py" -o -name "*.md" -o -name "*.txt" | head -20
                        ;;
                    2)
                        read -p "Имя файла: " filename
                        find . -name "*$filename*" -type f
                        ;;
                esac
                ;;
            7) break ;;
            *) echo -e "${RED}Неверный выбор${NC}" ;;
        esac
        echo && read -p "Нажмите Enter..."
    done
}

main_menu() {
    while true; do
        print_header
        show_info
        
        echo -e "${PURPLE}=== ГЛАВНОЕ МЕНЮ ===${NC}"
        echo "1. 📝 Основные операции"
        echo "2. 🌿 Управление ветками"
        echo "3. 📡 Работа с удаленным репозиторием"
        echo "4. ⚡ Продвинутые операции"
        echo "5. 🎯 Быстрые действия"
        echo "6. ℹ️  Информация о репозитории"
        echo "7. 🚪 Выход"
        echo ""
        
        read -p "Выберите категорию [1-7]: " main_choice
        
        case $main_choice in
            1) basic_operations ;;
            2) branch_operations ;;
            3) remote_operations ;;
            4) advanced_operations ;;
            5)
                echo -e "${GREEN}🚀 Быстрые действия:${NC}"
                echo "1. Статус + добавить + коммит + пуш"
                echo "2. Создать feature ветку"
                echo "3. Обновить основную ветку"
                read -p "Выберите: " quick_choice
                case $quick_choice in
                    1)
                        git status
                        git add .
                        read -p "Сообщение коммита: " msg
                        git commit -m "$msg"
                        git push origin $(git branch --show-current)
                        ;;
                    2)
                        read -p "Имя feature: " feature_name
                        git checkout -b "feature/$feature_name"
                        ;;
                    3)
                        git checkout main
                        git pull origin main
                        ;;
                esac
                ;;
            6)
                echo -e "${CYAN}=== ИНФОРМАЦИЯ О РЕПОЗИТОРИИ ===${NC}"
                echo "Размер репозитория: $(du -sh .git | cut -f1)"
                echo "Количество коммитов: $(git rev-list --count HEAD)"
                echo "Последний коммит: $(git log -1 --format=%cd --date=relative)"
                echo "Автор последнего коммита: $(git log -1 --format=%an)"
                echo "Ветка по умолчанию: $(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | cut -d'/' -f2 || echo 'не установлена')"
                ;;
            7)
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
