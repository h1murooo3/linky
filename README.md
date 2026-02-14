# Linky - R&D Talent Scraper

[![Python](https://img.shields.io/badge/Python-3.11-blue.svg)](https://www.python.org/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.104-green.svg)](https://fastapi.tiangolo.com/)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Сервис мониторинга вакансий и компетенций в сфере науки (LinkedIn, HeadHunter).

## Архитектура проекта

- **Data Collector**: Парсинг вакансий с LinkedIn и HeadHunter
- **Data Storage**: PostgreSQL с Alembic миграциями
- **Data Processor**: Очистка и нормализация данных
- **RESTful API**: FastAPI с Swagger документацией
- **Auth Service**: JWT аутентификация
- **Containerization**: Docker + docker-compose
- **CI/CD**: GitHub Actions
- **Observability**: Prometheus + Grafana
- **Performance Testing**: k6

## Быстрый старт

### Минимальная версия (рекомендуется для начала)

```bash
# Запустить минимальную версию (без мониторинга)
docker-compose -f docker-compose.minimal.yml up -d --build

# Или использовать скрипт (Windows)
START_MINIMAL.bat
```

### Полная версия (с мониторингом)

```bash
# Запустить все сервисы включая Prometheus и Grafana
docker-compose up -d --build

# Или использовать скрипт (Windows)
START.bat
```

После запуска:
- API: http://localhost:8000
- Swagger документация: http://localhost:8000/docs
- Prometheus (только полная версия): http://localhost:9090
- Grafana (только полная версия): http://localhost:3000

## Структура проекта

```
linky/
├── app/
│   ├── api/              # REST API endpoints
│   ├── core/             # Конфигурация, security
│   ├── models/           # SQLAlchemy модели
│   ├── schemas/          # Pydantic схемы
│   ├── services/         # Бизнес-логика
│   │   ├── collector/    # Data Collector
│   │   └── processor/    # Data Processor
│   ├── db/               # База данных, миграции
│   └── main.py           # Точка входа
├── tests/                # Тесты
├── docker/               # Docker конфигурации
├── k6/                   # Performance тесты
├── docker-compose.yml
├── Dockerfile
└── requirements.txt
```

## Переменные окружения

Создайте файл `.env` на основе `.env.example`:

```bash
DATABASE_URL=postgresql://user:password@db:5432/linky
REDIS_URL=redis://redis:6379/0
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

## Разработка

```bash
# Установить зависимости
pip install -r requirements.txt

# Запустить миграции
alembic upgrade head

# Запустить приложение
uvicorn app.main:app --reload
```

## Тестирование

```bash
# Unit тесты
pytest

# Performance тесты
k6 run k6/load_test.js
```

## Мониторинг

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)
- API Metrics: http://localhost:8000/metrics

