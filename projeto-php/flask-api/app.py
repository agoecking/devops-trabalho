from flask import Flask, request, jsonify
from flask import send_from_directory
import requests
import os

app = Flask(__name__)

API_PHP_URL = "http://php-app/produtos.php"

# Lista temporária para simular registros de pagamento
registros_pagamento = []

@app.route("/api-flask/pagar", methods=["POST"])
def registrar_pagamento():
    try:
        dados = request.get_json()
        id_produto = dados.get("id_produto")
        valor = dados.get("valor")

        if not id_produto or not valor:
            return jsonify({"erro": "Informe id_produto e valor"}), 400

        # Consulta produtos na API PHP
        response = requests.get(API_PHP_URL)
        produtos = response.json()

        produto = next((p for p in produtos if str(p["id"]) == str(id_produto)), None)

        if not produto:
            return jsonify({"erro": "Produto não encontrado"}), 404

        payload = {
            "id_produto": id_produto,
            "nome_produto": produto["nome"],
            "valor": valor
        }

        # Envia o pagamento para a API PHP
        resposta_php = requests.post("http://php-app/registrar_pagamento.php", json=payload)

        return jsonify({
            "mensagem": "Pagamento processado",
            "retorno_php": resposta_php.json()
        })

    except Exception as e:
        return jsonify({"erro": str(e)}), 500


@app.route("/api-flask/pagamentos", methods=["GET"])
def listar_pagamentos():
    return jsonify(registros_pagamento)

@app.route("/")
def servir_html():
    return send_from_directory(os.path.join(app.root_path, "template"), "index.html")

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)
