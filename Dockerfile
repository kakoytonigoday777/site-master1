FROM python:3.11-slim

# Создаем пользователя с ID 1000, как того требует Hugging Face
RUN useradd -m -u 1000 user

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем файл с зависимостями и устанавливаем их
COPY --chown=user requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь остальной код в контейнер
COPY --chown=user . .

# Переключаемся на пользователя (для безопасности)
USER user
ENV HOME=/home/user
ENV PATH=/home/user/.local/bin:$PATH

# Открываем порт, который ждет Hugging Face
EXPOSE 7860

# Запускаем ваш сервер
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "7860"]