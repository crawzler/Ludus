---
name: debug-godot-project
description: Investigue e corrija erros de execucao, importacao, cenas ou scripts em um projeto Godot 4. Use quando algo nao funcionar como esperado.
---

# Diagnosticar problemas no Godot

1. Leia `docs/PROTOCOLO_DE_CONTINUIDADE.md`, `docs/ESTADO_ATUAL.md`, `docs/DECISOES.md` e `.github/copilot-instructions.md`; confira Git/diff antes de editar.
2. Continue do checkpoint ativo se o erro ja estiver registrado, sem descartar mudancas locais.
3. Obtenha o erro completo, os passos para reproduzi-lo e o resultado esperado, se ainda nao foram fornecidos.
4. Consulte as instrucoes do repositorio e identifique a versao do Godot em `project.godot`.
5. Siga o caminho do erro pelos arquivos e recursos envolvidos. Procure a causa raiz antes de editar.
6. Explique a causa mais provavel e o plano de correcao antes de fazer uma mudanca ampla ou dificil de reverter.
7. Atualize o checkpoint antes da correcao, em cada marco relevante e antes de parar.
8. Corrija de forma localizada. Nao suprima erros, nao adicione fallbacks silenciosos e nao mude sistemas sem relacao.
9. Reproduza ou execute a verificacao mais proxima disponivel. Diferencie claramente verificacao automatica de teste manual.
10. Informe causa, arquivos alterados, validacoes e proxima acao ao Coordinator para registro duravel.

Se a evidencia for insuficiente, nao invente uma causa: solicite a mensagem ou os passos que faltam.
