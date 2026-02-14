# Быстрая настройка GitHub репозитория

## Шаг 1: Инициализация Git

```bash
git init
git add .
git commit -m "Initial commit: Linky R&D Talent Scraper"
```

## Шаг 2: Создание репозитория на GitHub

1. Откройте https://github.com/new
2. Название: `linky`
3. Описание: "R&D Talent Scraper - Сервис мониторинга вакансий"
4. Выберите Public или Private
5. **НЕ** добавляйте README, .gitignore или лицензию
6. Нажмите "Create repository"

## Шаг 3: Подключение и загрузка

```bash
# Замените YOUR_USERNAME на ваш GitHub username
git remote add origin https://github.com/YOUR_USERNAME/linky.git
git branch -M main
git push -u origin main
```

## Или используйте GitHub CLI (проще):

```bash
# Установите GitHub CLI: https://cli.github.com/
gh auth login
gh repo create linky --public --source=. --remote=origin --push
```

## Размер проекта

- **Код:** ~500 KB
- **Документация:** ~50 KB  
- **Конфигурация:** ~20 KB
- **Итого:** ~570 KB

## Важно!

Файл `.env` НЕ будет загружен (защищен .gitignore).
Создайте `.env.example` для других разработчиков.

## После загрузки

1. Добавьте описание в настройках репозитория
2. Добавьте теги: `python`, `fastapi`, `docker`, `postgresql`
3. Настройте GitHub Actions (уже готов в `.github/workflows/ci.yml`)


