# Инструкция по загрузке на GitHub

## Проблема: Ошибка доступа (403)

Требуется аутентификация для загрузки кода. Есть несколько способов:

## Способ 1: Personal Access Token (Рекомендуется)

1. **Создайте токен на GitHub:**
   - Перейдите: https://github.com/settings/tokens
   - Нажмите "Generate new token" → "Generate new token (classic)"
   - Название: "Linky Project"
   - Выберите права: `repo` (полный доступ к репозиториям)
   - Нажмите "Generate token"
   - **Скопируйте токен** (он показывается только один раз!)

2. **Используйте токен при push:**
   ```bash
   git push -u origin main
   # Username: h1murooo3
   # Password: ВСТАВЬТЕ_ВАШ_ТОКЕН_ЗДЕСЬ
   ```

3. **Или измените URL на токен:**
   ```bash
   git remote set-url origin https://YOUR_TOKEN@github.com/h1murooo3/linky.git
   git push -u origin main
   ```

## Способ 2: SSH (Более безопасно)

1. **Проверьте наличие SSH ключа:**
   ```bash
   ls ~/.ssh/id_rsa.pub
   ```

2. **Если нет ключа, создайте:**
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

3. **Добавьте ключ на GitHub:**
   - Скопируйте содержимое: `cat ~/.ssh/id_rsa.pub`
   - Перейдите: https://github.com/settings/keys
   - Нажмите "New SSH key"
   - Вставьте ключ и сохраните

4. **Измените remote на SSH:**
   ```bash
   git remote set-url origin git@github.com:h1murooo3/linky.git
   git push -u origin main
   ```

## Способ 3: GitHub CLI (Самый простой)

```bash
# Установите GitHub CLI: https://cli.github.com/
gh auth login
git push -u origin main
```

## Текущий статус

✅ Git репозиторий инициализирован  
✅ Все файлы добавлены (65 файлов)  
✅ Коммит создан  
✅ Remote настроен  
⏳ Ожидается аутентификация для push  

## После успешной загрузки

Проект будет доступен по адресу:
**https://github.com/h1murooo3/linky**


