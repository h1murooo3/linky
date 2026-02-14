# Быстрый старт Linky

## Минимальные требования

- Docker Desktop (Windows/Mac) или Docker + Docker Compose (Linux)
- Git
- 4GB свободной RAM
- 10GB свободного места на диске

## Установка за 5 минут

### Шаг 1: Клонирование проекта

```bash
git clone <repository-url>
cd linky
```

### Шаг 2: Создание файла окружения

Создайте файл `.env` в корне проекта со следующим содержимым:

```env
# Database
DATABASE_URL=postgresql://linky_user:linky_password@db:5432/linky_db
POSTGRES_USER=linky_user
POSTGRES_PASSWORD=linky_password
POSTGRES_DB=linky_db

# Redis
REDIS_URL=redis://redis:6379/0

# Security (ОБЯЗАТЕЛЬНО ИЗМЕНИТЕ В PRODUCTION!)
SECRET_KEY=change-this-to-random-string-in-production
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# API
API_V1_PREFIX=/api/v1

# Scraping
USER_AGENT_ROTATION=true
REQUEST_DELAY=2
MAX_RETRIES=3
PROXY_ENABLED=false

# Monitoring
PROMETHEUS_ENABLED=true
LOG_LEVEL=INFO
```

### Шаг 3: Запуск всех сервисов

```bash
# Сборка и запуск
docker-compose up -d

# Проверка статуса (все сервисы должны быть "Up")
docker-compose ps
```

### Шаг 4: Инициализация базы данных

```bash
# Применение миграций
docker-compose exec app alembic upgrade head

# Создание начального пользователя
docker-compose exec app python scripts/init_db.py
```

### Шаг 5: Проверка работы

Откройте в браузере:
- **API документация:** http://localhost:8000/docs
- **API:** http://localhost:8000
- **Prometheus:** http://localhost:9090
- **Grafana:** http://localhost:3000 (логин: admin, пароль: admin)

## Первые шаги

### 1. Регистрация пользователя

```bash
curl -X POST "http://localhost:8000/api/v1/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "myuser",
    "email": "user@example.com",
    "password": "mypassword123"
  }'
```

### 2. Вход в систему

```bash
curl -X POST "http://localhost:8000/api/v1/auth/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=myuser&password=mypassword123"
```

Сохраните полученный `access_token`.

### 3. Получение списка вакансий

```bash
curl -X GET "http://localhost:8000/api/v1/jobs/" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Запуск парсинга (вручную)

```bash
# Парсинг HeadHunter
docker-compose exec celery_worker celery -A app.core.celery_app call app.services.collector.tasks.scrape_hh_jobs

# Парсинг LinkedIn
docker-compose exec celery_worker celery -A app.core.celery_app call app.services.collector.tasks.scrape_linkedin_jobs
```

## Полезные команды

### Просмотр логов

```bash
# Все сервисы
docker-compose logs -f

# Только приложение
docker-compose logs -f app

# Только Celery
docker-compose logs -f celery_worker
```

### Остановка сервисов

```bash
docker-compose down
```

### Полная очистка (удаление всех данных)

```bash
docker-compose down -v
```

### Перезапуск сервиса

```bash
docker-compose restart app
```

### Выполнение команд внутри контейнера

```bash
# Python shell
docker-compose exec app python

# Bash shell
docker-compose exec app bash

# Выполнение миграций
docker-compose exec app alembic upgrade head
```

## Решение проблем

### Проблема: Порт уже занят

```bash
# Измените порты в docker-compose.yml
ports:
  - "8001:8000"  # Вместо 8000:8000
```

### Проблема: База данных не запускается

```bash
# Проверьте логи
docker-compose logs db

# Пересоздайте volume
docker-compose down -v
docker-compose up -d
```

### Проблема: Celery не работает

```bash
# Проверьте статус Redis
docker-compose exec redis redis-cli ping

# Перезапустите Celery
docker-compose restart celery_worker celery_beat
```

## Следующие шаги

1. Прочитайте [DEPLOYMENT.md](DEPLOYMENT.md) для детальной информации
2. Изучите [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) для понимания архитектуры
3. Настройте автоматический парсинг через Celery Beat
4. Настройте Grafana дашборды для мониторинга
5. Запустите performance тесты: `k6 run k6/load_test.js`

## Поддержка

При возникновении проблем:
1. Проверьте логи: `docker-compose logs`
2. Убедитесь, что все переменные окружения установлены
3. Проверьте, что порты не заняты другими приложениями
4. Пересоздайте контейнеры: `docker-compose down && docker-compose up -d`

