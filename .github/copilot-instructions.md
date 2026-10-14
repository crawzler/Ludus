# Instrucoes do Copilot para LUDUS

## Projeto

- LUDUS e um action roguelite de gladiadores com combate em arena e, futuramente, gestao de um Ludus.
- O projeto usa Godot 4 e GDScript. Confira a versao configurada em `project.godot` antes de usar recursos especificos da engine.
- A perspectiva planejada e 2D isometrica, com camera fixa.
- O contexto duravel esta em `docs/PROTOCOLO_DE_CONTINUIDADE.md`, `docs/ESTADO_ATUAL.md`, `docs/DECISOES.md`, `docs/GUIA_DE_DESENVOLVIMENTO.md` e `docs/DIARIO_DE_DESENVOLVIMENTO.md`.
- O GDD consolidado original esta em `docs/referencias/LUDUS_GDD_Consolidado_v1.0.docx`.

## Continuidade obrigatoria

- No inicio de cada sessao, leia o protocolo, estado atual, decisoes, guia e instrucoes; confira tambem `git status --short --branch`.
- Retome primeiro a tarefa ativa em `docs/ESTADO_ATUAL.md`. Nao confie em memoria de chats, resumos antigos ou caminhos pessoais.
- Antes de delegar ou editar, registre pedido, escopo, criterio de conclusao, responsavel e proximo passo no estado atual.
- Atualize o estado apos cada marco relevante e antes de parar. Ao concluir/interromper, acrescente uma entrada ao diario; registre mudancas de design em decisoes.
- Nunca descarte trabalho local para reconciliar um checkpoint. Compare arquivos e diff; preserve alteracoes nao commitadas.
- Trate o codigo presente como evidencia do que esta implementado; GDD e sugestoes nao aprovam por si so escopo futuro.
- Ao concluir e validar uma tarefa, o Coordinator revisa e faz commit local automaticamente, incluindo somente as alteracoes da tarefa, e faz push da branch ao GitHub logo apos o commit, conforme autorizacao permanente do usuario. Nunca envie alteracoes sem commit ou tarefas incompletas.
- O Coordinator decide quando os criterios do guia justificam atualizar versao, estagio (pre-alpha/alpha/beta/release) ou tag/release. Deve avisar o usuario antes de cada acao, informando mudanca planejada e evidencia/marco; depois pode executar sem pedir outra aprovacao se estiver dentro dos criterios documentados.
- Nao mude fase por calendario ou quantidade de commits. Baseie transicoes em escopo planejado concluido e validado; para mudancas de jogabilidade/legibilidade, inclua playtest humano. Antes de criar tag/release, avise o nome previsto, confirme que o commit alvo esta validado e publicado, e publique a tag conforme a autorizacao de push.
- Nunca misture no commit trabalho preexistente/de terceiros, arquivos gerados ou credenciais; se nao for possivel isolar com seguranca, pare e informe.
- Tarefa incompleta, bloqueada ou sem validacao suficiente nao recebe commit de conclusao; preserve o checkpoint e explique o que falta.

## Prioridades atuais

- O objetivo inicial e validar um prototipo de combate jogavel; nao construir o jogo completo.
- Priorize movimento e colisoes, combate e feedback de impacto, inimigo funcional, vida e resultado da luta.
- Depois de validar essa base, evolua para bloqueio, aparo, esquiva, troca de armas, execucoes, condicao da arma e HUD.
- Gestao do Ludus, economia, recrutamento, progressao permanente, narrativa extensa, chefes e arte final estao fora do prototipo inicial.
- Consulte o guia antes de ampliar o escopo. Nao invente requisitos que nao estejam no pedido ou no guia.

## Como trabalhar

- Converse em portugues brasileiro e use nomes claros e consistentes no codigo.
- Use o agente LUDUS Coordinator como ponto unico de contato e escolha as skills relevantes automaticamente pelo pedido.
- O Coordinator pode coordenar Planner, Developer e Playtester sem pedir ao usuario para repetir o pedido entre etapas.
- Antes de editar, examine os arquivos relevantes e explique brevemente o plano e quais arquivos pretende alterar.
- Implemente uma tarefa pequena e completa por vez. Reutilize os padroes ja existentes no projeto.
- Prefira recursos nativos da engine. Nao instale addons, dependencias ou ferramentas sem necessidade concreta e autorizacao do usuario.
- Nao altere configuracoes do projeto, controles ou estrutura de pastas sem necessidade para a tarefa.
- Ao modificar cenas ou scripts, preserve compatibilidade com a versao do Godot configurada no projeto.
- Nao declare uma funcionalidade concluida apenas porque o codigo foi escrito: indique como executa-la e verifica-la no Godot.
- Se nao puder executar ou validar uma mudanca, diga isso claramente e forneca os passos de verificacao.
- Ao corrigir erros, use a mensagem completa e o comportamento observado. Nao esconda erros com valores padrao ou tratamento silencioso.
- Nao sobrescreva alteracoes do usuario nem reverta arquivos que nao fazem parte da tarefa.

## Ao concluir uma tarefa

- Resuma o que mudou e liste os passos exatos para testar.
- Aponte riscos, decisoes em aberto e qualquer validacao que nao foi possivel fazer.
- Mantenha documentacao relacionada atualizada quando uma decisao de projeto ou um fluxo de trabalho mudar.
- Commits locais de tarefas concluidas e validadas sao automaticos; push ao GitHub tambem e automatico apos cada commit, conforme autorizado pelo usuario.
