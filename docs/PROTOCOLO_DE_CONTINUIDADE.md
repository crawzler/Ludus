# LUDUS — Protocolo de continuidade e recuperacao

Este protocolo e a memoria duravel do projeto entre chats, agentes, aplicativos e interrupcoes. Ele nao depende da memoria de uma conversa. As fontes de contexto ficam junto com o jogo e podem ser preservadas no Git.

## Fontes de verdade

Leia-as nesta ordem; em caso de conflito, nao adivinhe:

1. `project.godot` e os arquivos reais do projeto: estado tecnico que existe de fato.
2. `docs/ESTADO_ATUAL.md`: checkpoint operacional, tarefa ativa e proximo passo exato.
3. `docs/DECISOES.md`: decisoes aprovadas, pendentes e substituidas.
4. `docs/GUIA_DE_DESENVOLVIMENTO.md`: escopo e criterios de desenvolvimento vigentes.
5. `docs/referencias/LUDUS_GDD_Consolidado_v1.0.docx`: GDD de referencia original; ideias nele ainda sujeitas a validacao nao sao automaticamente escopo aprovado.
6. `docs/DIARIO_DE_DESENVOLVIMENTO.md`: historico cronologico; e registro, nao substitui o estado atual.
7. `.github/copilot-instructions.md`, `.github/agents/` e `.github/skills/`: regras e papeis para Copilot/VS Code.

O codigo e os recursos presentes prevalecem sobre afirmacoes antigas no diario. Se o checkpoint estiver desatualizado, confira Git, arquivos e testes antes de retomar.

## Inicio obrigatorio de toda sessao

Todo agente ou pessoa que retomar o trabalho deve:

1. Abrir a raiz do repositorio que contem `project.godot`; nao confiar no nome da conversa ou em memoria previa.
2. Ler este protocolo, `docs/ESTADO_ATUAL.md`, `docs/DECISOES.md`, `docs/GUIA_DE_DESENVOLVIMENTO.md` e `.github/copilot-instructions.md`.
3. Conferir os papeis em `.github/agents/` e carregar somente as skills de `.github/skills/` pertinentes a tarefa.
4. Verificar `git status --short --branch`, o ultimo commit e as mudancas locais. Nunca descartar nem sobrescrever trabalho pendente.
5. Conferir `project.godot`, cenas/scripts reais e versao configurada antes de afirmar o que o jogo faz.
6. Continuar primeiro a tarefa ativa indicada em `docs/ESTADO_ATUAL.md`. Nao iniciar outra tarefa enquanto a anterior estiver `EM_ANDAMENTO` ou `BLOQUEADA`, a menos que o usuario decida explicitamente trocar de prioridade.
7. Informar ao usuario, em linguagem simples, o checkpoint encontrado e o proximo passo antes de fazer mudancas de codigo.

Se arquivos, Git e checkpoint discordarem, pare qualquer operacao destrutiva, preserve o trabalho e reconcilie as evidencias primeiro.

## Ciclo de trabalho com checkpoint

### Antes de delegar ou editar

- O LUDUS Coordinator registra em `docs/ESTADO_ATUAL.md` o pedido, objetivo, escopo, criterio de conclusao, agente responsavel, status `EM_ANDAMENTO` e primeiro proximo passo.
- O registro e salvo antes da delegacao. O especialista recebe uma tarefa autocontida e o caminho deste protocolo e do checkpoint.
- Uma tarefa de cada vez pode editar o projeto. Nao iniciar implementacoes concorrentes sobre os mesmos arquivos.
- Decisoes de design nao aprovadas ficam em `docs/DECISOES.md` como pendentes; nao se transformam em requisitos por inferencia.

### Durante a tarefa

- Atualize o checkpoint apos cada marco relevante, antes de uma operacao longa e sempre antes de parar.
- Registre arquivos lidos/alterados, resultado observado, comandos executados, testes, falhas e o proximo passo concreto.
- Preserve alteracoes nao relacionadas. Prefira mudancas pequenas e verificaveis.
- Se um agente, ferramenta, computador ou chat parar sem aviso, nao marque a tarefa como concluida. Retome a partir do ultimo checkpoint e confira o diff real.

### Ao concluir ou interromper

- Atualize `docs/ESTADO_ATUAL.md` para `CONCLUIDA`, `BLOQUEADA` ou `EM_ANDAMENTO`; inclua verificacoes reais e passos manuais restantes.
- Acrescente uma entrada datada a `docs/DIARIO_DE_DESENVOLVIMENTO.md` com resumo, arquivos, validacao e identificador da tarefa. O diario e append-only: nao reescreva entradas antigas; corrija por nova entrada.
- Se uma decisao mudar, registre-a em `docs/DECISOES.md` e atualize o guia correspondente.
- O Coordinator decide autonomamente quando os criterios documentados para mudar o estagio (pre-alpha/alpha/beta/release), incrementar a versao ou criar uma tag/release forem atingidos. Antes de cada acao, avisa o usuario com a mudanca planejada e a evidencia/marco que a justifica; em seguida pode executar sem pedir nova aprovacao, salvo se surgir uma decisao de escopo/design fora desses criterios.
- Mudancas de estagio e versao devem ter evidencia verificavel no prototipo, como criterios do guia concluidos, testes automatizados e playtest humano quando a legibilidade/jogabilidade for afetada. Nao antecipar estagio por calendario ou quantidade de commits.
- Antes de criar tag/release, confirmar que o commit alvo esta validado e publicado; informar previamente o nome da tag e o marco. Tags anotadas `v<versao>` sao para marcos/releases intencionais, e o envio da tag ocorre junto ao fluxo autorizado de publicacao.
- Para uma tarefa concluida e validada, o LUDUS Coordinator deve revisar o diff, atualizar checkpoint/diario, isolar os arquivos da tarefa e fazer um commit local descritivo automaticamente. Apos cada commit, deve enviar a branch ao GitHub com `push`, conforme autorizacao permanente do usuario registrada no checkpoint; se o push falhar, informe explicitamente e preserve os commits locais.
- Nunca faca commit de trabalho alheio/preexistente, credenciais ou arquivos gerados. Se houver alteracoes staged ou locais que nao possam ser isoladas com seguranca, nao misture nem descarte: pare e informe o bloqueio.
- O usuario autorizou push automatico apos cada commit de tarefa concluida e validada. Nao faca push de alteracoes sem commit, tarefas incompletas ou trabalho alheio. Se houver commits locais anteriores ja concluidos e pendentes de envio, faca push da branch apos conferir que a branch/remote correspondem ao repositorio e que o push normal pode avancar sem sobrescrever historico.
- Para trabalho incompleto, bloqueado ou ainda nao validado, nao crie um commit que o apresente como concluido; salve o checkpoint e explique o proximo passo.
- Na resposta ao usuario, resuma mudancas, validacoes, proximo passo e se existem alteracoes locais ainda nao commitadas.
- Nao declare teste manual feito sem o jogador executar o jogo no Godot.

## Campos do checkpoint

Mantenha sempre estas informacoes em `docs/ESTADO_ATUAL.md`:

- data e hora local do ultimo checkpoint;
- fase/marco do projeto e estado geral;
- tarefa ativa, status e responsavel;
- pedido original, objetivo, escopo e criterio de conclusao;
- ultimo passo concluido e resultado verificavel;
- arquivos criados, alterados ou inspecionados;
- validacoes executadas e resultado, incluindo falhas;
- trabalho local ainda nao commitado, se conhecido;
- bloqueios, decisoes pendentes e riscos;
- proxima acao exata, pequena e executavel;
- registro mais recente correspondente no diario.

Atualize a secao de checkpoint em vez de acumular varios estados atuais contraditorios. O historico fica no diario.

## Recuperar de falha ou contexto perdido

1. Reabra o repositorio e siga o inicio obrigatorio.
2. Leia a tarefa ativa e o ultimo checkpoint.
3. Inspecione `git status`, `git diff` e os arquivos mencionados. Nao use comandos de descarte, reset ou checkout para "limpar" a situacao.
4. Compare o trabalho real com o ultimo passo registrado. Se uma edicao ficou pela metade, corrija-a ou reverta somente a alteracao incompleta da tarefa ativa, preservando outras mudancas.
5. Continue do campo "Proxima acao exata". Se nao houver evidencia suficiente, pergunte ao usuario usando perguntas objetivas.
6. Registre a retomada no diario quando ela produzir progresso ou mudar o diagnostico.

## Retomar em outro aplicativo ou agente

Este repositorio guarda as definicoes reutilizaveis:

- Agentes VS Code/Copilot: `.github/agents/*.agent.md`.
- Instrucoes de projeto: `.github/copilot-instructions.md`.
- Skills: `.github/skills/*/SKILL.md`.
- Contexto portavel e estado: pasta `docs/`.

Se o novo aplicativo aceitar custom agents e skills, adapte/importa os arquivos acima sem mudar suas regras. Se nao aceitar, envie este prompt junto dos documentos indicados:

> Voce esta continuando o desenvolvimento do LUDUS. Nao confie em memoria de outro chat. Leia `docs/PROTOCOLO_DE_CONTINUIDADE.md`, `docs/ESTADO_ATUAL.md`, `docs/DECISOES.md`, `docs/GUIA_DE_DESENVOLVIMENTO.md`, `.github/copilot-instructions.md` e os arquivos de agentes/skills relevantes. Inspecione o projeto e o estado Git. Continue exatamente a tarefa ativa a partir do ultimo checkpoint; nao reinicie trabalho concluido, nao descarte alteracoes locais e nao invente decisoes. Se nao puder acessar o repositorio ou faltar contexto essencial, pare e diga o que precisa. Responda em portugues brasileiro. Ao iniciar, diga qual checkpoint encontrou e qual sera o proximo passo. Ao parar, atualize o checkpoint e o diario.

## Durabilidade e Git

- Documentos no disco ajudam a recuperar uma interrupcao local; commits locais preservam marcos no historico do Git, e somente `push` envia esses marcos ao GitHub.
- Confira sempre se o checkpoint, codigo e documentos estao incluidos no mesmo commit coerente.
- Commits locais sao automaticos somente para tarefas concluidas, validadas e isoladas com seguranca. O usuario autorizou push automatico apos esses commits; alteracoes remotas fora desse fluxo continuam exigindo autorizacao explicita.
- Antes de encerrar, avise se o checkpoint ainda existe apenas em alteracoes locais.
- Um app diferente ou computador diferente so pode retomar os dados que recebeu: sincronize o repositorio e inclua documentos de referencia necessarios, sem credenciais ou caminhos pessoais.
