#!/bin/bash

echo "=== ПОМОЩНИК GIT ==="
echo "1. Проверить статус"
echo "2. Добавить все файлы"
echo "3. Сделать коммит"
echo "4. Отправить на GitHub"
echo "5. Выйти"

read choice

case $choice in
    1)
        git status
        ;;
    2)
        git add .
        echo "Файлы добавлены!"
        ;;
    3)
        echo "Введите сообщение коммита:"
        read message
        git commit -m "$message"
        ;;
    4)
        git push origin main
        ;;
    5)
        echo "Выход..."
        exit 0
        ;;
    *)
        echo "Неверный выбор"
        ;;
esac

#!/bin/bash

while true; do
    echo ""
    echo "=== ПОМОЩНИК GIT ==="
    echo "1. Проверить статус"
    echo "2. Добавить все файлы"
    echo "3. Сделать коммит"
    echo "4. Отправить на GitHub"
    echo "5. Выйти"
    echo ""
    echo -n "Выберите действие (1-5): "

    read choice

    case $choice in
        1)
            git status
            ;;
        2)
            git add .
            echo "✅ Файлы добавлены!"
            ;;
        3)
            echo -n "Введите сообщение коммита: "
            read message
            git commit -m "$message"
            ;;
        4)
            git push origin main
            ;;
        5)
            echo "👋 Выход..."
            exit 0
            ;;
        *)
            echo "❌ Неверный выбор! Попробуйте снова."
            ;;
    esac

    echo ""
    read -p "Нажмите Enter чтобы продолжить..."
done
