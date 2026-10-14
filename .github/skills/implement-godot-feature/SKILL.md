---
name: implement-godot-feature
description: Planeje, implemente e valide uma funcionalidade pequena de LUDUS no Godot 4 usando GDScript. Use quando o usuario pedir uma nova mecanica, cena ou comportamento.
---

# Implementar uma funcionalidade de Godot

1. Leia `docs/PROTOCOLO_DE_CONTINUIDADE.md`, `docs/ESTADO_ATUAL.md`, `docs/DECISOES.md`, `.github/copilot-instructions.md` e `docs/GUIA_DE_DESENVOLVIMENTO.md`.
2. Confira a versao do Godot em `project.godot` e inspecione os arquivos relacionados antes de propor mudancas.
3. Se existir tarefa em andamento no checkpoint, continue do passo registrado em vez de recomecar.
4. Confirme que a tarefa pertence ao escopo atual. Se depender de uma decisao de design em aberto ou aumentar o escopo, pare e pergunte ao usuario.
5. Antes de editar, atualize o checkpoint com o plano, os arquivos provaveis e o criterio de verificacao.
6. Faca a menor alteracao completa. Use recursos nativos do Godot, tipos e padroes existentes; evite addons e abstractions desnecessarias.
7. Preserve o comportamento existente e mantenha cenas, scripts e recursos sincronizados. Registre marcos no checkpoint.
8. Valide com as ferramentas disponiveis. Se o editor ou o jogo nao puder ser executado, nao afirme que a funcionalidade foi testada.
9. Ao parar, atualize status, arquivos alterados, validacoes e proxima acao. Retorne um resumo para o Coordinator registrar no diario.

## Criterios de conclusao

- O comportamento solicitado e observavel no jogo.
- Erros e caminhos alternativos relevantes foram considerados.
- O usuario tem passos claros para verificar a mudanca.
- O guia de desenvolvimento foi atualizado se a tarefa alterar escopo ou uma decisao acordada.
