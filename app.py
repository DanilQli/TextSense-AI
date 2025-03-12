import torch
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
    app.run()