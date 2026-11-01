# 🏋️‍♂️ GYMVENTURE

> **Projeto Concluído** | Trabalho de Conclusão de Curso (TCC) em Desenvolvimento de Sistemas.

O **Gymventure** é um jogo digital desenvolvido em **Godot Engine** como projeto de conclusão de curso para a obtenção do título de Técnico em Desenvolvimento de Sistemas pela Etec. 

O projeto engloba mecânicas de jogo desenvolvidas em GDScript, persistência de dados local (`LOCALDB`), arquitetura de controle de estados (`GameState`) e gerenciamento dinâmico de áudio (`MusicController`).

---

## 🛠️ Tecnologias e Arquitetura Utilizadas
- **Engine:** Godot Engine
- **Linguagem:** GDScript
- **Padrões e Sistemas implementados:**
  - 📊 **LOCALDB:** Sistema de armazenamento local para persistência de dados.
  - 🔄 **GameState:** Autoload/Singleton centralizado para controle de fluxo de telas e variáveis globais do jogo.
  - 🎵 **MusicController:** Gerenciador de áudio dinâmico para transições de trilha sonora entre cenas.

---

## 📁 Estrutura do Projeto
O repositório contém o código-fonte completo estruturado nas seguintes pastas principais:
- `/assets` & `/tcc-musica`: Recursos visuais e trilhas sonoras.
- `/personagens` & `/equipamentos`: Sprites, animações e objetos do jogo.
- `/scripts`: Lógicas de comportamento e programação do sistema.
- `/telas`: Cenas da Godot estruturadas para menus e gameplay.
- `Gymventure.exe`: Executável compilado para Windows.

---

## 🎮 Como Rodar o Jogo

### Executável Direto
1. Faça o download do arquivo `Gymventure.exe` na raiz do projeto.
2. Execute o arquivo no Windows para testar o jogo finalizado.

### Executando o Código Fonte
1. Certifique-se de ter a **Godot Engine** instalada no computador.
2. Faça o clone deste repositório:
   ```bash
   git clone https://github.com
   ```
3. Abra a Godot Engine, importe o arquivo `project.godot` e execute o projeto (`F5`).

---
*Este repositório serve como registro histórico e portfólio de um projeto acadêmico finalizado com sucesso.*
