# Инструкция по загрузке на GitHub

## Подготовка репозитория

1. **Создайте репозиторий на GitHub:**
   - Перейдите на https://github.com/new
   - Название: `linky` (или другое по желанию)
   - Описание: "R&D Talent Scraper - Сервис мониторинга вакансий и компетенций"
   - Выберите Public или Private
   - НЕ добавляйте README, .gitignore или лицензию (они уже есть)

2. **Инициализируйте Git в проекте:**

```bash
# Инициализация
git init

# Добавление всех файлов
git add .

# Первый коммит
git commit -m "Initial commit: Linky R&D Talent Scraper"

# Добавление remote репозитория (замените YOUR_USERNAME на ваш GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/linky.git

# Переименование ветки в main (если нужно)
git branch -M main

# Отправка на GitHub
git push -u origin main
```

## Альтернативный способ (через GitHub CLI)

```bash
# Установите GitHub CLI если еще не установлен
# https://cli.github.com/

# Авторизация
gh auth login

# Создание репозитория и загрузка
gh repo create linky --public --source=. --remote=origin --push
```

## Что НЕ будет загружено (благодаря .gitignore)

- `__pycache__/` - кэш Python
- `.env` - секретные ключи
- `*.log` - логи
- `venv/` - виртуальное окружение
- Docker volumes и данные

## После загрузки

1. **Добавьте описание репозитория:**
   - Перейдите в Settings → General
   - Добавьте описание проекта

2. **Настройте GitHub Actions:**
   - Файл `.github/workflows/ci.yml` уже настроен
   - Actions будут работать автоматически при push

3. **Добавьте темы (Topics):**
   - python, fastapi, docker, postgresql, scraping, jobs-api

4. **Создайте Release:**
   - Перейдите в Releases → Create a new release
   - Тег: v1.0.0
   - Название: "Initial Release"

## Размер репозитория

После оптимизации проект занимает примерно:
- **Код:** ~500 KB
- **Документация:** ~50 KB
- **Конфигурация:** ~20 KB
- **Итого:** ~570 KB (без учета истории Git)

## Полезные команды

```bash
# Проверка размера репозитория
git count-objects -vH

# Очистка истории (если нужно уменьшить размер)
git gc --aggressive --prune=now

# Просмотр файлов, которые будут загружены
git ls-files | wc -l
```


