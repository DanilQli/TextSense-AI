""""import torch
from flask import Flask, jsonify, request
from transformers import AutoTokenizer, AutoModelForSequenceClassification

app = Flask(__name__)


@app.route('/', methods=['POST'])
def api_response():
    data = request.get_json()
    text = data.get('text', 'default_value')
    path = data.get('path', 'default_value')
    model = AutoModelForSequenceClassification.from_pretrained(path)
    tokenizer = AutoTokenizer.from_pretrained(path)
    inputs = tokenizer(text, return_tensors='pt', truncation=True, padding=True).to(model.device)
    proba = torch.sigmoid(model(**inputs).logits.detach()).cpu().numpy()[0]
    inputs = proba.dot([-1, 0, 1])
    response_data = {'output': inputs, 'outputEmotions': inputs}
    return jsonify(response_data)


if __name__ == '__main__':
    app.run()"""

import os

ROOT_DIR = 'lib'
FILE_MASK = '*.dart'
OUTPUT_FILE = 'all.dart'


def main():
    print(f"[*] Начинаю сканировать '{ROOT_DIR}' на предмет файлов '{FILE_MASK}'...")

    all_code_lines = []

    for current_dir, dirs, files in os.walk(ROOT_DIR):
        dart_files = [fname for fname in files if fname.endswith('.dart')]

        for dart_file in dart_files:
            full_file_path = os.path.join(current_dir, dart_file)
            relative_path = os.path.relpath(full_file_path, start=ROOT_DIR)
            comment_path = relative_path.replace(os.sep, '-')

            try:
                with open(full_file_path, 'r', encoding='utf-8') as f:
                    content = f.readlines()

                non_empty_lines = [line for line in content if line.strip()]

                all_code_lines.append(f'// {comment_path}\n')
                all_code_lines.extend(non_empty_lines)
                all_code_lines.append('\n')

                print(
                    f"    [+] добавил файл: {relative_path} (было {len(content)} строк, стало {len(non_empty_lines)})")

            except Exception as e:
                print(f"    [!] ПРОПУЩЕН файл {relative_path} : ошибка -> {e}")

    code_len = len(all_code_lines)
    print(
        f"\n[*] Всего обработано файлов. Итоговый all.dart будет содержать {code_len} строк (включая комментарии, но без лишних пустых строк)")
    try:
        with open(OUTPUT_FILE, 'w', encoding='utf-8') as out:
            out.writelines(all_code_lines)
        print(f"\n[+] Успешно записан файл '{OUTPUT_FILE}'")
    except Exception as e:
        print(f"\n[!] НЕ СМОГ ЗАПИСАТЬ {OUTPUT_FILE} : ошибка {e}")

    print("[*] ГОТОВО.")

def find_and_print_structure(start_path):
    """
    Проходит по указанной директории и всем ее подпапкам,
    ищет файлы с расширениями .tscn и .gd,
    выводит структуру директории с найденными файлами.

    Args:
        start_path (str): Путь к начальной директории.
    """

    if not os.path.isdir(start_path):
        print(f"Ошибка: Директория не найдена или не является директорией: '{start_path}'")
        return

    print(f"Структура директории '{start_path}':")
    print("-" * 30) # Разделитель для наглядности

    # Normalize path for consistent comparison (handle trailing slashes, etc.)
    normalized_start_path = os.path.normpath(start_path)
    start_parts = normalized_start_path.split(os.sep)
    start_depth = len(start_parts)

    for root, dirs, files in os.walk(start_path):
        # Нормализуем текущий путь и вычисляем глубину
        normalized_root = os.path.normpath(root)
        root_parts = normalized_root.split(os.sep)
        current_depth = len(root_parts) - start_depth

        # Создаем отступ для печати
        indent = '    ' * current_depth # 4 пробела на уровень

        # Печатаем название текущей папки
        # Для корневой папки выводим полный путь, для остальных - только имя
        if normalized_root == normalized_start_path:
            print(f"{indent}{os.path.basename(normalized_root)}/")
        else:
             print(f"{indent}{os.path.basename(root)}/")

        # Ищем нужные файлы в текущей папке
        found_files_in_dir = []
        for file in files:
            # Получаем расширение файла
            _, ext = os.path.splitext(file)
            # Проверяем, является ли расширение искомым (без учета регистра)
            if ext.lower() in ['.tscn', '.gd']:
                found_files_in_dir.append(file)

        # Печатаем найденные файлы с дополнительным отступом
        if found_files_in_dir:
            file_indent = '    ' * (current_depth + 1)
            for found_file in found_files_in_dir:
                print(f"{file_indent}{found_file}")

    print("-" * 30)
    print("Поиск завершен.")


if __name__ == '__main__':
    #main()
    #directory_to_scan = r"D:\Практика\Курсовая\Script"  # Используем r"" для обработки \
    #find_and_print_structure(directory_to_scan)
    import re

    # Задаём имя исходного и выходного файлов
    input_file = 'autosave.xml'  # Измените на имя вашего текстового файла
    output_file = 'output.xml'

    # Компилируем регулярное выражение: строка должна начинаться с "0.", затем идти ровно 8 символов (любые)
    pattern = re.compile(r"^0\..{8}$")

    # Открываем исходный файл для чтения
    with open(input_file, 'r', encoding='utf-8') as file:
        lines = file.readlines()

    # Открываем выходной файл для записи
    with open(output_file, 'w', encoding='utf-8') as file:
        i = 0
        while i < len(lines):
            if '<lastvote>Объединение республиканцев</lastvote>\n' == lines[i]:
                lines[i] = '<lastvote>Доминион</lastvote>\n'
                # Записываем измененные строки в выходной файл
            file.write(lines[i])  # Записываем строку с <sy>
            i += 1  # Увеличиваем индекс для следующей итерации

    print("Изменения внесены, результат записан в", output_file)

