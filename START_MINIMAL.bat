@echo off
echo ========================================
echo   Linky - Минимальная версия
echo   (Без мониторинга для экономии места)
echo ========================================
echo.

REM Проверка Docker
docker ps >nul 2>&1
if errorlevel 1 (
    echo [ОШИБКА] Docker Desktop не запущен!
    echo Пожалуйста, запустите Docker Desktop и попробуйте снова.
    pause
    exit /b 1
)

echo [1/4] Сборка и запуск контейнеров (минимальная версия)...
docker-compose -f docker-compose.minimal.yml up -d --build
if errorlevel 1 (
    echo [ОШИБКА] Не удалось запустить контейнеры
    pause
    exit /b 1
)

echo.
echo [2/4] Ожидание готовности базы данных...
timeout /t 10 /nobreak >nul

echo.
echo [3/4] Применение миграций базы данных...
docker-compose -f docker-compose.minimal.yml exec -T app alembic upgrade head
if errorlevel 1 (
    echo [ПРЕДУПРЕЖДЕНИЕ] Не удалось применить миграции (возможно, БД еще не готова)
)

echo.
echo [4/4] Инициализация базы данных...
docker-compose -f docker-compose.minimal.yml exec -T app python scripts/init_db.py
if errorlevel 1 (
    echo [ПРЕДУПРЕЖДЕНИЕ] Не удалось инициализировать БД
)

echo.
echo ========================================
echo   Проект успешно запущен!
echo ========================================
echo.
echo   API:              http://localhost:8000
echo   Swagger Docs:     http://localhost:8000/docs
echo.
echo   Для просмотра логов: docker-compose -f docker-compose.minimal.yml logs -f
echo   Для остановки:       docker-compose -f docker-compose.minimal.yml down
echo.
pause

