@echo off
echo ========================================
echo   Настройка Git и загрузка на GitHub
echo ========================================
echo.

REM Проверка Git
git --version >nul 2>&1
if errorlevel 1 (
    echo [ОШИБКА] Git не установлен!
    echo Установите Git с https://git-scm.com/
    pause
    exit /b 1
)

echo [1/4] Инициализация Git репозитория...
if exist .git (
    echo Git уже инициализирован
) else (
    git init
    echo Git инициализирован
)

echo.
echo [2/4] Добавление файлов...
git add .
echo Файлы добавлены

echo.
echo [3/4] Создание первого коммита...
git commit -m "Initial commit: Linky R&D Talent Scraper" 2>nul
if errorlevel 1 (
    echo [ПРЕДУПРЕЖДЕНИЕ] Коммит не создан (возможно, нет изменений)
) else (
    echo Коммит создан
)

echo.
echo [4/4] Инструкции по загрузке на GitHub:
echo.
echo 1. Создайте репозиторий на https://github.com/new
echo    - Название: linky
echo    - НЕ добавляйте README, .gitignore или лицензию
echo.
echo 2. Выполните команды:
echo    git remote add origin https://github.com/YOUR_USERNAME/linky.git
echo    git branch -M main
echo    git push -u origin main
echo.
echo Или используйте GitHub CLI:
echo    gh repo create linky --public --source=. --remote=origin --push
echo.
echo Подробная инструкция в файле GITHUB_SETUP.md
echo.
pause

