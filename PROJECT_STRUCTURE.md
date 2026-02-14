# Структура проекта Linky

## Обзор

Linky - это полнофункциональный сервис для мониторинга вакансий и компетенций в сфере науки и R&D. Проект включает все необходимые компоненты для сбора, обработки и предоставления данных через REST API.

## Архитектура

```
linky/
├── app/                          # Основное приложение
│   ├── api/                      # REST API endpoints
│   │   ├── v1/                   # API версии 1
│   │   │   ├── auth.py           # Аутентификация (регистрация, логин)
│   │   │   └── jobs.py           # CRUD операции с вакансиями
│   │   └── deps.py               # Зависимости API
│   ├── core/                     # Ядро приложения
│   │   ├── config.py             # Конфигурация (Pydantic Settings)
│   │   ├── database.py           # SQLAlchemy настройки
│   │   ├── security.py           # JWT, хеширование паролей
│   │   ├── dependencies.py       # FastAPI dependencies
│   │   ├── celery_app.py         # Celery конфигурация
│   │   ├── monitoring.py         # Prometheus метрики
│   │   ├── security_middleware.py # Защита от атак
│   │   ├── input_validator.py    # Валидация входных данных
│   │   └── logging_config.py     # Настройка логирования
│   ├── models/                   # SQLAlchemy модели
│   │   ├── user.py               # Модель пользователя
│   │   └── job.py                # Модели вакансий и навыков
│   ├── schemas/                  # Pydantic схемы
│   │   ├── user.py               # Схемы для пользователей
│   │   └── job.py                # Схемы для вакансий
│   ├── services/                 # Бизнес-логика
│   │   ├── collector/            # Data Collector
│   │   │   ├── base_scraper.py  # Базовый класс скрейпера
│   │   │   ├── linkedin_scraper.py # LinkedIn парсер
│   │   │   ├── hh_scraper.py    # HeadHunter парсер
│   │   │   ├── service.py        # Сервис сохранения данных
│   │   │   └── tasks.py          # Celery задачи
│   │   └── processor/            # Data Processor
│   │       └── job_processor.py # Очистка и нормализация
│   ├── db/                       # (резерв для миграций)
│   └── main.py                   # Точка входа FastAPI
├── alembic/                      # Миграции БД
│   ├── versions/                 # Файлы миграций
│   ├── env.py                    # Конфигурация Alembic
│   └── script.py.mako            # Шаблон миграций
├── tests/                        # Тесты
│   ├── test_auth.py              # Тесты аутентификации
│   └── test_jobs.py              # Тесты API вакансий
├── docker/                       # Docker конфигурации
│   ├── prometheus/               # Prometheus config
│   └── grafana/                  # Grafana provisioning
├── k6/                           # Performance тесты
│   └── load_test.js              # k6 скрипт
├── scripts/                      # Вспомогательные скрипты
│   └── init_db.py               # Инициализация БД
├── .github/workflows/            # CI/CD
│   └── ci.yml                   # GitHub Actions pipeline
├── docker-compose.yml            # Оркестрация контейнеров
├── Dockerfile                    # Образ приложения
├── requirements.txt              # Python зависимости
├── alembic.ini                   # Конфигурация Alembic
├── pytest.ini                    # Конфигурация pytest
├── Makefile                      # Удобные команды
├── README.md                     # Основная документация
├── DEPLOYMENT.md                 # Руководство по развертыванию
└── PROJECT_STRUCTURE.md          # Этот файл
```

## Компоненты

### 1. Data Collector (Сборщик данных)

**Файлы:**
- `app/services/collector/base_scraper.py` - Базовый класс с обходом блокировок
- `app/services/collector/linkedin_scraper.py` - Парсер LinkedIn
- `app/services/collector/hh_scraper.py` - Парсер HeadHunter
- `app/services/collector/tasks.py` - Celery задачи для автоматизации

**Функциональность:**
- Ротация User-Agent
- Задержки между запросами
- Повторные попытки при ошибках
- Сохранение без дубликатов

### 2. Data Storage (Хранилище)

**Модели:**
- `User` - Пользователи системы
- `Job` - Вакансии
- `JobSkill` - Навыки, извлеченные из вакансий

**Миграции:**
- Alembic для управления схемой БД
- Автоматическое создание таблиц

### 3. Data Processor (Обработчик)

**Файл:** `app/services/processor/job_processor.py`

**Функциональность:**
- Очистка HTML тегов
- Нормализация текста
- Извлечение навыков
- Категоризация навыков

### 4. RESTful API

**Endpoints:**
- `POST /api/v1/auth/register` - Регистрация
- `POST /api/v1/auth/login` - Вход
- `GET /api/v1/auth/me` - Текущий пользователь
- `GET /api/v1/jobs/` - Список вакансий (с фильтрацией)
- `GET /api/v1/jobs/{id}` - Детали вакансии
- `GET /api/v1/jobs/stats/summary` - Статистика

**Документация:** Автоматическая Swagger на `/docs`

### 5. Auth Service

**Реализация:**
- JWT токены (python-jose)
- Хеширование паролей (bcrypt)
- Защита эндпоинтов через dependencies

### 6. Containerization

**Docker:**
- `Dockerfile` - Образ приложения
- `docker-compose.yml` - Оркестрация:
  - PostgreSQL
  - Redis
  - FastAPI приложение
  - Celery worker
  - Celery beat
  - Prometheus
  - Grafana

### 7. CI/CD Pipeline

**GitHub Actions:**
- Линтинг (flake8, black, isort)
- Тестирование (pytest)
- Сборка Docker образа
- Security сканирование (Trivy)

### 8. Observability

**Prometheus:**
- Метрики HTTP запросов
- Метрики парсинга
- Метрики обработки

**Grafana:**
- Автоматическая настройка datasource
- Готовые дашборды

**Логирование:**
- JSON формат
- Централизованное логирование

### 9. Performance Testing

**k6:**
- Нагрузочное тестирование
- Сценарии с разными уровнями нагрузки
- Метрики производительности

### 10. Security

**Меры защиты:**
- Security headers (XSS, CSRF)
- Валидация входных данных
- Защита от SQL инъекций (SQLAlchemy)
- JWT аутентификация
- Environment variables для секретов

## Технологический стек

- **Backend:** Python 3.11, FastAPI
- **Database:** PostgreSQL 15
- **ORM:** SQLAlchemy 2.0
- **Migrations:** Alembic
- **Task Queue:** Celery + Redis
- **Authentication:** JWT (python-jose)
- **Monitoring:** Prometheus + Grafana
- **Testing:** pytest, k6
- **Containerization:** Docker, Docker Compose
- **CI/CD:** GitHub Actions

## Запуск проекта

```bash
# 1. Клонирование
git clone <repo>
cd linky

# 2. Настройка окружения
cp .env.example .env
# Отредактируйте .env

# 3. Запуск
docker-compose up -d

# 4. Миграции
docker-compose exec app alembic upgrade head

# 5. Инициализация БД
docker-compose exec app python scripts/init_db.py
```

## Разработка

```bash
# Установка зависимостей
pip install -r requirements.txt

# Запуск тестов
pytest

# Создание миграции
alembic revision --autogenerate -m "description"

# Применение миграций
alembic upgrade head
```

## Следующие шаги

1. Добавить больше источников данных
2. Улучшить извлечение навыков (NLP)
3. Добавить веб-интерфейс
4. Реализовать уведомления
5. Добавить аналитику и дашборды

