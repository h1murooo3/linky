# Руководство по развертыванию Linky

## Предварительные требования

- Docker и Docker Compose
- Python 3.11+ (для локальной разработки)
- PostgreSQL 15+ (если не используется Docker)
- Redis (если не используется Docker)

## Быстрый старт

### 1. Клонирование и настройка

```bash
git clone <repository-url>
cd linky
cp .env.example .env
# Отредактируйте .env файл с вашими настройками
```

### 2. Запуск через Docker Compose

**Важно:** Убедитесь, что Docker Desktop запущен перед выполнением команд!

```bash
# Сборка и запуск всех сервисов
docker-compose up -d

# Проверка статуса
docker-compose ps

# Просмотр логов
docker-compose logs -f app

# Если контейнеры не запускаются, проверьте:
# 1. Docker Desktop запущен
# 2. Порты 8000, 5432, 6379 не заняты другими приложениями
```

### 3. Применение миграций

```bash
# Внутри контейнера
docker-compose exec app alembic upgrade head

# Или локально (если установлен Python)
alembic upgrade head
```

### 4. Проверка работы

**Основные сервисы:**
- API: http://localhost:8000
- Swagger документация: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc
- Метрики Prometheus: http://localhost:8000/metrics

**Мониторинг (опционально):**
> **Примечание:** Prometheus и Grafana закомментированы в `docker-compose.yml` по умолчанию.
> Для их запуска раскомментируйте соответствующие секции в `docker-compose.yml` и перезапустите:
> ```bash
> docker-compose up -d
> ```
> После этого будут доступны:
> - Prometheus: http://localhost:9090
> - Grafana: http://localhost:3000 (admin/admin)

## Разработка

### Локальная разработка без Docker

```bash
# Создание виртуального окружения
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate

# Установка зависимостей
pip install -r requirements.txt

# Настройка переменных окружения
export DATABASE_URL=postgresql://user:pass@localhost:5432/linky_db
export REDIS_URL=redis://localhost:6379/0
export SECRET_KEY=your-secret-key

# Запуск миграций
alembic upgrade head

# Запуск приложения
uvicorn app.main:app --reload
```

## Тестирование

### Unit тесты

```bash
pytest tests/ -v --cov=app
```

### Performance тесты (k6)

```bash
# Установка k6
# Windows: choco install k6
# Linux: https://k6.io/docs/getting-started/installation/

# Запуск теста
k6 run k6/load_test.js
```

## Мониторинг

### Prometheus метрики

Метрики доступны по адресу: http://localhost:8000/metrics

Основные метрики:
- `http_requests_total` - общее количество HTTP запросов
- `http_request_duration_seconds` - длительность запросов
- `scraped_jobs_total` - количество собранных вакансий
- `processed_jobs_total` - количество обработанных вакансий

### Grafana дашборды

1. Войдите в Grafana (http://localhost:3000)
2. Используйте учетные данные по умолчанию: admin/admin
3. Prometheus datasource уже настроен автоматически

## Безопасность

### Production настройки

1. **Измените SECRET_KEY** в `.env` на случайную строку:
   ```bash
   python -c "import secrets; print(secrets.token_urlsafe(32))"
   ```

2. **Настройте CORS** в `app/main.py`:
   ```python
   allow_origins=["https://yourdomain.com"]
   ```

3. **Используйте HTTPS** в production

4. **Настройте firewall** для ограничения доступа к БД

5. **Регулярно обновляйте зависимости**:
   ```bash
   pip list --outdated
   pip install --upgrade <package>
   ```

## Масштабирование

### Горизонтальное масштабирование

```yaml
# docker-compose.yml
services:
  app:
    deploy:
      replicas: 3
```

### Вертикальное масштабирование

Увеличьте ресурсы для контейнеров в `docker-compose.yml`:
```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '2'
          memory: 2G
```

## Резервное копирование

### БД резервное копирование

```bash
# Создание бэкапа
docker-compose exec db pg_dump -U linky_user linky_db > backup.sql

# Восстановление
docker-compose exec -T db psql -U linky_user linky_db < backup.sql
```

## Troubleshooting

### Проблемы с подключением к БД

```bash
# Проверка статуса БД
docker-compose exec db pg_isready -U linky_user

# Просмотр логов БД
docker-compose logs db
```

### Проблемы с Celery

```bash
# Проверка статуса воркеров
docker-compose exec celery_worker celery -A app.core.celery_app inspect active

# Перезапуск воркеров
docker-compose restart celery_worker celery_beat
```

### Очистка данных

```bash
# Остановка и удаление всех контейнеров и volumes
docker-compose down -v

# Очистка неиспользуемых ресурсов Docker
docker system prune -a
```

