"""import torch
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


if __name__ == '__main__':
    main()