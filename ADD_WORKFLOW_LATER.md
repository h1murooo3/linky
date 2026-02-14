# Добавление GitHub Actions Workflow

## Проблема

Текущий токен не имеет прав `workflow` для обновления GitHub Actions.

## Решение

### Вариант 1: Создать новый токен с правами workflow

1. Перейдите: https://github.com/settings/tokens
2. Создайте новый токен с правами:
   - ✅ `repo` (полный доступ)
   - ✅ `workflow` (обновление GitHub Actions)
3. Используйте новый токен:
   ```bash
   git remote set-url origin https://NEW_TOKEN@github.com/h1murooo3/linky.git
   git add .github/workflows/ci.yml
   git commit -m "Add CI/CD workflow"
   git push
   ```

### Вариант 2: Добавить workflow через веб-интерфейс

1. Перейдите на GitHub: https://github.com/h1murooo3/linky
2. Создайте файл `.github/workflows/ci.yml` через веб-интерфейс
3. Скопируйте содержимое из локального файла

### Вариант 3: Использовать GitHub CLI

```bash
gh auth login
# Выберите токен с правами workflow
git add .github/workflows/ci.yml
git commit -m "Add CI/CD workflow"
git push
```

## Текущий статус

✅ Проект загружен на GitHub  
⏳ Workflow файл нужно добавить с токеном, имеющим права `workflow`

