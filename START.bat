@echo off
echo ========================================
echo   Linky - R&D Talent Scraper
echo   Запуск проекта
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

echo [1/4] Сборка и запуск контейнеров...
docker-compose up -d --build
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
docker-compose exec -T app alembic upgrade head
if errorlevel 1 (
    echo [ПРЕДУПРЕЖДЕНИЕ] Не удалось применить миграции (возможно, БД еще не готова)
)

echo.
echo [4/4] Инициализация базы данных...
docker-compose exec -T app python scripts/init_db.py
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
echo   Prometheus:       http://localhost:9090
echo   Grafana:          http://localhost:3000 (admin/admin)
echo.
echo   Для просмотра логов: docker-compose logs -f
echo   Для остановки:       docker-compose down
echo.
pause

